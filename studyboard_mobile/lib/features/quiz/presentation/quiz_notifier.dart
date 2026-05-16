import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/app_database.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/quiz/data/quiz_repository_impl.dart';
import 'package:studyboard_mobile/features/quiz/presentation/quiz_state.dart';
import 'package:uuid/uuid.dart';

part 'quiz_notifier.g.dart';

const _uuid = Uuid();

@riverpod
class QuizNotifier extends _$QuizNotifier {
  bool _isProcessing = false;

  @override
  Future<QuizState> build(String taskId) async {
    final result = await ref.read(quizRepositoryProvider).loadQuiz(taskId);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => QuizState.active(
        questions: data.questions,
        currentIndex: 0,
        passThreshold: data.passThreshold,
        lessonId: data.lessonId,
        lessonTitle: data.lessonTitle,
      ),
    );
  }

  void selectAnswer(String option) {
    final current = state.value;
    if (current is! QuizActive) return;
    if (current.selectedAnswers.containsKey(current.currentIndex)) return;

    state = AsyncData(
      current.copyWith(
        selectedAnswers: {
          ...current.selectedAnswers,
          current.currentIndex: option,
        },
      ),
    );
  }

  Future<void> advanceOrComplete() async {
    final current = state.value;
    if (current is! QuizActive) return;
    if (!current.selectedAnswers.containsKey(current.currentIndex)) return;

    final isLastQuestion =
        current.currentIndex == current.questions.length - 1;

    if (!isLastQuestion) {
      state = AsyncData(
        current.copyWith(currentIndex: current.currentIndex + 1),
      );
      return;
    }

    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final total = current.questions.length;
      if (total == 0) return;
      var correctCount = 0;
      for (var i = 0; i < total; i++) {
        final selected = current.selectedAnswers[i];
        if (selected != null &&
            selected == current.questions[i].correctOption) {
          correctCount++;
        }
      }
      final score = correctCount / total;
      final passed = score >= current.passThreshold;

      var failedAttemptCount = 0;

      if (passed) {
        await ref.read(taskDaoProvider).markTaskComplete(taskId);
        final studentId = ref
            .read(authProvider)
            .value
            ?.whenOrNull(authenticated: (student, _) => student.id);
        if (studentId == null) {
          state = AsyncError(
            Exception('Cannot record attempt: not authenticated'),
            StackTrace.current,
          );
          return;
        }
        await ref.read(quizDaoProvider).saveAttempt(
              QuizAttemptsTableCompanion.insert(
                id: _uuid.v4(),
                studentId: studentId,
                lessonId: current.lessonId,
                score: score,
                passed: passed,
                attemptedAt: DateTime.now().toUtc().toIso8601String(),
              ),
            );
      } else {
        await ref.read(taskDaoProvider).resetTaskToInProgress(taskId);
        final studentId = ref
            .read(authProvider)
            .value
            ?.whenOrNull(authenticated: (student, _) => student.id);
        if (studentId == null) {
          state = AsyncError(
            Exception('Cannot record attempt: not authenticated'),
            StackTrace.current,
          );
          return;
        }
        await ref.read(quizDaoProvider).saveAttempt(
              QuizAttemptsTableCompanion.insert(
                id: _uuid.v4(),
                studentId: studentId,
                lessonId: current.lessonId,
                score: score,
                passed: passed,
                attemptedAt: DateTime.now().toUtc().toIso8601String(),
              ),
            );
        final attempts = await ref
            .read(quizDaoProvider)
            .getAttemptsForLesson(studentId, current.lessonId);
        failedAttemptCount = attempts.where((a) => !a.passed).length;
      }

      state = AsyncData(
        QuizState.completed(
          score: score,
          passed: passed,
          correctCount: correctCount,
          totalQuestions: total,
          lessonId: current.lessonId,
          lessonTitle: current.lessonTitle,
          questions: current.questions,
          selectedAnswers: current.selectedAnswers,
          failedAttemptCount: failedAttemptCount,
        ),
      );
    } on Object catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isProcessing = false;
    }
  }
}
