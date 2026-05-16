// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuizNotifier)
final quizProvider = QuizNotifierFamily._();

final class QuizNotifierProvider
    extends $AsyncNotifierProvider<QuizNotifier, QuizState> {
  QuizNotifierProvider._({
    required QuizNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'quizProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quizNotifierHash();

  @override
  String toString() {
    return r'quizProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QuizNotifier create() => QuizNotifier();

  @override
  bool operator ==(Object other) {
    return other is QuizNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quizNotifierHash() => r'afeb0240ba958de9f24109132bfbe13e1a6e8975';

final class QuizNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          QuizNotifier,
          AsyncValue<QuizState>,
          QuizState,
          FutureOr<QuizState>,
          String
        > {
  QuizNotifierFamily._()
    : super(
        retry: null,
        name: r'quizProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuizNotifierProvider call(String taskId) =>
      QuizNotifierProvider._(argument: taskId, from: this);

  @override
  String toString() => r'quizProvider';
}

abstract class _$QuizNotifier extends $AsyncNotifier<QuizState> {
  late final _$args = ref.$arg as String;
  String get taskId => _$args;

  FutureOr<QuizState> build(String taskId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<QuizState>, QuizState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QuizState>, QuizState>,
              AsyncValue<QuizState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
