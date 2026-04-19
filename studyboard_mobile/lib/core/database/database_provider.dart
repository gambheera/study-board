import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/daos/content_dao.dart';
import 'package:studyboard_mobile/core/database/daos/dashboard_dao.dart';
import 'package:studyboard_mobile/core/database/daos/lesson_dao.dart';
import 'package:studyboard_mobile/core/database/daos/quiz_dao.dart';
import 'package:studyboard_mobile/core/database/daos/student_dao.dart';
import 'package:studyboard_mobile/core/database/daos/survey_dao.dart';
import 'package:studyboard_mobile/core/database/daos/task_dao.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
TaskDao taskDao(Ref ref) => ref.watch(appDatabaseProvider).taskDao;

@Riverpod(keepAlive: true)
QuizDao quizDao(Ref ref) => ref.watch(appDatabaseProvider).quizDao;

@Riverpod(keepAlive: true)
LessonDao lessonDao(Ref ref) => ref.watch(appDatabaseProvider).lessonDao;

@Riverpod(keepAlive: true)
StudentDao studentDao(Ref ref) => ref.watch(appDatabaseProvider).studentDao;

@Riverpod(keepAlive: true)
SurveyDao surveyDao(Ref ref) => ref.watch(appDatabaseProvider).surveyDao;

@Riverpod(keepAlive: true)
DashboardDao dashboardDao(Ref ref) =>
    ref.watch(appDatabaseProvider).dashboardDao;

@Riverpod(keepAlive: true)
ContentDao contentDao(Ref ref) => ref.watch(appDatabaseProvider).contentDao;
