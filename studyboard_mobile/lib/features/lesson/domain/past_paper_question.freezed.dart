// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'past_paper_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PastPaperQuestion {

 String get id;@JsonKey(name: 'lesson_id') String get lessonId;@JsonKey(name: 'topic_id') String get topicId;@JsonKey(name: 'question_text') String get questionText;@JsonKey(name: 'order_index') int get orderIndex; int? get year;
/// Create a copy of PastPaperQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastPaperQuestionCopyWith<PastPaperQuestion> get copyWith => _$PastPaperQuestionCopyWithImpl<PastPaperQuestion>(this as PastPaperQuestion, _$identity);

  /// Serializes this PastPaperQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastPaperQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.year, year) || other.year == year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lessonId,topicId,questionText,orderIndex,year);

@override
String toString() {
  return 'PastPaperQuestion(id: $id, lessonId: $lessonId, topicId: $topicId, questionText: $questionText, orderIndex: $orderIndex, year: $year)';
}


}

/// @nodoc
abstract mixin class $PastPaperQuestionCopyWith<$Res>  {
  factory $PastPaperQuestionCopyWith(PastPaperQuestion value, $Res Function(PastPaperQuestion) _then) = _$PastPaperQuestionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'topic_id') String topicId,@JsonKey(name: 'question_text') String questionText,@JsonKey(name: 'order_index') int orderIndex, int? year
});




}
/// @nodoc
class _$PastPaperQuestionCopyWithImpl<$Res>
    implements $PastPaperQuestionCopyWith<$Res> {
  _$PastPaperQuestionCopyWithImpl(this._self, this._then);

  final PastPaperQuestion _self;
  final $Res Function(PastPaperQuestion) _then;

/// Create a copy of PastPaperQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lessonId = null,Object? topicId = null,Object? questionText = null,Object? orderIndex = null,Object? year = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PastPaperQuestion].
extension PastPaperQuestionPatterns on PastPaperQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PastPaperQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PastPaperQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PastPaperQuestion value)  $default,){
final _that = this;
switch (_that) {
case _PastPaperQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PastPaperQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _PastPaperQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'topic_id')  String topicId, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'order_index')  int orderIndex,  int? year)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PastPaperQuestion() when $default != null:
return $default(_that.id,_that.lessonId,_that.topicId,_that.questionText,_that.orderIndex,_that.year);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'topic_id')  String topicId, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'order_index')  int orderIndex,  int? year)  $default,) {final _that = this;
switch (_that) {
case _PastPaperQuestion():
return $default(_that.id,_that.lessonId,_that.topicId,_that.questionText,_that.orderIndex,_that.year);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'topic_id')  String topicId, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'order_index')  int orderIndex,  int? year)?  $default,) {final _that = this;
switch (_that) {
case _PastPaperQuestion() when $default != null:
return $default(_that.id,_that.lessonId,_that.topicId,_that.questionText,_that.orderIndex,_that.year);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PastPaperQuestion implements PastPaperQuestion {
  const _PastPaperQuestion({required this.id, @JsonKey(name: 'lesson_id') required this.lessonId, @JsonKey(name: 'topic_id') required this.topicId, @JsonKey(name: 'question_text') required this.questionText, @JsonKey(name: 'order_index') required this.orderIndex, this.year});
  factory _PastPaperQuestion.fromJson(Map<String, dynamic> json) => _$PastPaperQuestionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'lesson_id') final  String lessonId;
@override@JsonKey(name: 'topic_id') final  String topicId;
@override@JsonKey(name: 'question_text') final  String questionText;
@override@JsonKey(name: 'order_index') final  int orderIndex;
@override final  int? year;

/// Create a copy of PastPaperQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PastPaperQuestionCopyWith<_PastPaperQuestion> get copyWith => __$PastPaperQuestionCopyWithImpl<_PastPaperQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PastPaperQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PastPaperQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.year, year) || other.year == year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lessonId,topicId,questionText,orderIndex,year);

@override
String toString() {
  return 'PastPaperQuestion(id: $id, lessonId: $lessonId, topicId: $topicId, questionText: $questionText, orderIndex: $orderIndex, year: $year)';
}


}

/// @nodoc
abstract mixin class _$PastPaperQuestionCopyWith<$Res> implements $PastPaperQuestionCopyWith<$Res> {
  factory _$PastPaperQuestionCopyWith(_PastPaperQuestion value, $Res Function(_PastPaperQuestion) _then) = __$PastPaperQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'topic_id') String topicId,@JsonKey(name: 'question_text') String questionText,@JsonKey(name: 'order_index') int orderIndex, int? year
});




}
/// @nodoc
class __$PastPaperQuestionCopyWithImpl<$Res>
    implements _$PastPaperQuestionCopyWith<$Res> {
  __$PastPaperQuestionCopyWithImpl(this._self, this._then);

  final _PastPaperQuestion _self;
  final $Res Function(_PastPaperQuestion) _then;

/// Create a copy of PastPaperQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lessonId = null,Object? topicId = null,Object? questionText = null,Object? orderIndex = null,Object? year = freezed,}) {
  return _then(_PastPaperQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
