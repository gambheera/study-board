// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

@ProviderFor(taskDao)
final taskDaoProvider = TaskDaoProvider._();

final class TaskDaoProvider
    extends $FunctionalProvider<TaskDao, TaskDao, TaskDao>
    with $Provider<TaskDao> {
  TaskDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskDaoHash();

  @$internal
  @override
  $ProviderElement<TaskDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskDao create(Ref ref) {
    return taskDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskDao>(value),
    );
  }
}

String _$taskDaoHash() => r'8c9ea9c5de1a6c826d40e72a4355655a2a112e8e';

@ProviderFor(quizDao)
final quizDaoProvider = QuizDaoProvider._();

final class QuizDaoProvider
    extends $FunctionalProvider<QuizDao, QuizDao, QuizDao>
    with $Provider<QuizDao> {
  QuizDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizDaoHash();

  @$internal
  @override
  $ProviderElement<QuizDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuizDao create(Ref ref) {
    return quizDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuizDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuizDao>(value),
    );
  }
}

String _$quizDaoHash() => r'1f8d3bae7ec5cd3063bfb032dc7b332eabc1ceb0';

@ProviderFor(lessonDao)
final lessonDaoProvider = LessonDaoProvider._();

final class LessonDaoProvider
    extends $FunctionalProvider<LessonDao, LessonDao, LessonDao>
    with $Provider<LessonDao> {
  LessonDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lessonDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lessonDaoHash();

  @$internal
  @override
  $ProviderElement<LessonDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LessonDao create(Ref ref) {
    return lessonDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LessonDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LessonDao>(value),
    );
  }
}

String _$lessonDaoHash() => r'1cb30d7ca33f04be5e06d1015f2754b7019fd5c6';

@ProviderFor(studentDao)
final studentDaoProvider = StudentDaoProvider._();

final class StudentDaoProvider
    extends $FunctionalProvider<StudentDao, StudentDao, StudentDao>
    with $Provider<StudentDao> {
  StudentDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studentDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studentDaoHash();

  @$internal
  @override
  $ProviderElement<StudentDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StudentDao create(Ref ref) {
    return studentDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StudentDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StudentDao>(value),
    );
  }
}

String _$studentDaoHash() => r'eee6afbbbdd2762245cc17732ba35b7f79c81e41';

@ProviderFor(surveyDao)
final surveyDaoProvider = SurveyDaoProvider._();

final class SurveyDaoProvider
    extends $FunctionalProvider<SurveyDao, SurveyDao, SurveyDao>
    with $Provider<SurveyDao> {
  SurveyDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'surveyDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$surveyDaoHash();

  @$internal
  @override
  $ProviderElement<SurveyDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SurveyDao create(Ref ref) {
    return surveyDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SurveyDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SurveyDao>(value),
    );
  }
}

String _$surveyDaoHash() => r'2e850427a78a30f6354c04912058532aab55485e';

@ProviderFor(dashboardDao)
final dashboardDaoProvider = DashboardDaoProvider._();

final class DashboardDaoProvider
    extends $FunctionalProvider<DashboardDao, DashboardDao, DashboardDao>
    with $Provider<DashboardDao> {
  DashboardDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardDaoHash();

  @$internal
  @override
  $ProviderElement<DashboardDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardDao create(Ref ref) {
    return dashboardDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardDao>(value),
    );
  }
}

String _$dashboardDaoHash() => r'e95204329f197a6df7f6c64a72574dfc1379283b';

@ProviderFor(contentDao)
final contentDaoProvider = ContentDaoProvider._();

final class ContentDaoProvider
    extends $FunctionalProvider<ContentDao, ContentDao, ContentDao>
    with $Provider<ContentDao> {
  ContentDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentDaoHash();

  @$internal
  @override
  $ProviderElement<ContentDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ContentDao create(Ref ref) {
    return contentDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentDao>(value),
    );
  }
}

String _$contentDaoHash() => r'da408b19955ebfac821b9fddc362e352ab90cbea';
