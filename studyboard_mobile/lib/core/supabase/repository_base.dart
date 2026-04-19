import 'package:fpdart/fpdart.dart';
import 'package:studyboard_mobile/core/failures/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RepositoryBase {
  Future<Either<Failure, T>> trySupabase<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on PostgrestException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on StorageException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Object catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
