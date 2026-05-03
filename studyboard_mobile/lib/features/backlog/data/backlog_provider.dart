import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/backlog/data/backlog_repository_impl.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_repository.dart';

part 'backlog_provider.g.dart';

@riverpod
BacklogRepository backlogRepository(Ref ref) {
  return BacklogRepositoryImpl(ref.watch(appDatabaseProvider).taskDao);
}
