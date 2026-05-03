// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backlog_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BacklogItem {

 String get taskId; String get lessonId; String get lessonTitle; String get topicId; String get topicTitle; String get contentTrack; TaskStatus get taskStatus; bool get curiosityCompleted; int get lessonOrderIndex; int get topicOrderIndex;
/// Create a copy of BacklogItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BacklogItemCopyWith<BacklogItem> get copyWith => _$BacklogItemCopyWithImpl<BacklogItem>(this as BacklogItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BacklogItem&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.contentTrack, contentTrack) || other.contentTrack == contentTrack)&&(identical(other.taskStatus, taskStatus) || other.taskStatus == taskStatus)&&(identical(other.curiosityCompleted, curiosityCompleted) || other.curiosityCompleted == curiosityCompleted)&&(identical(other.lessonOrderIndex, lessonOrderIndex) || other.lessonOrderIndex == lessonOrderIndex)&&(identical(other.topicOrderIndex, topicOrderIndex) || other.topicOrderIndex == topicOrderIndex));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,lessonId,lessonTitle,topicId,topicTitle,contentTrack,taskStatus,curiosityCompleted,lessonOrderIndex,topicOrderIndex);

@override
String toString() {
  return 'BacklogItem(taskId: $taskId, lessonId: $lessonId, lessonTitle: $lessonTitle, topicId: $topicId, topicTitle: $topicTitle, contentTrack: $contentTrack, taskStatus: $taskStatus, curiosityCompleted: $curiosityCompleted, lessonOrderIndex: $lessonOrderIndex, topicOrderIndex: $topicOrderIndex)';
}


}

/// @nodoc
abstract mixin class $BacklogItemCopyWith<$Res>  {
  factory $BacklogItemCopyWith(BacklogItem value, $Res Function(BacklogItem) _then) = _$BacklogItemCopyWithImpl;
@useResult
$Res call({
 String taskId, String lessonId, String lessonTitle, String topicId, String topicTitle, String contentTrack, TaskStatus taskStatus, bool curiosityCompleted, int lessonOrderIndex, int topicOrderIndex
});




}
/// @nodoc
class _$BacklogItemCopyWithImpl<$Res>
    implements $BacklogItemCopyWith<$Res> {
  _$BacklogItemCopyWithImpl(this._self, this._then);

  final BacklogItem _self;
  final $Res Function(BacklogItem) _then;

/// Create a copy of BacklogItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? lessonId = null,Object? lessonTitle = null,Object? topicId = null,Object? topicTitle = null,Object? contentTrack = null,Object? taskStatus = null,Object? curiosityCompleted = null,Object? lessonOrderIndex = null,Object? topicOrderIndex = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,lessonTitle: null == lessonTitle ? _self.lessonTitle : lessonTitle // ignore: cast_nullable_to_non_nullable
as String,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,topicTitle: null == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String,contentTrack: null == contentTrack ? _self.contentTrack : contentTrack // ignore: cast_nullable_to_non_nullable
as String,taskStatus: null == taskStatus ? _self.taskStatus : taskStatus // ignore: cast_nullable_to_non_nullable
as TaskStatus,curiosityCompleted: null == curiosityCompleted ? _self.curiosityCompleted : curiosityCompleted // ignore: cast_nullable_to_non_nullable
as bool,lessonOrderIndex: null == lessonOrderIndex ? _self.lessonOrderIndex : lessonOrderIndex // ignore: cast_nullable_to_non_nullable
as int,topicOrderIndex: null == topicOrderIndex ? _self.topicOrderIndex : topicOrderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BacklogItem].
extension BacklogItemPatterns on BacklogItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BacklogItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BacklogItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BacklogItem value)  $default,){
final _that = this;
switch (_that) {
case _BacklogItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BacklogItem value)?  $default,){
final _that = this;
switch (_that) {
case _BacklogItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String lessonId,  String lessonTitle,  String topicId,  String topicTitle,  String contentTrack,  TaskStatus taskStatus,  bool curiosityCompleted,  int lessonOrderIndex,  int topicOrderIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BacklogItem() when $default != null:
return $default(_that.taskId,_that.lessonId,_that.lessonTitle,_that.topicId,_that.topicTitle,_that.contentTrack,_that.taskStatus,_that.curiosityCompleted,_that.lessonOrderIndex,_that.topicOrderIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String lessonId,  String lessonTitle,  String topicId,  String topicTitle,  String contentTrack,  TaskStatus taskStatus,  bool curiosityCompleted,  int lessonOrderIndex,  int topicOrderIndex)  $default,) {final _that = this;
switch (_that) {
case _BacklogItem():
return $default(_that.taskId,_that.lessonId,_that.lessonTitle,_that.topicId,_that.topicTitle,_that.contentTrack,_that.taskStatus,_that.curiosityCompleted,_that.lessonOrderIndex,_that.topicOrderIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String lessonId,  String lessonTitle,  String topicId,  String topicTitle,  String contentTrack,  TaskStatus taskStatus,  bool curiosityCompleted,  int lessonOrderIndex,  int topicOrderIndex)?  $default,) {final _that = this;
switch (_that) {
case _BacklogItem() when $default != null:
return $default(_that.taskId,_that.lessonId,_that.lessonTitle,_that.topicId,_that.topicTitle,_that.contentTrack,_that.taskStatus,_that.curiosityCompleted,_that.lessonOrderIndex,_that.topicOrderIndex);case _:
  return null;

}
}

}

/// @nodoc


class _BacklogItem implements BacklogItem {
  const _BacklogItem({required this.taskId, required this.lessonId, required this.lessonTitle, required this.topicId, required this.topicTitle, required this.contentTrack, required this.taskStatus, required this.curiosityCompleted, required this.lessonOrderIndex, required this.topicOrderIndex});
  

@override final  String taskId;
@override final  String lessonId;
@override final  String lessonTitle;
@override final  String topicId;
@override final  String topicTitle;
@override final  String contentTrack;
@override final  TaskStatus taskStatus;
@override final  bool curiosityCompleted;
@override final  int lessonOrderIndex;
@override final  int topicOrderIndex;

/// Create a copy of BacklogItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BacklogItemCopyWith<_BacklogItem> get copyWith => __$BacklogItemCopyWithImpl<_BacklogItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BacklogItem&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.contentTrack, contentTrack) || other.contentTrack == contentTrack)&&(identical(other.taskStatus, taskStatus) || other.taskStatus == taskStatus)&&(identical(other.curiosityCompleted, curiosityCompleted) || other.curiosityCompleted == curiosityCompleted)&&(identical(other.lessonOrderIndex, lessonOrderIndex) || other.lessonOrderIndex == lessonOrderIndex)&&(identical(other.topicOrderIndex, topicOrderIndex) || other.topicOrderIndex == topicOrderIndex));
}


@override
int get hashCode => Object.hash(runtimeType,taskId,lessonId,lessonTitle,topicId,topicTitle,contentTrack,taskStatus,curiosityCompleted,lessonOrderIndex,topicOrderIndex);

@override
String toString() {
  return 'BacklogItem(taskId: $taskId, lessonId: $lessonId, lessonTitle: $lessonTitle, topicId: $topicId, topicTitle: $topicTitle, contentTrack: $contentTrack, taskStatus: $taskStatus, curiosityCompleted: $curiosityCompleted, lessonOrderIndex: $lessonOrderIndex, topicOrderIndex: $topicOrderIndex)';
}


}

/// @nodoc
abstract mixin class _$BacklogItemCopyWith<$Res> implements $BacklogItemCopyWith<$Res> {
  factory _$BacklogItemCopyWith(_BacklogItem value, $Res Function(_BacklogItem) _then) = __$BacklogItemCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String lessonId, String lessonTitle, String topicId, String topicTitle, String contentTrack, TaskStatus taskStatus, bool curiosityCompleted, int lessonOrderIndex, int topicOrderIndex
});




}
/// @nodoc
class __$BacklogItemCopyWithImpl<$Res>
    implements _$BacklogItemCopyWith<$Res> {
  __$BacklogItemCopyWithImpl(this._self, this._then);

  final _BacklogItem _self;
  final $Res Function(_BacklogItem) _then;

/// Create a copy of BacklogItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? lessonId = null,Object? lessonTitle = null,Object? topicId = null,Object? topicTitle = null,Object? contentTrack = null,Object? taskStatus = null,Object? curiosityCompleted = null,Object? lessonOrderIndex = null,Object? topicOrderIndex = null,}) {
  return _then(_BacklogItem(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,lessonTitle: null == lessonTitle ? _self.lessonTitle : lessonTitle // ignore: cast_nullable_to_non_nullable
as String,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,topicTitle: null == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String,contentTrack: null == contentTrack ? _self.contentTrack : contentTrack // ignore: cast_nullable_to_non_nullable
as String,taskStatus: null == taskStatus ? _self.taskStatus : taskStatus // ignore: cast_nullable_to_non_nullable
as TaskStatus,curiosityCompleted: null == curiosityCompleted ? _self.curiosityCompleted : curiosityCompleted // ignore: cast_nullable_to_non_nullable
as bool,lessonOrderIndex: null == lessonOrderIndex ? _self.lessonOrderIndex : lessonOrderIndex // ignore: cast_nullable_to_non_nullable
as int,topicOrderIndex: null == topicOrderIndex ? _self.topicOrderIndex : topicOrderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
