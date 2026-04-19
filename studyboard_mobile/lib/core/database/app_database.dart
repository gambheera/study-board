import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';
import 'package:studyboard_mobile/core/database/daos/dashboard_dao.dart';
import 'package:studyboard_mobile/core/database/daos/lesson_dao.dart';
import 'package:studyboard_mobile/core/database/daos/quiz_dao.dart';
import 'package:studyboard_mobile/core/database/daos/student_dao.dart';
import 'package:studyboard_mobile/core/database/daos/survey_dao.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';
import 'package:studyboard_mobile/core/database/tables/lesson_tasks_table.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/nudge_events_table.dart';
import 'package:studyboard_mobile/core/database/tables/past_paper_questions_table.dart';
import 'package:studyboard_mobile/core/database/tables/quiz_attempts_table.dart';
import 'package:studyboard_mobile/core/database/tables/quiz_questions_table.dart';
import 'package:studyboard_mobile/core/database/tables/sessions_table.dart';
import 'package:studyboard_mobile/core/database/tables/students_table.dart';
import 'package:studyboard_mobile/core/database/tables/subjects_table.dart';
import 'package:studyboard_mobile/core/database/tables/survey_responses_table.dart';
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';
import 'package:studyboard_mobile/core/sync/sync_queue_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    StudentsTable,
    SubjectsTable,
    TopicsTable,
    LessonsTable,
    LessonTasksTable,
    QuizQuestionsTable,
    QuizAttemptsTable,
    PastPaperQuestionsTable,
    SurveyResponsesTable,
    NudgeEventsTable,
    SessionsTable,
    SyncQueueTable,
    SyncErrorLogTable,
  ],
  daos: [
    TaskDao,
    QuizDao,
    LessonDao,
    StudentDao,
    SurveyDao,
    DashboardDao,
    ContentDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'studyboard.db'));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v1 → v2+ migrations added in future stories
        },
      );
}
