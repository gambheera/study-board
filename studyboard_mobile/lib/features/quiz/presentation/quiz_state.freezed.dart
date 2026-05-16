// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizState {

 List<QuizQuestion> get questions; String get lessonId; String get lessonTitle; Map<int, String> get selectedAnswers;
/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizStateCopyWith<QuizState> get copyWith => _$QuizStateCopyWithImpl<QuizState>(this as QuizState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizState&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&const DeepCollectionEquality().equals(other.selectedAnswers, selectedAnswers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(questions),lessonId,lessonTitle,const DeepCollectionEquality().hash(selectedAnswers));

@override
String toString() {
  return 'QuizState(questions: $questions, lessonId: $lessonId, lessonTitle: $lessonTitle, selectedAnswers: $selectedAnswers)';
}


}

/// @nodoc
abstract mixin class $QuizStateCopyWith<$Res>  {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) _then) = _$QuizStateCopyWithImpl;
@useResult
$Res call({
 List<QuizQuestion> questions, String lessonId, String lessonTitle, Map<int, String> selectedAnswers
});




}
/// @nodoc
class _$QuizStateCopyWithImpl<$Res>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._self, this._then);

  final QuizState _self;
  final $Res Function(QuizState) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,Object? lessonId = null,Object? lessonTitle = null,Object? selectedAnswers = null,}) {
  return _then(_self.copyWith(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,lessonTitle: null == lessonTitle ? _self.lessonTitle : lessonTitle // ignore: cast_nullable_to_non_nullable
as String,selectedAnswers: null == selectedAnswers ? _self.selectedAnswers : selectedAnswers // ignore: cast_nullable_to_non_nullable
as Map<int, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizState].
extension QuizStatePatterns on QuizState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QuizActive value)?  active,TResult Function( QuizCompleted value)?  completed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QuizActive() when active != null:
return active(_that);case QuizCompleted() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QuizActive value)  active,required TResult Function( QuizCompleted value)  completed,}){
final _that = this;
switch (_that) {
case QuizActive():
return active(_that);case QuizCompleted():
return completed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QuizActive value)?  active,TResult? Function( QuizCompleted value)?  completed,}){
final _that = this;
switch (_that) {
case QuizActive() when active != null:
return active(_that);case QuizCompleted() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<QuizQuestion> questions,  int currentIndex,  double passThreshold,  String lessonId,  String lessonTitle,  Map<int, String> selectedAnswers)?  active,TResult Function( double score,  bool passed,  int correctCount,  int totalQuestions,  String lessonId,  String lessonTitle,  List<QuizQuestion> questions,  Map<int, String> selectedAnswers,  int failedAttemptCount)?  completed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QuizActive() when active != null:
return active(_that.questions,_that.currentIndex,_that.passThreshold,_that.lessonId,_that.lessonTitle,_that.selectedAnswers);case QuizCompleted() when completed != null:
return completed(_that.score,_that.passed,_that.correctCount,_that.totalQuestions,_that.lessonId,_that.lessonTitle,_that.questions,_that.selectedAnswers,_that.failedAttemptCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<QuizQuestion> questions,  int currentIndex,  double passThreshold,  String lessonId,  String lessonTitle,  Map<int, String> selectedAnswers)  active,required TResult Function( double score,  bool passed,  int correctCount,  int totalQuestions,  String lessonId,  String lessonTitle,  List<QuizQuestion> questions,  Map<int, String> selectedAnswers,  int failedAttemptCount)  completed,}) {final _that = this;
switch (_that) {
case QuizActive():
return active(_that.questions,_that.currentIndex,_that.passThreshold,_that.lessonId,_that.lessonTitle,_that.selectedAnswers);case QuizCompleted():
return completed(_that.score,_that.passed,_that.correctCount,_that.totalQuestions,_that.lessonId,_that.lessonTitle,_that.questions,_that.selectedAnswers,_that.failedAttemptCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<QuizQuestion> questions,  int currentIndex,  double passThreshold,  String lessonId,  String lessonTitle,  Map<int, String> selectedAnswers)?  active,TResult? Function( double score,  bool passed,  int correctCount,  int totalQuestions,  String lessonId,  String lessonTitle,  List<QuizQuestion> questions,  Map<int, String> selectedAnswers,  int failedAttemptCount)?  completed,}) {final _that = this;
switch (_that) {
case QuizActive() when active != null:
return active(_that.questions,_that.currentIndex,_that.passThreshold,_that.lessonId,_that.lessonTitle,_that.selectedAnswers);case QuizCompleted() when completed != null:
return completed(_that.score,_that.passed,_that.correctCount,_that.totalQuestions,_that.lessonId,_that.lessonTitle,_that.questions,_that.selectedAnswers,_that.failedAttemptCount);case _:
  return null;

}
}

}

/// @nodoc


class QuizActive implements QuizState {
  const QuizActive({required final  List<QuizQuestion> questions, required this.currentIndex, required this.passThreshold, required this.lessonId, required this.lessonTitle, final  Map<int, String> selectedAnswers = const {}}): _questions = questions,_selectedAnswers = selectedAnswers;
  

 final  List<QuizQuestion> _questions;
@override List<QuizQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  int currentIndex;
 final  double passThreshold;
@override final  String lessonId;
@override final  String lessonTitle;
 final  Map<int, String> _selectedAnswers;
@override@JsonKey() Map<int, String> get selectedAnswers {
  if (_selectedAnswers is EqualUnmodifiableMapView) return _selectedAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_selectedAnswers);
}


/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizActiveCopyWith<QuizActive> get copyWith => _$QuizActiveCopyWithImpl<QuizActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizActive&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.passThreshold, passThreshold) || other.passThreshold == passThreshold)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&const DeepCollectionEquality().equals(other._selectedAnswers, _selectedAnswers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions),currentIndex,passThreshold,lessonId,lessonTitle,const DeepCollectionEquality().hash(_selectedAnswers));

@override
String toString() {
  return 'QuizState.active(questions: $questions, currentIndex: $currentIndex, passThreshold: $passThreshold, lessonId: $lessonId, lessonTitle: $lessonTitle, selectedAnswers: $selectedAnswers)';
}


}

/// @nodoc
abstract mixin class $QuizActiveCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory $QuizActiveCopyWith(QuizActive value, $Res Function(QuizActive) _then) = _$QuizActiveCopyWithImpl;
@override @useResult
$Res call({
 List<QuizQuestion> questions, int currentIndex, double passThreshold, String lessonId, String lessonTitle, Map<int, String> selectedAnswers
});




}
/// @nodoc
class _$QuizActiveCopyWithImpl<$Res>
    implements $QuizActiveCopyWith<$Res> {
  _$QuizActiveCopyWithImpl(this._self, this._then);

  final QuizActive _self;
  final $Res Function(QuizActive) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? currentIndex = null,Object? passThreshold = null,Object? lessonId = null,Object? lessonTitle = null,Object? selectedAnswers = null,}) {
  return _then(QuizActive(
questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,passThreshold: null == passThreshold ? _self.passThreshold : passThreshold // ignore: cast_nullable_to_non_nullable
as double,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,lessonTitle: null == lessonTitle ? _self.lessonTitle : lessonTitle // ignore: cast_nullable_to_non_nullable
as String,selectedAnswers: null == selectedAnswers ? _self._selectedAnswers : selectedAnswers // ignore: cast_nullable_to_non_nullable
as Map<int, String>,
  ));
}


}

/// @nodoc


class QuizCompleted implements QuizState {
  const QuizCompleted({required this.score, required this.passed, required this.correctCount, required this.totalQuestions, required this.lessonId, required this.lessonTitle, required final  List<QuizQuestion> questions, required final  Map<int, String> selectedAnswers, this.failedAttemptCount = 0}): _questions = questions,_selectedAnswers = selectedAnswers;
  

 final  double score;
 final  bool passed;
 final  int correctCount;
 final  int totalQuestions;
@override final  String lessonId;
@override final  String lessonTitle;
 final  List<QuizQuestion> _questions;
@override List<QuizQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  Map<int, String> _selectedAnswers;
@override Map<int, String> get selectedAnswers {
  if (_selectedAnswers is EqualUnmodifiableMapView) return _selectedAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_selectedAnswers);
}

@JsonKey() final  int failedAttemptCount;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizCompletedCopyWith<QuizCompleted> get copyWith => _$QuizCompletedCopyWithImpl<QuizCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizCompleted&&(identical(other.score, score) || other.score == score)&&(identical(other.passed, passed) || other.passed == passed)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonTitle, lessonTitle) || other.lessonTitle == lessonTitle)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._selectedAnswers, _selectedAnswers)&&(identical(other.failedAttemptCount, failedAttemptCount) || other.failedAttemptCount == failedAttemptCount));
}


@override
int get hashCode => Object.hash(runtimeType,score,passed,correctCount,totalQuestions,lessonId,lessonTitle,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_selectedAnswers),failedAttemptCount);

@override
String toString() {
  return 'QuizState.completed(score: $score, passed: $passed, correctCount: $correctCount, totalQuestions: $totalQuestions, lessonId: $lessonId, lessonTitle: $lessonTitle, questions: $questions, selectedAnswers: $selectedAnswers, failedAttemptCount: $failedAttemptCount)';
}


}

/// @nodoc
abstract mixin class $QuizCompletedCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory $QuizCompletedCopyWith(QuizCompleted value, $Res Function(QuizCompleted) _then) = _$QuizCompletedCopyWithImpl;
@override @useResult
$Res call({
 double score, bool passed, int correctCount, int totalQuestions, String lessonId, String lessonTitle, List<QuizQuestion> questions, Map<int, String> selectedAnswers, int failedAttemptCount
});




}
/// @nodoc
class _$QuizCompletedCopyWithImpl<$Res>
    implements $QuizCompletedCopyWith<$Res> {
  _$QuizCompletedCopyWithImpl(this._self, this._then);

  final QuizCompleted _self;
  final $Res Function(QuizCompleted) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? passed = null,Object? correctCount = null,Object? totalQuestions = null,Object? lessonId = null,Object? lessonTitle = null,Object? questions = null,Object? selectedAnswers = null,Object? failedAttemptCount = null,}) {
  return _then(QuizCompleted(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,lessonTitle: null == lessonTitle ? _self.lessonTitle : lessonTitle // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,selectedAnswers: null == selectedAnswers ? _self._selectedAnswers : selectedAnswers // ignore: cast_nullable_to_non_nullable
as Map<int, String>,failedAttemptCount: null == failedAttemptCount ? _self.failedAttemptCount : failedAttemptCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
