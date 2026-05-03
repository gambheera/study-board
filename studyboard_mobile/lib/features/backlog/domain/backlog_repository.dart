import 'package:studyboard_mobile/features/backlog/domain/backlog_item.dart';

/// Streams backlog tasks from the local Drift database.
/// Single-method interface is intentional: enables mocktail injection in tests.
// ignore: one_member_abstracts
abstract interface class BacklogRepository {
  Stream<List<BacklogItem>> watchBacklogTasks(
    String studentId, {
    String? contentTrack,
  });
}
