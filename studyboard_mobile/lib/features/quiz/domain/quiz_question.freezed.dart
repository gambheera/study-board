// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizQuestion {

 String get id;@JsonKey(name: 'lesson_id') String get lessonId;@JsonKey(name: 'question_text') String get questionText;@JsonKey(name: 'option_a') String get optionA;@JsonKey(name: 'option_b') String get optionB;@JsonKey(name: 'option_c') String get optionC;@JsonKey(name: 'option_d') String get optionD;@JsonKey(name: 'correct_option') String get correctOption;@JsonKey(name: 'order_index') int get orderIndex;
/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<QuizQuestion> get copyWith => _$QuizQuestionCopyWithImpl<QuizQuestion>(this as QuizQuestion, _$identity);

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.optionA, optionA) || other.optionA == optionA)&&(identical(other.optionB, optionB) || other.optionB == optionB)&&(identical(other.optionC, optionC) || other.optionC == optionC)&&(identical(other.optionD, optionD) || other.optionD == optionD)&&(identical(other.correctOption, correctOption) || other.correctOption == correctOption)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lessonId,questionText,optionA,optionB,optionC,optionD,correctOption,orderIndex);

@override
String toString() {
  return 'QuizQuestion(id: $id, lessonId: $lessonId, questionText: $questionText, optionA: $optionA, optionB: $optionB, optionC: $optionC, optionD: $optionD, correctOption: $correctOption, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class $QuizQuestionCopyWith<$Res>  {
  factory $QuizQuestionCopyWith(QuizQuestion value, $Res Function(QuizQuestion) _then) = _$QuizQuestionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'question_text') String questionText,@JsonKey(name: 'option_a') String optionA,@JsonKey(name: 'option_b') String optionB,@JsonKey(name: 'option_c') String optionC,@JsonKey(name: 'option_d') String optionD,@JsonKey(name: 'correct_option') String correctOption,@JsonKey(name: 'order_index') int orderIndex
});




}
/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._self, this._then);

  final QuizQuestion _self;
  final $Res Function(QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lessonId = null,Object? questionText = null,Object? optionA = null,Object? optionB = null,Object? optionC = null,Object? optionD = null,Object? correctOption = null,Object? orderIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,optionA: null == optionA ? _self.optionA : optionA // ignore: cast_nullable_to_non_nullable
as String,optionB: null == optionB ? _self.optionB : optionB // ignore: cast_nullable_to_non_nullable
as String,optionC: null == optionC ? _self.optionC : optionC // ignore: cast_nullable_to_non_nullable
as String,optionD: null == optionD ? _self.optionD : optionD // ignore: cast_nullable_to_non_nullable
as String,correctOption: null == correctOption ? _self.correctOption : correctOption // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizQuestion].
extension QuizQuestionPatterns on QuizQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizQuestion value)  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'option_a')  String optionA, @JsonKey(name: 'option_b')  String optionB, @JsonKey(name: 'option_c')  String optionC, @JsonKey(name: 'option_d')  String optionD, @JsonKey(name: 'correct_option')  String correctOption, @JsonKey(name: 'order_index')  int orderIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.lessonId,_that.questionText,_that.optionA,_that.optionB,_that.optionC,_that.optionD,_that.correctOption,_that.orderIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'option_a')  String optionA, @JsonKey(name: 'option_b')  String optionB, @JsonKey(name: 'option_c')  String optionC, @JsonKey(name: 'option_d')  String optionD, @JsonKey(name: 'correct_option')  String correctOption, @JsonKey(name: 'order_index')  int orderIndex)  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion():
return $default(_that.id,_that.lessonId,_that.questionText,_that.optionA,_that.optionB,_that.optionC,_that.optionD,_that.correctOption,_that.orderIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'question_text')  String questionText, @JsonKey(name: 'option_a')  String optionA, @JsonKey(name: 'option_b')  String optionB, @JsonKey(name: 'option_c')  String optionC, @JsonKey(name: 'option_d')  String optionD, @JsonKey(name: 'correct_option')  String correctOption, @JsonKey(name: 'order_index')  int orderIndex)?  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.lessonId,_that.questionText,_that.optionA,_that.optionB,_that.optionC,_that.optionD,_that.correctOption,_that.orderIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizQuestion implements QuizQuestion {
  const _QuizQuestion({required this.id, @JsonKey(name: 'lesson_id') required this.lessonId, @JsonKey(name: 'question_text') required this.questionText, @JsonKey(name: 'option_a') required this.optionA, @JsonKey(name: 'option_b') required this.optionB, @JsonKey(name: 'option_c') required this.optionC, @JsonKey(name: 'option_d') required this.optionD, @JsonKey(name: 'correct_option') required this.correctOption, @JsonKey(name: 'order_index') required this.orderIndex});
  factory _QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'lesson_id') final  String lessonId;
@override@JsonKey(name: 'question_text') final  String questionText;
@override@JsonKey(name: 'option_a') final  String optionA;
@override@JsonKey(name: 'option_b') final  String optionB;
@override@JsonKey(name: 'option_c') final  String optionC;
@override@JsonKey(name: 'option_d') final  String optionD;
@override@JsonKey(name: 'correct_option') final  String correctOption;
@override@JsonKey(name: 'order_index') final  int orderIndex;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizQuestionCopyWith<_QuizQuestion> get copyWith => __$QuizQuestionCopyWithImpl<_QuizQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.optionA, optionA) || other.optionA == optionA)&&(identical(other.optionB, optionB) || other.optionB == optionB)&&(identical(other.optionC, optionC) || other.optionC == optionC)&&(identical(other.optionD, optionD) || other.optionD == optionD)&&(identical(other.correctOption, correctOption) || other.correctOption == correctOption)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lessonId,questionText,optionA,optionB,optionC,optionD,correctOption,orderIndex);

@override
String toString() {
  return 'QuizQuestion(id: $id, lessonId: $lessonId, questionText: $questionText, optionA: $optionA, optionB: $optionB, optionC: $optionC, optionD: $optionD, correctOption: $correctOption, orderIndex: $orderIndex)';
}


}

/// @nodoc
abstract mixin class _$QuizQuestionCopyWith<$Res> implements $QuizQuestionCopyWith<$Res> {
  factory _$QuizQuestionCopyWith(_QuizQuestion value, $Res Function(_QuizQuestion) _then) = __$QuizQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'question_text') String questionText,@JsonKey(name: 'option_a') String optionA,@JsonKey(name: 'option_b') String optionB,@JsonKey(name: 'option_c') String optionC,@JsonKey(name: 'option_d') String optionD,@JsonKey(name: 'correct_option') String correctOption,@JsonKey(name: 'order_index') int orderIndex
});




}
/// @nodoc
class __$QuizQuestionCopyWithImpl<$Res>
    implements _$QuizQuestionCopyWith<$Res> {
  __$QuizQuestionCopyWithImpl(this._self, this._then);

  final _QuizQuestion _self;
  final $Res Function(_QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lessonId = null,Object? questionText = null,Object? optionA = null,Object? optionB = null,Object? optionC = null,Object? optionD = null,Object? correctOption = null,Object? orderIndex = null,}) {
  return _then(_QuizQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,optionA: null == optionA ? _self.optionA : optionA // ignore: cast_nullable_to_non_nullable
as String,optionB: null == optionB ? _self.optionB : optionB // ignore: cast_nullable_to_non_nullable
as String,optionC: null == optionC ? _self.optionC : optionC // ignore: cast_nullable_to_non_nullable
as String,optionD: null == optionD ? _self.optionD : optionD // ignore: cast_nullable_to_non_nullable
as String,correctOption: null == correctOption ? _self.correctOption : correctOption // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
