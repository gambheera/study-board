import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';

part 'content_cache_service.g.dart';

class ContentCacheService {
  const ContentCacheService(this._dao, this._cacheManager);

  final ContentDao _dao;
  final BaseCacheManager _cacheManager;

  Future<void> prefetchAll() async {
    final urls = await _dao.getAllImageUrlsInTopicOrder();
    await Future.wait(
      urls.map((url) async {
        try {
          await _cacheManager.downloadFile(url);
        } on Exception catch (_) {}
      }),
    );
  }

  Future<bool> hasContentSeeded() => _dao.hasAnyLessons();
}

@Riverpod(keepAlive: true)
ContentCacheService contentCacheService(Ref ref) {
  return ContentCacheService(
    ref.watch(contentDaoProvider),
    DefaultCacheManager(),
  );
}

@Riverpod(keepAlive: true)
Future<bool> contentSeeded(Ref ref) =>
    ref.watch(contentCacheServiceProvider).hasContentSeeded();
