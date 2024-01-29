import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_controller.dart';
import 'package:trivioso/enums/difficulty.dart';
import 'package:trivioso/enums/quiz_status.dart';
import 'package:trivioso/models/failure_model.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/repositories/quiz/quiz_repository.dart';
import 'package:trivioso/widgets/quiz_error.dart';
import 'package:trivioso/widgets/quiz_questions.dart';
import 'package:trivioso/widgets/quiz_results.dart';

final quizQuestionProvider = FutureProvider.autoDispose<List<Question>>(
  (ref) => ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: 5,
        categoryId: Random().nextInt(24) + 9,
        difficulty: Difficulty.easy,
      ),
);

class QuizScreen extends HookConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizQuestions = ref.watch(quizQuestionProvider);
    final pageController = usePageController(); // provided by flutter_hooks
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 100],
          colors: [
            Color.fromARGB(255, 17, 21, 40),
            Color.fromARGB(255, 22, 25, 49),
            // Color(0xFF2C5364),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: quizQuestions.when(
          data: (questions) => _buildBody(
            context,
            ref,
            questions,
            pageController,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => QuizError(
            message: err is Failure ? err.message : 'Something went wrong!',
          ),
        ),
        bottomSheet: quizQuestions.maybeWhen(
          data: (questions) {
            final quizState = ref.watch(quizControllerProvider);
            if (!quizState.answered) return const SizedBox.shrink();
            return ElevatedButton(
              onPressed: () {
                ref
                    .read(quizControllerProvider.notifier)
                    .nextQuestion(questions, pageController.page!.toInt());
                if (pageController.page!.toInt() + 1 < questions.length) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.linear,
                  );
                }
              },
              child: Text(
                pageController.page!.toInt() + 1 < questions.length
                    ? 'Next'
                    : 'Finish',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

Widget _buildBody(
  BuildContext context,
  WidgetRef ref,
  List<Question> questions,
  PageController pageController,
) {
  if (questions.isEmpty) return const QuizError(message: 'No Questions found');

  final quizState =
      ref.watch(quizControllerProvider); // returns the state by default
  return quizState.status == QuizStatus.complete
      ? QuizResults(state: quizState, questions: questions)
      : QuizQuestions(
          questions: questions,
          pageController: pageController,
          state: quizState,
        );
}
