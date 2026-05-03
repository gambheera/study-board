import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

part 'backlog_item.freezed.dart';

@freezed
abstract class BacklogItem with _$BacklogItem {
  const factory BacklogItem({
    required String taskId,
    required String lessonId,
    required String lessonTitle,
    required String topicId,
    required String topicTitle,
    required String contentTrack,
    required TaskStatus taskStatus,
    required bool curiosityCompleted,
    required int lessonOrderIndex,
    required int topicOrderIndex,
  }) = _BacklogItem;
}
