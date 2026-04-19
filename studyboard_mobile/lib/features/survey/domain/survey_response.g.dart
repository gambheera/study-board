// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SurveyResponse _$SurveyResponseFromJson(Map<String, dynamic> json) =>
    _SurveyResponse(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      responses: json['responses'] as String,
      respondedAt: json['responded_at'] as String,
    );

Map<String, dynamic> _$SurveyResponseToJson(_SurveyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'responses': instance.responses,
      'responded_at': instance.respondedAt,
    };
