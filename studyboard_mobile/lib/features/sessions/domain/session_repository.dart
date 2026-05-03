abstract interface class SessionRepository {
  Future<void> openSession(String studentId);
  Future<void> closeSession();
}
