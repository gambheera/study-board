enum TaskStatus { backlog, todo, inProgress, done, reopened }

extension TaskStatusX on TaskStatus {
  String toDbString() {
    return switch (this) {
      TaskStatus.backlog => 'backlog',
      TaskStatus.todo => 'todo',
      TaskStatus.inProgress => 'in_progress',
      TaskStatus.done => 'done',
      TaskStatus.reopened => 'reopened',
    };
  }

  static TaskStatus fromString(String value) {
    return switch (value) {
      'backlog' => TaskStatus.backlog,
      'todo' => TaskStatus.todo,
      'in_progress' => TaskStatus.inProgress,
      'done' => TaskStatus.done,
      'reopened' => TaskStatus.reopened,
      _ => throw ArgumentError('Unknown TaskStatus: $value'),
    };
  }
}
