import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/content_cache/content_cache_service.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';

class _MockContentDao extends Mock implements ContentDao {}

class _MockBaseCacheManager extends Mock implements BaseCacheManager {}

class _MockFileInfo extends Mock implements FileInfo {}

void main() {
  group('ContentCacheService', () {
    late _MockContentDao mockDao;
    late _MockBaseCacheManager mockCacheManager;
    late ContentCacheService service;

    setUp(() {
      mockDao = _MockContentDao();
      mockCacheManager = _MockBaseCacheManager();
      service = ContentCacheService(mockDao, mockCacheManager);
    });

    group('prefetchAll', () {
      test('calls downloadFile for each URL returned by dao', () async {
        when(() => mockDao.getAllImageUrlsInTopicOrder()).thenAnswer(
          (_) async => ['https://a.com/1.png', 'https://a.com/2.png'],
        );
        when(() => mockCacheManager.downloadFile(any()))
            .thenAnswer((_) async => _MockFileInfo());

        await service.prefetchAll();

        verify(
          () => mockCacheManager.downloadFile('https://a.com/1.png'),
        ).called(1);
        verify(
          () => mockCacheManager.downloadFile('https://a.com/2.png'),
        ).called(1);
      });

      test('does nothing when URL list is empty', () async {
        when(() => mockDao.getAllImageUrlsInTopicOrder())
            .thenAnswer((_) async => []);

        await service.prefetchAll();

        verifyNever(() => mockCacheManager.downloadFile(any()));
      });

      test('silently ignores per-URL download errors', () async {
        when(() => mockDao.getAllImageUrlsInTopicOrder())
            .thenAnswer((_) async => ['https://a.com/fail.png']);
        when(() => mockCacheManager.downloadFile(any()))
            .thenAnswer((_) => Future.error(Exception('network error')));

        await expectLater(service.prefetchAll(), completes);
      });
    });

    group('hasContentSeeded', () {
      test('returns true when dao has lessons', () async {
        when(() => mockDao.hasAnyLessons()).thenAnswer((_) async => true);

        expect(await service.hasContentSeeded(), isTrue);
      });

      test('returns false when dao has no lessons', () async {
        when(() => mockDao.hasAnyLessons()).thenAnswer((_) async => false);

        expect(await service.hasContentSeeded(), isFalse);
      });
    });
  });

  group('ContentDao.getAllImageUrlsInTopicOrder', () {
    late AppDatabase db;
    late ContentDao contentDao;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      contentDao = db.contentDao;
    });

    tearDown(() async => db.close());

    test('returns empty list when no lessons exist', () async {
      final urls = await contentDao.getAllImageUrlsInTopicOrder();

      expect(urls, isEmpty);
    });

    test('extracts image URLs from markdown content', () async {
      await _seedSubjectAndTopic(contentDao, topicOrderIndex: 1);
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'l-1',
        topicId: 'topic-1',
        title: 'Lesson 1',
        contentText:
            'Some text\n![alt](https://example.com/img.png)\nMore text',
        contentTrack: 'theory',
      ));

      final urls = await contentDao.getAllImageUrlsInTopicOrder();

      expect(urls, ['https://example.com/img.png']);
    });

    test('ignores non-image markdown links', () async {
      await _seedSubjectAndTopic(contentDao, topicOrderIndex: 1);
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'l-1',
        topicId: 'topic-1',
        title: 'Lesson 1',
        contentText: '[link text](https://example.com/page) no image here',
        contentTrack: 'theory',
      ));

      final urls = await contentDao.getAllImageUrlsInTopicOrder();

      expect(urls, isEmpty);
    });

    test('returns URLs ordered by topic orderIndex ascending', () async {
      await contentDao.upsertSubject(
        SubjectsTableCompanion.insert(id: 'sub-1', name: 'Chemistry'),
      );
      await contentDao.upsertTopic(TopicsTableCompanion.insert(
        id: 'topic-2',
        subjectId: 'sub-1',
        title: 'Topic 2',
        orderIndex: const Value(2),
      ));
      await contentDao.upsertTopic(TopicsTableCompanion.insert(
        id: 'topic-1',
        subjectId: 'sub-1',
        title: 'Topic 1',
        orderIndex: const Value(1),
      ));
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'l-2',
        topicId: 'topic-2',
        title: 'Lesson 2',
        contentText: '![](https://example.com/topic2.png)',
        contentTrack: 'theory',
      ));
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'l-1',
        topicId: 'topic-1',
        title: 'Lesson 1',
        contentText: '![](https://example.com/topic1.png)',
        contentTrack: 'theory',
      ));

      final urls = await contentDao.getAllImageUrlsInTopicOrder();

      expect(urls.first, 'https://example.com/topic1.png');
      expect(urls.last, 'https://example.com/topic2.png');
    });

    test('extracts multiple URLs from a single lesson', () async {
      await _seedSubjectAndTopic(contentDao, topicOrderIndex: 1);
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'l-1',
        topicId: 'topic-1',
        title: 'Lesson 1',
        contentText:
            '![a](https://cdn.com/a.png)\n![b](https://cdn.com/b.png)',
        contentTrack: 'theory',
      ));

      final urls = await contentDao.getAllImageUrlsInTopicOrder();

      expect(urls, ['https://cdn.com/a.png', 'https://cdn.com/b.png']);
    });
  });
}

Future<void> _seedSubjectAndTopic(
  ContentDao dao, {
  required int topicOrderIndex,
}) async {
  await dao.upsertSubject(
    SubjectsTableCompanion.insert(id: 'sub-1', name: 'Chemistry'),
  );
  await dao.upsertTopic(TopicsTableCompanion.insert(
    id: 'topic-1',
    subjectId: 'sub-1',
    title: 'Topic 1',
    orderIndex: Value(topicOrderIndex),
  ));
}
