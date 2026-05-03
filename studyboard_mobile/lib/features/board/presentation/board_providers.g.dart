// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(boardItems)
final boardItemsProvider = BoardItemsFamily._();

final class BoardItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BacklogItem>>,
          List<BacklogItem>,
          Stream<List<BacklogItem>>
        >
    with
        $FutureModifier<List<BacklogItem>>,
        $StreamProvider<List<BacklogItem>> {
  BoardItemsProvider._({
    required BoardItemsFamily super.from,
    required ({String studentId, TaskStatus status}) super.argument,
  }) : super(
         retry: null,
         name: r'boardItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boardItemsHash();

  @override
  String toString() {
    return r'boardItemsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<BacklogItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BacklogItem>> create(Ref ref) {
    final argument = this.argument as ({String studentId, TaskStatus status});
    return boardItems(
      ref,
      studentId: argument.studentId,
      status: argument.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BoardItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boardItemsHash() => r'2485d51c930aa190f7774f151f046ec0fcc7497d';

final class BoardItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<BacklogItem>>,
          ({String studentId, TaskStatus status})
        > {
  BoardItemsFamily._()
    : super(
        retry: null,
        name: r'boardItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BoardItemsProvider call({
    required String studentId,
    required TaskStatus status,
  }) => BoardItemsProvider._(
    argument: (studentId: studentId, status: status),
    from: this,
  );

  @override
  String toString() => r'boardItemsProvider';
}

@ProviderFor(hasDoneTasks)
final hasDoneTasksProvider = HasDoneTasksFamily._();

final class HasDoneTasksProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  HasDoneTasksProvider._({
    required HasDoneTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hasDoneTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasDoneTasksHash();

  @override
  String toString() {
    return r'hasDoneTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as String;
    return hasDoneTasks(ref, studentId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HasDoneTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasDoneTasksHash() => r'3298ceeb0fdaf0d250b77c7c5bf6054978e0c237';

final class HasDoneTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, String> {
  HasDoneTasksFamily._()
    : super(
        retry: null,
        name: r'hasDoneTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HasDoneTasksProvider call({required String studentId}) =>
      HasDoneTasksProvider._(argument: studentId, from: this);

  @override
  String toString() => r'hasDoneTasksProvider';
}
