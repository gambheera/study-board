import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/backlog/data/backlog_provider.dart';
import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';

part 'backlog_items_provider.g.dart';

@riverpod
Stream<List<BacklogItem>> backlogItems(
  Ref ref, {
  required String studentId,
  String? contentTrack,
}) {
  return ref
      .watch(backlogRepositoryProvider)
      .watchBacklogTasks(studentId, contentTrack: contentTrack);
}
