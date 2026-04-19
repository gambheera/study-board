import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:studyboard_mobile/features/auth/domain/student.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated({
    required Student student,
    @Default(false) bool isNewStudent,
  }) = _Authenticated;
}
