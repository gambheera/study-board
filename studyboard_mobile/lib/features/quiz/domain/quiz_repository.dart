import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/quiz/domain/quiz_question.dart';

typedef QuizData = ({
  List<QuizQuestion> questions,
  double passThreshold,
  String lessonId,
  String lessonTitle,
});

abstract interface class QuizRepository {
  Future<Either<Failure, QuizData>> loadQuiz(String taskId);
}
