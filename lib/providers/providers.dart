import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_controller.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
import 'package:trivioso/enums/difficulty.dart';
import 'package:trivioso/models/category_model.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/repositories/quiz/category_repository.dart';
import 'package:trivioso/repositories/quiz/quiz_repository.dart';
import 'package:trivioso/router.dart';
import 'package:tuple/tuple.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => QuizRepository(ref));

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref);
});

final quizControllerProvider =
    StateNotifierProvider.autoDispose<QuizController, QuizState>(
  (ref) => QuizController(),
);

final quizQuestionProvider = FutureProvider.autoDispose
    .family<List<Question>, Tuple3<int, int, Difficulty>>((ref, params) async {
  final numberOfQuestions = params.item1;
  final categoryId = params.item2;
  final difficulty = params.item3;

  return ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: numberOfQuestions,
        categoryId: categoryId,
        difficulty: difficulty,
      );
});

final quizCategoryProvider = FutureProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

final quizTabStatusProvider =
    StateProvider.family<List<bool?>, int>((ref, numberOfQuestions) {
  return List.generate(numberOfQuestions, (index) => null);
});

final numberOfQuestionsProvider = StateProvider<int>((ref) => 10);
final currentIndexProvider = StateProvider<int>((ref) => 0);
final categoryIdProvider = StateProvider<int>((ref) => 9);
final selectedCategoryProvider = StateProvider<Category?>((ref) => null);
final selectedDifficultyProvider = StateProvider<Difficulty?>((ref) => null);
final categoryControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});
final difficultyControllerProvider =
    StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

final shouldShowCategorySelectionErrorProvider = StateProvider<bool>((ref) {
  return false;
});
final shouldShowDifficultySelectionErrorProvider = StateProvider<bool>((ref) {
  return false;
});

// router provider
final routerProvider = Provider<GoRouter>((ref) => router);

final questionNumberControllerProvider =
    StateProvider<TextEditingController>((ref) {
  return TextEditingController(
    text: ref.watch(numberOfQuestionsProvider).toString(),
  );
});
