import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
abstract class WeakTopic with _$WeakTopic {
  const factory WeakTopic({
    @JsonKey(name: 'topic_id') required String topicId,
    @JsonKey(name: 'topic_title') required String topicTitle,
    @JsonKey(name: 'accuracy_percent') required double accuracyPercent,
  }) = _WeakTopic;

  factory WeakTopic.fromJson(Map<String, dynamic> json) =>
      _$WeakTopicFromJson(json);
}

@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @JsonKey(name: 'coverage_percent') required double coveragePercent,
    @JsonKey(name: 'overall_accuracy') required double overallAccuracy,
    required int streak,
    @JsonKey(name: 'tasks_in_done') required int tasksInDone,
    @JsonKey(name: 'weak_topics') required List<WeakTopic> weakTopics,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
}
