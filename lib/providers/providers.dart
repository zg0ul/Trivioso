import 'dart:math';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_controller.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
import 'package:trivioso/enums/difficulty.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/repositories/quiz/quiz_repository.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => QuizRepository(ref));

final quizControllerProvider =
    StateNotifierProvider.autoDispose<QuizController, QuizState>(
  (ref) => QuizController(),
);   

final quizQuestionProvider = FutureProvider.autoDispose<List<Question>>((ref) {
  final numberOfQuestions = ref.read(numberOfQuestionsProvider);

  return ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: numberOfQuestions,
        categoryId: 31,
        // categoryId: Random().nextInt(24) + 9,
        difficulty: Difficulty.hard,
      );
});

final quizTabStatusProvider = StateProvider<List<bool?>>((ref) {
  final numberOfQuestions = ref.read(numberOfQuestionsProvider);
  return List.generate(numberOfQuestions, (index) => null);
});

final numberOfQuestionsProvider = StateProvider<int>((ref) => 10);
final currentIndexProvider = StateProvider<int>((ref) => 0);
