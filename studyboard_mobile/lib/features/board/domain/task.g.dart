// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  studentId: json['student_id'] as String,
  lessonId: json['lesson_id'] as String,
  taskStatus: const TaskStatusConverter().fromJson(
    json['task_status'] as String,
  ),
  curiosityCompleted: json['curiosity_completed'] as bool,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'student_id': instance.studentId,
  'lesson_id': instance.lessonId,
  'task_status': const TaskStatusConverter().toJson(instance.taskStatus),
  'curiosity_completed': instance.curiosityCompleted,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
