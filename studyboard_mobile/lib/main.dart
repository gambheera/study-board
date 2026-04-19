import 'package:studyboard_mobile/app.dart';
import 'package:studyboard_mobile/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
