import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_response.freezed.dart';
part 'survey_response.g.dart';

@freezed
abstract class SurveyResponse with _$SurveyResponse {
  const factory SurveyResponse({
    required String id,
    @JsonKey(name: 'student_id') required String studentId,
    required String responses,
    @JsonKey(name: 'responded_at') required String respondedAt,
  }) = _SurveyResponse;

  factory SurveyResponse.fromJson(Map<String, dynamic> json) =>
      _$SurveyResponseFromJson(json);
}
