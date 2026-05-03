// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonDetails {

 String get taskId; String get lessonId; String get lessonTitle; String get topicTitle; String get questionText; String get contentText; bool get curiosityCompleted;
/// Create a copy of LessonDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonDetailsCopyWith<LessonDetails> get copyWith => _$LessonDetailsCopyWithImpl<LessonDetails>(this as LessonDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonDetails&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.contentText, contentText) || other.contentText == contentText)&&(identical(other.curiosityCompleted, curiosityCompleted) || other.curiosityCompleted == curiosityCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,lessonId,lessonTitle,topicTitle,questionText,contentText,curiosityCompleted);

@override
String toString() {
  return 'LessonDetails(taskId: $taskId, lessonId: $lessonId, lessonTitle: $lessonTitle, topicTitle: $topicTitle, questionText: $questionText, contentText: $contentText, curiosityCompleted: $curiosityCompleted)';
}


}

/// @nodoc
abstract mixin class $LessonDetailsCopyWith<$Res>  {
  factory $LessonDetailsCopyWith(LessonDetails value, $Res Function(LessonDetails) _then) = _$LessonDetailsCopyWithImpl;
@useResult
$Res call({
 String taskId, String lessonId, String lessonTitle, String topicTitle, String questionText, String contentText, bool curiosityCompleted
});




}
/// @nodoc
class _$LessonDetailsCopyWithImpl<$Res>
    implements $LessonDetailsCopyWith<$Res> {
  _$LessonDetailsCopyWithImpl(this._self, this._then);

  final LessonDetails _self;
  final $Res Function(LessonDetails) _then;

/// Create a copy of LessonDetails
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


/// Adds pattern-matching-related methods to [LessonDetails].
extension LessonDetailsPatterns on LessonDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonDetails value)  $default,){
final _that = this;
switch (_that) {
case _LessonDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonDetails value)?  $default,){
final _that = this;
switch (_that) {
case _LessonDetails() when $default != null:
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
case _LessonDetails() when $default != null:
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
case _LessonDetails():
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
case _LessonDetails() when $default != null:
return $default(_that.taskId,_that.lessonId,_that.lessonTitle,_that.topicTitle,_that.questionText,_that.contentText,_that.curiosityCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _LessonDetails implements LessonDetails {
  const _LessonDetails({required this.taskId, required this.lessonId, required this.lessonTitle, required this.topicTitle, required this.questionText, required this.contentText, required this.curiosityCompleted});
  

@override final  String taskId;
@override final  String lessonId;
@override final  String lessonTitle;
@override final  String topicTitle;
@override final  String questionText;
@override final  String contentText;
@override final  bool curiosityCompleted;

/// Create a copy of LessonDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonDetailsCopyWith<_LessonDetails> get copyWith => __$LessonDetailsCopyWithImpl<_LessonDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonDetails&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.contentText, contentText) || other.contentText == contentText)&&(identical(other.curiosityCompleted, curiosityCompleted) || other.curiosityCompleted == curiosityCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,lessonId,lessonTitle,topicTitle,questionText,contentText,curiosityCompleted);

@override
String toString() {
  return 'LessonDetails(taskId: $taskId, lessonId: $lessonId, lessonTitle: $lessonTitle, topicTitle: $topicTitle, questionText: $questionText, contentText: $contentText, curiosityCompleted: $curiosityCompleted)';
}


}

/// @nodoc
abstract mixin class _$LessonDetailsCopyWith<$Res> implements $LessonDetailsCopyWith<$Res> {
  factory _$LessonDetailsCopyWith(_LessonDetails value, $Res Function(_LessonDetails) _then) = __$LessonDetailsCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String lessonId, String lessonTitle, String topicTitle, String questionText, String contentText, bool curiosityCompleted
});




}
/// @nodoc
class __$LessonDetailsCopyWithImpl<$Res>
    implements _$LessonDetailsCopyWith<$Res> {
  __$LessonDetailsCopyWithImpl(this._self, this._then);

  final _LessonDetails _self;
  final $Res Function(_LessonDetails) _then;

/// Create a copy of LessonDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? lessonId = null,Object? lessonTitle = null,Object? topicTitle = null,Object? questionText = null,Object? contentText = null,Object? curiosityCompleted = null,}) {
  return _then(_LessonDetails(
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
