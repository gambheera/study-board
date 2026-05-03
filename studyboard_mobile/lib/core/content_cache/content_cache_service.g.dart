// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contentCacheService)
final contentCacheServiceProvider = ContentCacheServiceProvider._();

final class ContentCacheServiceProvider
    extends
        $FunctionalProvider<
          ContentCacheService,
          ContentCacheService,
          ContentCacheService
        >
    with $Provider<ContentCacheService> {
  ContentCacheServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentCacheServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentCacheServiceHash();

  @$internal
  @override
  $ProviderElement<ContentCacheService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentCacheService create(Ref ref) {
    return contentCacheService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentCacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentCacheService>(value),
    );
  }
}

String _$contentCacheServiceHash() =>
    r'6955bd04b5e2157cbbf445dd8ba715383331d68a';

@ProviderFor(contentSeeded)
final contentSeededProvider = ContentSeededProvider._();

final class ContentSeededProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  ContentSeededProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentSeededProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentSeededHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return contentSeeded(ref);
  }
}

String _$contentSeededHash() => r'df1aa990fb3aaeb68af79e64795e51ff814ca1ea';
