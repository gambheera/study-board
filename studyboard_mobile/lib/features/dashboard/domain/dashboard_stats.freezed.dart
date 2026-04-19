// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeakTopic {

@JsonKey(name: 'topic_id') String get topicId;@JsonKey(name: 'topic_title') String get topicTitle;@JsonKey(name: 'accuracy_percent') double get accuracyPercent;
/// Create a copy of WeakTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeakTopicCopyWith<WeakTopic> get copyWith => _$WeakTopicCopyWithImpl<WeakTopic>(this as WeakTopic, _$identity);

  /// Serializes this WeakTopic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakTopic&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.accuracyPercent, accuracyPercent) || other.accuracyPercent == accuracyPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topicId,topicTitle,accuracyPercent);

@override
String toString() {
  return 'WeakTopic(topicId: $topicId, topicTitle: $topicTitle, accuracyPercent: $accuracyPercent)';
}


}

/// @nodoc
abstract mixin class $WeakTopicCopyWith<$Res>  {
  factory $WeakTopicCopyWith(WeakTopic value, $Res Function(WeakTopic) _then) = _$WeakTopicCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'topic_id') String topicId,@JsonKey(name: 'topic_title') String topicTitle,@JsonKey(name: 'accuracy_percent') double accuracyPercent
});




}
/// @nodoc
class _$WeakTopicCopyWithImpl<$Res>
    implements $WeakTopicCopyWith<$Res> {
  _$WeakTopicCopyWithImpl(this._self, this._then);

  final WeakTopic _self;
  final $Res Function(WeakTopic) _then;

/// Create a copy of WeakTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topicId = null,Object? topicTitle = null,Object? accuracyPercent = null,}) {
  return _then(_self.copyWith(
topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,topicTitle: null == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String,accuracyPercent: null == accuracyPercent ? _self.accuracyPercent : accuracyPercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeakTopic].
extension WeakTopicPatterns on WeakTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeakTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeakTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeakTopic value)  $default,){
final _that = this;
switch (_that) {
case _WeakTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeakTopic value)?  $default,){
final _that = this;
switch (_that) {
case _WeakTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'topic_id')  String topicId, @JsonKey(name: 'topic_title')  String topicTitle, @JsonKey(name: 'accuracy_percent')  double accuracyPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeakTopic() when $default != null:
return $default(_that.topicId,_that.topicTitle,_that.accuracyPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'topic_id')  String topicId, @JsonKey(name: 'topic_title')  String topicTitle, @JsonKey(name: 'accuracy_percent')  double accuracyPercent)  $default,) {final _that = this;
switch (_that) {
case _WeakTopic():
return $default(_that.topicId,_that.topicTitle,_that.accuracyPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'topic_id')  String topicId, @JsonKey(name: 'topic_title')  String topicTitle, @JsonKey(name: 'accuracy_percent')  double accuracyPercent)?  $default,) {final _that = this;
switch (_that) {
case _WeakTopic() when $default != null:
return $default(_that.topicId,_that.topicTitle,_that.accuracyPercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeakTopic implements WeakTopic {
  const _WeakTopic({@JsonKey(name: 'topic_id') required this.topicId, @JsonKey(name: 'topic_title') required this.topicTitle, @JsonKey(name: 'accuracy_percent') required this.accuracyPercent});
  factory _WeakTopic.fromJson(Map<String, dynamic> json) => _$WeakTopicFromJson(json);

@override@JsonKey(name: 'topic_id') final  String topicId;
@override@JsonKey(name: 'topic_title') final  String topicTitle;
@override@JsonKey(name: 'accuracy_percent') final  double accuracyPercent;

/// Create a copy of WeakTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakTopicCopyWith<_WeakTopic> get copyWith => __$WeakTopicCopyWithImpl<_WeakTopic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeakTopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakTopic&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.accuracyPercent, accuracyPercent) || other.accuracyPercent == accuracyPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topicId,topicTitle,accuracyPercent);

@override
String toString() {
  return 'WeakTopic(topicId: $topicId, topicTitle: $topicTitle, accuracyPercent: $accuracyPercent)';
}


}

/// @nodoc
abstract mixin class _$WeakTopicCopyWith<$Res> implements $WeakTopicCopyWith<$Res> {
  factory _$WeakTopicCopyWith(_WeakTopic value, $Res Function(_WeakTopic) _then) = __$WeakTopicCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'topic_id') String topicId,@JsonKey(name: 'topic_title') String topicTitle,@JsonKey(name: 'accuracy_percent') double accuracyPercent
});




}
/// @nodoc
class __$WeakTopicCopyWithImpl<$Res>
    implements _$WeakTopicCopyWith<$Res> {
  __$WeakTopicCopyWithImpl(this._self, this._then);

  final _WeakTopic _self;
  final $Res Function(_WeakTopic) _then;

/// Create a copy of WeakTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topicId = null,Object? topicTitle = null,Object? accuracyPercent = null,}) {
  return _then(_WeakTopic(
topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,topicTitle: null == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String,accuracyPercent: null == accuracyPercent ? _self.accuracyPercent : accuracyPercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DashboardStats {

@JsonKey(name: 'coverage_percent') double get coveragePercent;@JsonKey(name: 'overall_accuracy') double get overallAccuracy; int get streak;@JsonKey(name: 'tasks_in_done') int get tasksInDone;@JsonKey(name: 'weak_topics') List<WeakTopic> get weakTopics;
/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<DashboardStats> get copyWith => _$DashboardStatsCopyWithImpl<DashboardStats>(this as DashboardStats, _$identity);

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStats&&(identical(other.coveragePercent, coveragePercent) || other.coveragePercent == coveragePercent)&&(identical(other.overallAccuracy, overallAccuracy) || other.overallAccuracy == overallAccuracy)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.tasksInDone, tasksInDone) || other.tasksInDone == tasksInDone)&&const DeepCollectionEquality().equals(other.weakTopics, weakTopics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coveragePercent,overallAccuracy,streak,tasksInDone,const DeepCollectionEquality().hash(weakTopics));

@override
String toString() {
  return 'DashboardStats(coveragePercent: $coveragePercent, overallAccuracy: $overallAccuracy, streak: $streak, tasksInDone: $tasksInDone, weakTopics: $weakTopics)';
}


}

/// @nodoc
abstract mixin class $DashboardStatsCopyWith<$Res>  {
  factory $DashboardStatsCopyWith(DashboardStats value, $Res Function(DashboardStats) _then) = _$DashboardStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'coverage_percent') double coveragePercent,@JsonKey(name: 'overall_accuracy') double overallAccuracy, int streak,@JsonKey(name: 'tasks_in_done') int tasksInDone,@JsonKey(name: 'weak_topics') List<WeakTopic> weakTopics
});




}
/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._self, this._then);

  final DashboardStats _self;
  final $Res Function(DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coveragePercent = null,Object? overallAccuracy = null,Object? streak = null,Object? tasksInDone = null,Object? weakTopics = null,}) {
  return _then(_self.copyWith(
coveragePercent: null == coveragePercent ? _self.coveragePercent : coveragePercent // ignore: cast_nullable_to_non_nullable
as double,overallAccuracy: null == overallAccuracy ? _self.overallAccuracy : overallAccuracy // ignore: cast_nullable_to_non_nullable
as double,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,tasksInDone: null == tasksInDone ? _self.tasksInDone : tasksInDone // ignore: cast_nullable_to_non_nullable
as int,weakTopics: null == weakTopics ? _self.weakTopics : weakTopics // ignore: cast_nullable_to_non_nullable
as List<WeakTopic>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardStats].
extension DashboardStatsPatterns on DashboardStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardStats value)  $default,){
final _that = this;
switch (_that) {
case _DashboardStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardStats value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'coverage_percent')  double coveragePercent, @JsonKey(name: 'overall_accuracy')  double overallAccuracy,  int streak, @JsonKey(name: 'tasks_in_done')  int tasksInDone, @JsonKey(name: 'weak_topics')  List<WeakTopic> weakTopics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.coveragePercent,_that.overallAccuracy,_that.streak,_that.tasksInDone,_that.weakTopics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'coverage_percent')  double coveragePercent, @JsonKey(name: 'overall_accuracy')  double overallAccuracy,  int streak, @JsonKey(name: 'tasks_in_done')  int tasksInDone, @JsonKey(name: 'weak_topics')  List<WeakTopic> weakTopics)  $default,) {final _that = this;
switch (_that) {
case _DashboardStats():
return $default(_that.coveragePercent,_that.overallAccuracy,_that.streak,_that.tasksInDone,_that.weakTopics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'coverage_percent')  double coveragePercent, @JsonKey(name: 'overall_accuracy')  double overallAccuracy,  int streak, @JsonKey(name: 'tasks_in_done')  int tasksInDone, @JsonKey(name: 'weak_topics')  List<WeakTopic> weakTopics)?  $default,) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.coveragePercent,_that.overallAccuracy,_that.streak,_that.tasksInDone,_that.weakTopics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardStats implements DashboardStats {
  const _DashboardStats({@JsonKey(name: 'coverage_percent') required this.coveragePercent, @JsonKey(name: 'overall_accuracy') required this.overallAccuracy, required this.streak, @JsonKey(name: 'tasks_in_done') required this.tasksInDone, @JsonKey(name: 'weak_topics') required final  List<WeakTopic> weakTopics}): _weakTopics = weakTopics;
  factory _DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);

@override@JsonKey(name: 'coverage_percent') final  double coveragePercent;
@override@JsonKey(name: 'overall_accuracy') final  double overallAccuracy;
@override final  int streak;
@override@JsonKey(name: 'tasks_in_done') final  int tasksInDone;
 final  List<WeakTopic> _weakTopics;
@override@JsonKey(name: 'weak_topics') List<WeakTopic> get weakTopics {
  if (_weakTopics is EqualUnmodifiableListView) return _weakTopics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weakTopics);
}


/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatsCopyWith<_DashboardStats> get copyWith => __$DashboardStatsCopyWithImpl<_DashboardStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStats&&(identical(other.coveragePercent, coveragePercent) || other.coveragePercent == coveragePercent)&&(identical(other.overallAccuracy, overallAccuracy) || other.overallAccuracy == overallAccuracy)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.tasksInDone, tasksInDone) || other.tasksInDone == tasksInDone)&&const DeepCollectionEquality().equals(other._weakTopics, _weakTopics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,coveragePercent,overallAccuracy,streak,tasksInDone,const DeepCollectionEquality().hash(_weakTopics));

@override
String toString() {
  return 'DashboardStats(coveragePercent: $coveragePercent, overallAccuracy: $overallAccuracy, streak: $streak, tasksInDone: $tasksInDone, weakTopics: $weakTopics)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatsCopyWith<$Res> implements $DashboardStatsCopyWith<$Res> {
  factory _$DashboardStatsCopyWith(_DashboardStats value, $Res Function(_DashboardStats) _then) = __$DashboardStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'coverage_percent') double coveragePercent,@JsonKey(name: 'overall_accuracy') double overallAccuracy, int streak,@JsonKey(name: 'tasks_in_done') int tasksInDone,@JsonKey(name: 'weak_topics') List<WeakTopic> weakTopics
});




}
/// @nodoc
class __$DashboardStatsCopyWithImpl<$Res>
    implements _$DashboardStatsCopyWith<$Res> {
  __$DashboardStatsCopyWithImpl(this._self, this._then);

  final _DashboardStats _self;
  final $Res Function(_DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coveragePercent = null,Object? overallAccuracy = null,Object? streak = null,Object? tasksInDone = null,Object? weakTopics = null,}) {
  return _then(_DashboardStats(
coveragePercent: null == coveragePercent ? _self.coveragePercent : coveragePercent // ignore: cast_nullable_to_non_nullable
as double,overallAccuracy: null == overallAccuracy ? _self.overallAccuracy : overallAccuracy // ignore: cast_nullable_to_non_nullable
as double,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,tasksInDone: null == tasksInDone ? _self.tasksInDone : tasksInDone // ignore: cast_nullable_to_non_nullable
as int,weakTopics: null == weakTopics ? _self._weakTopics : weakTopics // ignore: cast_nullable_to_non_nullable
as List<WeakTopic>,
  ));
}


}

// dart format on
