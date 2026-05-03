import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/lesson/data/lesson_provider.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_state.dart';

part 'lesson_notifier.g.dart';

@riverpod
class LessonNotifier extends _$LessonNotifier {
  @override
  Future<LessonState> build(String taskId) async {
    final details =
        await ref.read(lessonRepositoryProvider).getLessonDetails(taskId);
    return LessonState(
      taskId: details.taskId,
      lessonId: details.lessonId,
      lessonTitle: details.lessonTitle,
      topicTitle: details.topicTitle,
      questionText: details.questionText,
      contentText: details.contentText,
      curiosityCompleted: details.curiosityCompleted,
    );
  }

  Future<void> completeCuriosity() async {
    final current = state.value;
    if (current == null || current.curiosityCompleted) return;
    state = AsyncData(current.copyWith(curiosityCompleted: true));
    try {
      await ref
          .read(lessonRepositoryProvider)
          .setCuriosityCompleted(current.taskId);
    } catch (_) {
      state = AsyncData(current);
      rethrow;
    }
  }
}
