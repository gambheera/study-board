// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backlog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backlogRepository)
final backlogRepositoryProvider = BacklogRepositoryProvider._();

final class BacklogRepositoryProvider
    extends
        $FunctionalProvider<
          BacklogRepository,
          BacklogRepository,
          BacklogRepository
        >
    with $Provider<BacklogRepository> {
  BacklogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backlogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backlogRepositoryHash();

  @$internal
  @override
  $ProviderElement<BacklogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BacklogRepository create(Ref ref) {
    return backlogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BacklogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BacklogRepository>(value),
    );
  }
}

String _$backlogRepositoryHash() => r'4770596880056c5aa396d738e7cae1b72c89183f';
