// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_tracker_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionTrackerNotifier)
final sessionTrackerProvider = SessionTrackerNotifierProvider._();

final class SessionTrackerNotifierProvider
    extends $AsyncNotifierProvider<SessionTrackerNotifier, void> {
  SessionTrackerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionTrackerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionTrackerNotifierHash();

  @$internal
  @override
  SessionTrackerNotifier create() => SessionTrackerNotifier();
}

String _$sessionTrackerNotifierHash() =>
    r'57c3ce37e0d77a8779dd45674c32f998f30fc73c';

abstract class _$SessionTrackerNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
