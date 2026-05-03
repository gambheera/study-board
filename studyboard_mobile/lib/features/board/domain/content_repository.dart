import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';

// Single-method interface is intentional: required for mocktail injection
// in tests.
// ignore: one_member_abstracts
abstract interface class ContentRepository {
  Future<Either<Failure, Unit>> syncContent(String studentId);
}
