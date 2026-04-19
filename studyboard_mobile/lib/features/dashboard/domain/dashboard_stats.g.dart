// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeakTopic _$WeakTopicFromJson(Map<String, dynamic> json) => _WeakTopic(
  topicId: json['topic_id'] as String,
  topicTitle: json['topic_title'] as String,
  accuracyPercent: (json['accuracy_percent'] as num).toDouble(),
);

Map<String, dynamic> _$WeakTopicToJson(_WeakTopic instance) =>
    <String, dynamic>{
      'topic_id': instance.topicId,
      'topic_title': instance.topicTitle,
      'accuracy_percent': instance.accuracyPercent,
    };

_DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    _DashboardStats(
      coveragePercent: (json['coverage_percent'] as num).toDouble(),
      overallAccuracy: (json['overall_accuracy'] as num).toDouble(),
      streak: (json['streak'] as num).toInt(),
      tasksInDone: (json['tasks_in_done'] as num).toInt(),
      weakTopics: (json['weak_topics'] as List<dynamic>)
          .map((e) => WeakTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardStatsToJson(_DashboardStats instance) =>
    <String, dynamic>{
      'coverage_percent': instance.coveragePercent,
      'overall_accuracy': instance.overallAccuracy,
      'streak': instance.streak,
      'tasks_in_done': instance.tasksInDone,
      'weak_topics': instance.weakTopics,
    };
