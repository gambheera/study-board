import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
abstract class Student with _$Student {
  const factory Student({
    required String id,
    required String name,
    required String email,
    required String district,
    required String school,
    @JsonKey(name: 'notifications_enabled') required bool notificationsEnabled,
    @JsonKey(name: 'last_active_at') required String lastActiveAt,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'fcm_token') String? fcmToken,
    @JsonKey(name: 'deactivated_at') String? deactivatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
