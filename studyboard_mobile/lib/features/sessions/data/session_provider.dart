import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/sessions/data/session_repository_impl.dart';
import 'package:studyboard_mobile/features/sessions/domain/session_repository.dart';

part 'session_provider.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepositoryImpl(ref.watch(appDatabaseProvider).sessionDao);
}
