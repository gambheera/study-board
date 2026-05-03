import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/database/database_provider.dart';
import 'package:studyboard_mobile/features/lesson/data/lesson_repository_impl.dart';
import 'package:studyboard_mobile/features/lesson/domain/lesson_repository.dart';

part 'lesson_provider.g.dart';

@riverpod
LessonRepository lessonRepository(Ref ref) =>
    LessonRepositoryImpl(ref.watch(appDatabaseProvider).lessonDao);
