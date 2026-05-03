// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LessonNotifier)
final lessonProvider = LessonNotifierFamily._();

final class LessonNotifierProvider
    extends $AsyncNotifierProvider<LessonNotifier, LessonState> {
  LessonNotifierProvider._({
    required LessonNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lessonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lessonNotifierHash();

  @override
  String toString() {
    return r'lessonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LessonNotifier create() => LessonNotifier();

  @override
  bool operator ==(Object other) {
    return other is LessonNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lessonNotifierHash() => r'd47eff25843490d59cb20659e4eae3b54d301823';

final class LessonNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LessonNotifier,
          AsyncValue<LessonState>,
          LessonState,
          FutureOr<LessonState>,
          String
        > {
  LessonNotifierFamily._()
    : super(
        retry: null,
        name: r'lessonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LessonNotifierProvider call(String taskId) =>
      LessonNotifierProvider._(argument: taskId, from: this);

  @override
  String toString() => r'lessonProvider';
}

abstract class _$LessonNotifier extends $AsyncNotifier<LessonState> {
  late final _$args = ref.$arg as String;
  String get taskId => _$args;

  FutureOr<LessonState> build(String taskId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LessonState>, LessonState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LessonState>, LessonState>,
              AsyncValue<LessonState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
