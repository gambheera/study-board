import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';
import 'package:studyboard_mobile/features/board/data/board_provider.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

part 'board_providers.g.dart';

@riverpod
Stream<List<BacklogItem>> boardItems(
  Ref ref, {
  required String studentId,
  required TaskStatus status,
}) {
  return ref.watch(boardRepositoryProvider).watchBoardItems(studentId, status);
}

@riverpod
Stream<bool> hasDoneTasks(Ref ref, {required String studentId}) {
  return ref.watch(boardRepositoryProvider).watchHasDoneTasks(studentId);
}
