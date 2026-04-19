import 'package:drift/drift.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/tables/lessons_table.dart';
import 'package:studyboard_mobile/core/database/tables/topics_table.dart';

part 'content_dao.g.dart';

@DriftAccessor(tables: [LessonsTable, TopicsTable])
class ContentDao extends DatabaseAccessor<AppDatabase> with _$ContentDaoMixin {
  ContentDao(super.attachedDatabase);

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
}
