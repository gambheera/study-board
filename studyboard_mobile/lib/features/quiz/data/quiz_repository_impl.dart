import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/daos/quiz_dao.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_repository.dart';

part 'quiz_repository_impl.g.dart';

@Riverpod(keepAlive: true)
QuizRepository quizRepository(Ref ref) =>
    QuizRepositoryImpl(ref.watch(quizDaoProvider));

class QuizRepositoryImpl implements QuizRepository {
  const QuizRepositoryImpl(this._dao);

  final QuizDao _dao;

  @override
  Future<Either<Failure, QuizData>> loadQuiz(String taskId) async {
    try {
      final context = await _dao.getQuizContextForTask(taskId);
      if (context == null) {
        return const Left(DatabaseFailure('Task not found'));
      }

      final rows = await _dao.getQuestionsForLesson(context.lessonId);
      if (rows.isEmpty) {
        return const Left(
          DatabaseFailure('No quiz questions found for this lesson'),
        );
      }

      final questions = rows
          .map(
            (r) => QuizQuestion(
              id: r.id,
              lessonId: r.lessonId,
              questionText: r.questionText,
              optionA: r.optionA,
              optionB: r.optionB,
              optionC: r.optionC,
              optionD: r.optionD,
              correctOption: r.correctOption,
              orderIndex: r.orderIndex,
            ),
          )
          .toList();

      return Right((
        questions: questions,
        passThreshold: context.passThreshold,
        lessonId: context.lessonId,
        lessonTitle: context.lessonTitle,
      ));
    } on Exception catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
