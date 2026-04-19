import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/notifications/data/notification_service.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return const NotificationService();
}
