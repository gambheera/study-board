import 'package:studyboard_mobile/core/database/daos/session_dao.dart';
import 'package:studyboard_mobile/features/sessions/domain/session_repository.dart';
import 'package:uuid/uuid.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this._sessionDao);

  final SessionDao _sessionDao;
  String? _currentSessionId;
  static const _uuid = Uuid();

  @override
  Future<void> openSession(String studentId) async {
    final sessionId = _uuid.v4();
    _currentSessionId = sessionId;
    final now = DateTime.now().toUtc().toIso8601String();
    await _sessionDao.openSession(
      sessionId: sessionId,
      studentId: studentId,
      startedAt: now,
    );
  }

  @override
  Future<void> closeSession() async {
    final sessionId = _currentSessionId;
    if (sessionId == null) return;
    _currentSessionId = null;
    final now = DateTime.now().toUtc().toIso8601String();
    await _sessionDao.closeSession(sessionId: sessionId, endedAt: now);
  }
}
