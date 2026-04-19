import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';

part 'task.freezed.dart';
part 'task.g.dart';

class TaskStatusConverter implements JsonConverter<TaskStatus, String> {
  const TaskStatusConverter();

  @override
  TaskStatus fromJson(String json) => TaskStatusX.fromString(json);

  @override
  String toJson(TaskStatus object) => object.toDbString();
}

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'lesson_id') required String lessonId,
    @TaskStatusConverter()
    @JsonKey(name: 'task_status')
    required TaskStatus taskStatus,
    @JsonKey(name: 'curiosity_completed')
    required bool curiosityCompleted,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
