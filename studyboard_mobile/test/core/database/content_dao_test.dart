import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';

void main() {
  late AppDatabase db;
  late ContentDao contentDao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    contentDao = db.contentDao;
  });

  tearDown(() async => db.close());

  group('ContentDao.upsertSubject', () {
    test('writes subject to subjects table', () async {
      await contentDao.upsertSubject(SubjectsTableCompanion.insert(
        id: 'sub-1',
        name: 'A/L Chemistry',
      ));
      final subjects = await contentDao.getSubjects();
      expect(subjects.length, 1);
      expect(subjects.first.name, 'A/L Chemistry');
      expect(subjects.first.quizPassThreshold, closeTo(0.8, 0.001));
    });

    test('on conflict updates name and quizPassThreshold', () async {
      await contentDao.upsertSubject(SubjectsTableCompanion.insert(
        id: 'sub-1',
        name: 'Old Name',
        quizPassThreshold: const Value(0.7),
      ));
      await contentDao.upsertSubject(SubjectsTableCompanion.insert(
        id: 'sub-1',
        name: 'A/L Chemistry',
        quizPassThreshold: const Value(0.8),
      ));
      final subjects = await contentDao.getSubjects();
      expect(subjects.length, 1);
      expect(subjects.first.name, 'A/L Chemistry');
      expect(subjects.first.quizPassThreshold, closeTo(0.8, 0.001));
    });
  });

  group('ContentDao.upsertTopic', () {
    test('writes topic to topics table', () async {
      await contentDao.upsertTopic(TopicsTableCompanion.insert(
        id: 'topic-1',
        subjectId: 'sub-1',
        title: 'Atomic Structure',
        orderIndex: const Value(1),
      ));
      final topics = await db.select(db.topicsTable).get();
      expect(topics.length, 1);
      expect(topics.first.title, 'Atomic Structure');
    });

    test('on conflict updates title', () async {
      await contentDao.upsertTopic(TopicsTableCompanion.insert(
        id: 'topic-1',
        subjectId: 'sub-1',
        title: 'Old Title',
      ));
      await contentDao.upsertTopic(TopicsTableCompanion.insert(
        id: 'topic-1',
        subjectId: 'sub-1',
        title: 'Atomic Structure',
      ));
      final topics = await db.select(db.topicsTable).get();
      expect(topics.length, 1);
      expect(topics.first.title, 'Atomic Structure');
    });
  });

  group('ContentDao.upsertLesson', () {
    test('writes lesson to lessons table', () async {
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'lesson-1',
        topicId: 'topic-1',
        title: 'Atomic Structure — Theory',
        contentText: 'Atoms have protons and neutrons.',
        contentTrack: 'theory',
      ));
      final lessons = await db.select(db.lessonsTable).get();
      expect(lessons.length, 1);
      expect(lessons.first.contentText, 'Atoms have protons and neutrons.');
      expect(lessons.first.contentTrack, 'theory');
    });

    test('on conflict updates content_text', () async {
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'lesson-1',
        topicId: 'topic-1',
        title: 'Atomic Structure — Theory',
        contentText: 'original text',
        contentTrack: 'theory',
      ));
      await contentDao.upsertLesson(LessonsTableCompanion.insert(
        id: 'lesson-1',
        topicId: 'topic-1',
        title: 'Atomic Structure — Theory',
        contentText: 'updated text',
        contentTrack: 'theory',
      ));
      final lessons = await db.select(db.lessonsTable).get();
      expect(lessons.length, 1);
      expect(lessons.first.contentText, 'updated text');
    });
  });

  group('ContentDao.upsertQuizQuestion', () {
    test('writes quiz question to quiz_questions table', () async {
      await contentDao.upsertQuizQuestion(QuizQuestionsTableCompanion.insert(
        id: 'q-1',
        lessonId: 'lesson-1',
        questionText: 'What is the atomic number?',
        optionA: 'Mass number',
        optionB: 'Proton count',
        optionC: 'Neutron count',
        optionD: 'Electron shells',
        correctOption: 'b',
      ));
      final questions = await db.select(db.quizQuestionsTable).get();
      expect(questions.length, 1);
      expect(questions.first.questionText, 'What is the atomic number?');
      expect(questions.first.correctOption, 'b');
    });

    test('on conflict updates question_text', () async {
      await contentDao.upsertQuizQuestion(QuizQuestionsTableCompanion.insert(
        id: 'q-1',
        lessonId: 'lesson-1',
        questionText: 'Original question?',
        optionA: 'A',
        optionB: 'B',
        optionC: 'C',
        optionD: 'D',
        correctOption: 'a',
      ));
      await contentDao.upsertQuizQuestion(QuizQuestionsTableCompanion.insert(
        id: 'q-1',
        lessonId: 'lesson-1',
        questionText: 'Updated question?',
        optionA: 'A',
        optionB: 'B',
        optionC: 'C',
        optionD: 'D',
        correctOption: 'b',
      ));
      final questions = await db.select(db.quizQuestionsTable).get();
      expect(questions.length, 1);
      expect(questions.first.questionText, 'Updated question?');
      expect(questions.first.correctOption, 'b');
    });
  });

  group('ContentDao.upsertPastPaperQuestion', () {
    test('writes past paper question to table', () async {
      await contentDao.upsertPastPaperQuestion(
        PastPaperQuestionsTableCompanion.insert(
          id: 'pp-1',
          lessonId: 'lesson-1',
          topicId: 'topic-1',
          questionText: 'Explain the trend in atomic radius.',
          year: const Value(2019),
        ),
      );
      final questions = await db.select(db.pastPaperQuestionsTable).get();
      expect(questions.length, 1);
      expect(questions.first.year, 2019);
    });

    test('year field is nullable', () async {
      await contentDao.upsertPastPaperQuestion(
        PastPaperQuestionsTableCompanion.insert(
          id: 'pp-2',
          lessonId: 'lesson-1',
          topicId: 'topic-1',
          questionText: 'Question without year.',
        ),
      );
      final questions = await db.select(db.pastPaperQuestionsTable).get();
      expect(questions.first.year, isNull);
    });
  });
}
