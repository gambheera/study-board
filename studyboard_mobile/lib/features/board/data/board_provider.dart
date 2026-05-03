import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/board/data/board_repository_impl.dart';
import 'package:studyboard_mobile/features/board/domain/board_repository.dart';

part 'board_provider.g.dart';

@riverpod
BoardRepository boardRepository(Ref ref) {
  return BoardRepositoryImpl(ref.watch(appDatabaseProvider).taskDao);
}
