import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/lesson_tasks_table.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/quiz_attempts_table.dart';
import 'package:studyboard_mobile/core/database/tables/sessions_table.dart';
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';
import 'package:studyboard_mobile/features/board/domain/task_status.dart';
import 'package:studyboard_mobile/features/dashboard/domain/dashboard_stats.dart';

part 'dashboard_dao.g.dart';

@DriftAccessor(
  tables: [
    LessonTasksTable,
    QuizAttemptsTable,
    LessonsTable,
    TopicsTable,
    SessionsTable,
  ],
)
class DashboardDao extends DatabaseAccessor<AppDatabase>
    with _$DashboardDaoMixin {
  DashboardDao(super.attachedDatabase);

  Future<double> getCoveragePercent(
    String studentId,
    String subjectId,
  ) async {
    final result = await customSelect(
      '''
      SELECT
        CAST(SUM(CASE WHEN lt.task_status = ? THEN 1 ELSE 0 END) AS REAL)
          / CAST(COUNT(*) AS REAL) AS coverage
      FROM lesson_tasks lt
      JOIN lessons l ON lt.lesson_id = l.id
      JOIN topics t ON l.topic_id = t.id
      WHERE lt.student_id = ? AND t.subject_id = ?
      ''',
      variables: [
        Variable(TaskStatus.done.toDbString()),
        Variable(studentId),
        Variable(subjectId),
      ],
    ).getSingleOrNull();
    return (result?.data['coverage'] as double?) ?? 0.0;
  }

  Future<List<WeakTopic>> getWeakTopics(
    String studentId,
    String subjectId,
  ) async {
    final rows = await customSelect(
      '''
      SELECT t.id AS topic_id, t.title AS topic_title,
        CAST(SUM(CASE WHEN qa.passed = 1 THEN 1 ELSE 0 END) AS REAL)
          / CAST(COUNT(qa.id) AS REAL) * 100 AS accuracy_percent
      FROM topics t
      JOIN lessons l ON l.topic_id = t.id
      JOIN quiz_attempts qa ON qa.lesson_id = l.id AND qa.student_id = ?
      WHERE t.subject_id = ?
      GROUP BY t.id
      HAVING accuracy_percent < 60
      ORDER BY accuracy_percent ASC
      ''',
      variables: [Variable(studentId), Variable(subjectId)],
    ).get();
    return rows
        .map(
          (r) => WeakTopic(
            topicId: r.data['topic_id'] as String,
            topicTitle: r.data['topic_title'] as String,
            accuracyPercent: (r.data['accuracy_percent'] as num).toDouble(),
          ),
        )
        .toList();
  }

  /// Returns the student's current streak in calendar days.
  ///
  /// [utcOffsetMinutes] — the device's UTC offset (e.g. 330 for UTC+5:30,
  /// -120 for UTC-2). Pass `DateTime.now().timeZoneOffset.inMinutes`.
  /// Defaults to 0 (UTC) when omitted.
  Future<int> getStreak(
    String studentId, {
    int utcOffsetMinutes = 0,
  }) async {
    final sign = utcOffsetMinutes >= 0 ? '+' : '-';
    final offsetStr = '$sign${utcOffsetMinutes.abs()} minutes';

    final rows = await customSelect(
      '''
      SELECT DISTINCT date(datetime(started_at, ?)) AS session_date
      FROM sessions
      WHERE student_id = ?
      ORDER BY session_date DESC
      ''',
      variables: [Variable(offsetStr), Variable(studentId)],
    ).get();

    if (rows.isEmpty) return 0;

    final mostRecentStr = rows.first.data['session_date'] as String;
    final localNow =
        DateTime.now().toUtc().add(Duration(minutes: utcOffsetMinutes));
    final localYesterday = localNow.subtract(const Duration(days: 1));
    final todayStr = _toDateString(localNow);
    final yesterdayStr = _toDateString(localYesterday);

    if (mostRecentStr != todayStr && mostRecentStr != yesterdayStr) return 0;

    var streak = 1;
    var prev = DateTime.parse(mostRecentStr);
    for (var i = 1; i < rows.length; i++) {
      final curr = DateTime.parse(rows[i].data['session_date'] as String);
      if (prev.difference(curr).inDays == 1) {
        streak++;
        prev = curr;
      } else {
        break;
      }
    }
    return streak;
  }

  String _toDateString(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}'
      '-${d.day.toString().padLeft(2, '0')}';

  Future<double> getOverallAccuracy(
    String studentId,
    String subjectId,
  ) async {
    final result = await customSelect(
      '''
      SELECT
        CAST(SUM(CASE WHEN qa.passed = 1 THEN 1 ELSE 0 END) AS REAL)
          / CAST(COUNT(qa.id) AS REAL) AS accuracy
      FROM quiz_attempts qa
      JOIN lessons l ON qa.lesson_id = l.id
      JOIN topics t ON l.topic_id = t.id
      WHERE qa.student_id = ? AND t.subject_id = ?
      ''',
      variables: [Variable(studentId), Variable(subjectId)],
    ).getSingleOrNull();
    return (result?.data['accuracy'] as double?) ?? 0.0;
  }
}
