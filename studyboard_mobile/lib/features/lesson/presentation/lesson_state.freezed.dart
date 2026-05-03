// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonState {

 String get taskId; String get lessonId; String get lessonTitle; String get topicTitle; String get questionText; String get contentText; bool get curiosityCompleted;
/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonStateCopyWith<LessonState> get copyWith => _$LessonStateCopyWithImpl<LessonState>(this as LessonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonState&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.contentText, contentText) || other.contentText == contentText)&&(identical(other.curiosityCompleted, curiosityCompleted) || other.curiosityCompleted == curiosityCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,lessonId,lessonTitle,topicTitle,questionText,contentText,curiosityCompleted);

@override
String toString() {
  return 'LessonState(taskId: $taskId, lessonId: $lessonId, lessonTitle: $lessonTitle, topicTitle: $topicTitle, questionText: $questionText, contentText: $contentText, curiosityCompleted: $curiosityCompleted)';
}


}

/// @nodoc
abstract mixin class $LessonStateCopyWith<$Res>  {
  factory $LessonStateCopyWith(LessonState value, $Res Function(LessonState) _then) = _$LessonStateCopyWithImpl;
@useResult
$Res call({
 String taskId, String lessonId, String lessonTitle, String topicTitle, String questionText, String contentText, bool curiosityCompleted
});




}
/// @nodoc
class _$LessonStateCopyWithImpl<$Res>
    implements $LessonStateCopyWith<$Res> {
  _$LessonStateCopyWithImpl(this._self, this._then);

  final LessonState _self;
  final $Res Function(LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? lessonId = null,Object? lessonTitle = null,Object? topicTitle = null,Object? questionText = null,Object? contentText = null,Object? curiosityCompleted = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,lessonTitle: null == lessonTitle ? _self.lessonTitle : lessonTitle // ignore: cast_nullable_to_non_nullable
as String,topicTitle: null == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,contentText: null == contentText ? _self.contentText : contentText // ignore: cast_nullable_to_non_nullable
as String,curiosityCompleted: null == curiosityCompleted ? _self.curiosityCompleted : curiosityCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonState].
extension LessonStatePatterns on LessonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonState value)  $default,){
final _that = this;
switch (_that) {
case _LessonState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonState value)?  $default,){
final _that = this;
switch (_that) {
case _LessonState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String lessonId,  String lessonTitle,  String topicTitle,  String questionText,  String contentText,  bool curiosityCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.taskId,_that.lessonId,_that.lessonTitle,_that.topicTitle,_that.questionText,_that.contentText,_that.curiosityCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String lessonId,  String lessonTitle,  String topicTitle,  String questionText,  String contentText,  bool curiosityCompleted)  $default,) {final _that = this;
switch (_that) {
case _LessonState():
return $default(_that.taskId,_that.lessonId,_that.lessonTitle,_that.topicTitle,_that.questionText,_that.contentText,_that.curiosityCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String lessonId,  String lessonTitle,  String topicTitle,  String questionText,  String contentText,  bool curiosityCompleted)?  $default,) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.taskId,_that.lessonId,_that.lessonTitle,_that.topicTitle,_that.questionText,_that.contentText,_that.curiosityCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _LessonState implements LessonState {
  const _LessonState({required this.taskId, required this.lessonId, required this.lessonTitle, required this.topicTitle, required this.questionText, required this.contentText, this.curiosityCompleted = false});
  

@override final  String taskId;
@override final  String lessonId;
@override final  String lessonTitle;
@override final  String topicTitle;
@override final  String questionText;
@override final  String contentText;
@override@JsonKey() final  bool curiosityCompleted;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonStateCopyWith<_LessonState> get copyWith => __$LessonStateCopyWithImpl<_LessonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonState&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.contentText, contentText) || other.contentText == contentText)&&(identical(other.curiosityCompleted, curiosityCompleted) || other.curiosityCompleted == curiosityCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,lessonId,lessonTitle,topicTitle,questionText,contentText,curiosityCompleted);

@override
String toString() {
  return 'LessonState(taskId: $taskId, lessonId: $lessonId, lessonTitle: $lessonTitle, topicTitle: $topicTitle, questionText: $questionText, contentText: $contentText, curiosityCompleted: $curiosityCompleted)';
}


}

/// @nodoc
abstract mixin class _$LessonStateCopyWith<$Res> implements $LessonStateCopyWith<$Res> {
  factory _$LessonStateCopyWith(_LessonState value, $Res Function(_LessonState) _then) = __$LessonStateCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String lessonId, String lessonTitle, String topicTitle, String questionText, String contentText, bool curiosityCompleted
});




}
/// @nodoc
class __$LessonStateCopyWithImpl<$Res>
    implements _$LessonStateCopyWith<$Res> {
  __$LessonStateCopyWithImpl(this._self, this._then);

  final _LessonState _self;
  final $Res Function(_LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? lessonId = null,Object? lessonTitle = null,Object? topicTitle = null,Object? questionText = null,Object? contentText = null,Object? curiosityCompleted = null,}) {
  return _then(_LessonState(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,lessonTitle: null == lessonTitle ? _self.lessonTitle : lessonTitle // ignore: cast_nullable_to_non_nullable
as String,topicTitle: null == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,contentText: null == contentText ? _self.contentText : contentText // ignore: cast_nullable_to_non_nullable
as String,curiosityCompleted: null == curiosityCompleted ? _self.curiosityCompleted : curiosityCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
