// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backlog_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backlogItems)
final backlogItemsProvider = BacklogItemsFamily._();

final class BacklogItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BacklogItem>>,
          List<BacklogItem>,
          Stream<List<BacklogItem>>
        >
    with
        $FutureModifier<List<BacklogItem>>,
        $StreamProvider<List<BacklogItem>> {
  BacklogItemsProvider._({
    required BacklogItemsFamily super.from,
    required ({String studentId, String? contentTrack}) super.argument,
  }) : super(
         retry: null,
         name: r'backlogItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$backlogItemsHash();

  @override
  String toString() {
    return r'backlogItemsProvider'
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
    final argument =
        this.argument as ({String studentId, String? contentTrack});
    return backlogItems(
      ref,
      studentId: argument.studentId,
      contentTrack: argument.contentTrack,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BacklogItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$backlogItemsHash() => r'edf7086dfbefd1c6b800242cde21ca71007057e0';

final class BacklogItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<BacklogItem>>,
          ({String studentId, String? contentTrack})
        > {
  BacklogItemsFamily._()
    : super(
        retry: null,
        name: r'backlogItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BacklogItemsProvider call({
    required String studentId,
    String? contentTrack,
  }) => BacklogItemsProvider._(
    argument: (studentId: studentId, contentTrack: contentTrack),
    from: this,
  );

  @override
  String toString() => r'backlogItemsProvider';
}
