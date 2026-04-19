// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'survey_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SurveyResponse {

 String get id;@JsonKey(name: 'student_id') String get studentId; String get responses;@JsonKey(name: 'responded_at') String get respondedAt;
/// Create a copy of SurveyResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurveyResponseCopyWith<SurveyResponse> get copyWith => _$SurveyResponseCopyWithImpl<SurveyResponse>(this as SurveyResponse, _$identity);

  /// Serializes this SurveyResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurveyResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.responses, responses) || other.responses == responses)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,responses,respondedAt);

@override
String toString() {
  return 'SurveyResponse(id: $id, studentId: $studentId, responses: $responses, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class $SurveyResponseCopyWith<$Res>  {
  factory $SurveyResponseCopyWith(SurveyResponse value, $Res Function(SurveyResponse) _then) = _$SurveyResponseCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'student_id') String studentId, String responses,@JsonKey(name: 'responded_at') String respondedAt
});




}
/// @nodoc
class _$SurveyResponseCopyWithImpl<$Res>
    implements $SurveyResponseCopyWith<$Res> {
  _$SurveyResponseCopyWithImpl(this._self, this._then);

  final SurveyResponse _self;
  final $Res Function(SurveyResponse) _then;

/// Create a copy of SurveyResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? responses = null,Object? respondedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,responses: null == responses ? _self.responses : responses // ignore: cast_nullable_to_non_nullable
as String,respondedAt: null == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SurveyResponse].
extension SurveyResponsePatterns on SurveyResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurveyResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurveyResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurveyResponse value)  $default,){
final _that = this;
switch (_that) {
case _SurveyResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurveyResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SurveyResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'student_id')  String studentId,  String responses, @JsonKey(name: 'responded_at')  String respondedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurveyResponse() when $default != null:
return $default(_that.id,_that.studentId,_that.responses,_that.respondedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'student_id')  String studentId,  String responses, @JsonKey(name: 'responded_at')  String respondedAt)  $default,) {final _that = this;
switch (_that) {
case _SurveyResponse():
return $default(_that.id,_that.studentId,_that.responses,_that.respondedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'student_id')  String studentId,  String responses, @JsonKey(name: 'responded_at')  String respondedAt)?  $default,) {final _that = this;
switch (_that) {
case _SurveyResponse() when $default != null:
return $default(_that.id,_that.studentId,_that.responses,_that.respondedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurveyResponse implements SurveyResponse {
  const _SurveyResponse({required this.id, @JsonKey(name: 'student_id') required this.studentId, required this.responses, @JsonKey(name: 'responded_at') required this.respondedAt});
  factory _SurveyResponse.fromJson(Map<String, dynamic> json) => _$SurveyResponseFromJson(json);

@override final  String id;
@override@JsonKey(name: 'student_id') final  String studentId;
@override final  String responses;
@override@JsonKey(name: 'responded_at') final  String respondedAt;

/// Create a copy of SurveyResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurveyResponseCopyWith<_SurveyResponse> get copyWith => __$SurveyResponseCopyWithImpl<_SurveyResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurveyResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurveyResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.responses, responses) || other.responses == responses)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,responses,respondedAt);

@override
String toString() {
  return 'SurveyResponse(id: $id, studentId: $studentId, responses: $responses, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class _$SurveyResponseCopyWith<$Res> implements $SurveyResponseCopyWith<$Res> {
  factory _$SurveyResponseCopyWith(_SurveyResponse value, $Res Function(_SurveyResponse) _then) = __$SurveyResponseCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'student_id') String studentId, String responses,@JsonKey(name: 'responded_at') String respondedAt
});




}
/// @nodoc
class __$SurveyResponseCopyWithImpl<$Res>
    implements _$SurveyResponseCopyWith<$Res> {
  __$SurveyResponseCopyWithImpl(this._self, this._then);

  final _SurveyResponse _self;
  final $Res Function(_SurveyResponse) _then;

/// Create a copy of SurveyResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? responses = null,Object? respondedAt = null,}) {
  return _then(_SurveyResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,responses: null == responses ? _self.responses : responses // ignore: cast_nullable_to_non_nullable
as String,respondedAt: null == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
