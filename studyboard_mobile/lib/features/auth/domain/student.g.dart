// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Student _$StudentFromJson(Map<String, dynamic> json) => _Student(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  district: json['district'] as String,
  school: json['school'] as String,
  notificationsEnabled: json['notifications_enabled'] as bool,
  lastActiveAt: json['last_active_at'] as String,
  createdAt: json['created_at'] as String,
  fcmToken: json['fcm_token'] as String?,
  deactivatedAt: json['deactivated_at'] as String?,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$StudentToJson(_Student instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'district': instance.district,
  'school': instance.school,
  'notifications_enabled': instance.notificationsEnabled,
  'last_active_at': instance.lastActiveAt,
  'created_at': instance.createdAt,
  'fcm_token': instance.fcmToken,
  'deactivated_at': instance.deactivatedAt,
  'deleted_at': instance.deletedAt,
};
