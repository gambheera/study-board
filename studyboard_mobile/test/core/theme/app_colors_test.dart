import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyboard_mobile/core/theme/app_colors.dart';

void main() {
  group('StudyBoardColors extension', () {
    const scheme = ColorScheme.light(primary: Color(0xFF007BFF));

    test('taskBacklog returns blue-grey', () {
      expect(scheme.taskBacklog, const Color(0xFF8896A5));
    });

    test('taskInProgress returns golden yellow', () {
      expect(scheme.taskInProgress, const Color(0xFFFFC107));
    });

    test('taskDone returns sage green', () {
      expect(scheme.taskDone, const Color(0xFF4CAF78));
    });

    test('taskReopened returns dusty rose', () {
      expect(scheme.taskReopened, const Color(0xFFC4786A));
    });
  });
}
