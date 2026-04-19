import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/features/auth/domain/auth_repository.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
  });

  group('AuthRepository interface', () {
    test('getCurrentUser returns Either<Failure, Student?>', () async {
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      final result = await repository.getCurrentUser();

      expect(result, isA<Either<Failure, Student?>>());
    });

    test('signOut returns Either<Failure, Unit>', () async {
      when(() => repository.signOut())
          .thenAnswer((_) async => const Right(unit));

      final result = await repository.signOut();

      expect(result, isA<Either<Failure, Unit>>());
    });

    test('getSessionStream returns Stream<AuthState>', () {
      when(() => repository.getSessionStream())
          .thenAnswer((_) => const Stream.empty());

      final stream = repository.getSessionStream();

      expect(stream, isA<Stream<AuthState>>());
    });
  });
}
