import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/core/supabase/supabase_client_provider.dart';
import 'package:studyboard_mobile/features/board/data/content_repository_impl.dart';
import 'package:studyboard_mobile/features/board/domain/content_repository.dart';

part 'content_provider.g.dart';

@Riverpod(keepAlive: true)
ContentRepository contentRepository(Ref ref) => ContentRepositoryImpl(
  ref.watch(supabaseClientProvider),
  ref.watch(appDatabaseProvider),
  ref.watch(contentDaoProvider),
  ref.watch(taskDaoProvider),
);
