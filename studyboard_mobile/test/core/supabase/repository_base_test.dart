import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:studyboard_mobile/core/supabase/repository_base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _TestRepository extends RepositoryBase {}

void main() {
  late _TestRepository repository;

  setUp(() {
    repository = _TestRepository();
  });

  group('RepositoryBase.trySupabase', () {
    test('returns Right on success', () async {
      final result = await repository.trySupabase(() async => 42);
      expect(result, const Right<Failure, int>(42));
    });

    test('returns Left(AuthFailure) on AuthException', () async {
      final result = await repository.trySupabase<int>(
        () async => throw const AuthException('bad token'),
      );
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(DatabaseFailure) on PostgrestException', () async {
      final result = await repository.trySupabase<int>(
        () async => throw const PostgrestException(message: 'unique violation'),
      );
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<DatabaseFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on StorageException', () async {
      final result = await repository.trySupabase<int>(
        () async =>
            throw const StorageException('bucket not found'),
      );
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left(NetworkFailure) on unknown exception', () async {
      final result = await repository.trySupabase<int>(
        () async => throw Exception('unexpected'),
      );
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('never throws — always returns Either', () async {
      await expectLater(
        repository.trySupabase<int>(
          () async => throw const StackOverflowError(),
        ),
        completes,
      );
    });
  });
}
