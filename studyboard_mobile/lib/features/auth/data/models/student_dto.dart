import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

/// Maps Supabase data sources to the [Student] domain model.
///
/// Two construction paths exist:
/// - Minimal from auth.users (id + email only).
/// - Full profile from the public.students table row.
class StudentDto {
  const StudentDto({
    required this.id,
    required this.email,
    required this.lastActiveAt,
    required this.createdAt,
    this.name = '',
    this.district = '',
    this.school = '',
    this.notificationsEnabled = true,
    this.fcmToken,
    this.deactivatedAt,
    this.deletedAt,
  });

  factory StudentDto.fromSupabaseUser(User user) {
    final now = DateTime.now().toUtc().toIso8601String();
    return StudentDto(
      id: user.id,
      email: user.email ?? '',
      lastActiveAt: user.lastSignInAt ?? now,
      createdAt: user.createdAt,
    );
  }

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: (json['name'] as String?) ?? '',
      district: (json['district'] as String?) ?? '',
      school: (json['school'] as String?) ?? '',
      notificationsEnabled: (json['notifications_enabled'] as bool?) ?? true,
      lastActiveAt: json['last_active_at'] as String,
      createdAt: json['created_at'] as String,
      fcmToken: json['fcm_token'] as String?,
      deactivatedAt: json['deactivated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  final String id;
  final String email;
  final String name;
  final String district;
  final String school;
  final bool notificationsEnabled;
  final String lastActiveAt;
  final String createdAt;
  final String? fcmToken;
  final String? deactivatedAt;
  final String? deletedAt;

  Student toStudent() => Student(
        id: id,
        email: email,
        name: name,
        district: district,
        school: school,
        notificationsEnabled: notificationsEnabled,
        lastActiveAt: lastActiveAt,
        createdAt: createdAt,
        fcmToken: fcmToken,
        deactivatedAt: deactivatedAt,
        deletedAt: deletedAt,
      );
}
