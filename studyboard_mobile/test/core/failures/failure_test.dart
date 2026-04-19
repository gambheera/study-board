import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';

void main() {
  group('Failure hierarchy', () {
    test('NetworkFailure carries message', () {
      const failure = NetworkFailure('no internet');
      expect(failure.message, 'no internet');
      expect(failure, isA<Failure>());
    });

    test('DatabaseFailure carries message', () {
      const failure = DatabaseFailure('query failed');
      expect(failure.message, 'query failed');
      expect(failure, isA<Failure>());
    });

    test('AuthFailure carries message', () {
      const failure = AuthFailure('invalid credentials');
      expect(failure.message, 'invalid credentials');
      expect(failure, isA<Failure>());
    });

    test('ValidationFailure carries message', () {
      const failure = ValidationFailure('email required');
      expect(failure.message, 'email required');
      expect(failure, isA<Failure>());
    });

    test('SyncFailure carries message', () {
      const failure = SyncFailure('sync conflict');
      expect(failure.message, 'sync conflict');
      expect(failure, isA<Failure>());
    });

    test('sealed class exhaustive switch compiles', () {
      const Failure failure = NetworkFailure('test');
      final result = switch (failure) {
        NetworkFailure() => 'network',
        DatabaseFailure() => 'database',
        AuthFailure() => 'auth',
        ValidationFailure() => 'validation',
        SyncFailure() => 'sync',
      };
      expect(result, 'network');
    });

    test('each subtype is distinct', () {
      const failures = <Failure>[
        NetworkFailure('a'),
        DatabaseFailure('b'),
        AuthFailure('c'),
        ValidationFailure('d'),
        SyncFailure('e'),
      ];
      expect(failures.whereType<NetworkFailure>().length, 1);
      expect(failures.whereType<DatabaseFailure>().length, 1);
      expect(failures.whereType<AuthFailure>().length, 1);
      expect(failures.whereType<ValidationFailure>().length, 1);
      expect(failures.whereType<SyncFailure>().length, 1);
    });
  });
}
