import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/past_paper_questions_table.dart';
import 'package:studyboard_mobile/core/database/tables/quiz_questions_table.dart';
import 'package:studyboard_mobile/core/database/tables/subjects_table.dart';
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';

part 'content_dao.g.dart';

@DriftAccessor(
  tables: [
    SubjectsTable,
    TopicsTable,
    LessonsTable,
    QuizQuestionsTable,
    PastPaperQuestionsTable,
  ],
)
class ContentDao extends DatabaseAccessor<AppDatabase> with _$ContentDaoMixin {
  ContentDao(super.attachedDatabase);

  static final _imageRegex = RegExp(r'!\[.*?\]\((https?://[^\)]+)\)');

  Future<List<String>> getAllImageUrlsInTopicOrder() async {
    final query = select(lessonsTable).join([
      innerJoin(topicsTable, topicsTable.id.equalsExp(lessonsTable.topicId)),
    ])
      ..orderBy([
        OrderingTerm.asc(topicsTable.orderIndex),
        OrderingTerm.asc(lessonsTable.orderIndex),
      ]);

    final rows = await query.get();
    final urls = <String>[];
    for (final row in rows) {
      final lesson = row.readTable(lessonsTable);
      for (final match in _imageRegex.allMatches(lesson.contentText)) {
        final url = match.group(1);
        if (url != null) urls.add(url);
      }
    }
    return urls.toSet().toList();
  }

  Future<bool> hasAnyLessons() async {
    final rows = await (select(lessonsTable)..limit(1)).get();
    return rows.isNotEmpty;
  }

  Future<List<LessonsTableData>> getAllLessons(String subjectId) =>
      (select(lessonsTable)
            ..where(
              (l) => existsQuery(
                select(topicsTable)
                  ..where(
                    (t) =>
                        t.id.equalsExp(l.topicId) &
                        t.subjectId.equals(subjectId),
                  ),
              ),
            ))
          .get();

  Future<List<SubjectsTableData>> getSubjects() =>
      select(subjectsTable).get();

  Future<void> upsertSubject(SubjectsTableCompanion c) =>
      into(subjectsTable).insertOnConflictUpdate(c);

  Future<void> upsertTopic(TopicsTableCompanion c) =>
      into(topicsTable).insertOnConflictUpdate(c);

  Future<void> upsertLesson(LessonsTableCompanion c) =>
      into(lessonsTable).insertOnConflictUpdate(c);

  Future<void> upsertQuizQuestion(QuizQuestionsTableCompanion c) =>
      into(quizQuestionsTable).insertOnConflictUpdate(c);

  Future<void> upsertPastPaperQuestion(PastPaperQuestionsTableCompanion c) =>
      into(pastPaperQuestionsTable).insertOnConflictUpdate(c);
}
