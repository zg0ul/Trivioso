import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_controller.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
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
    final quizState = ref.watch(quizControllerProvider);
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: quizQuestions.when(
                  data: (questions) => _buildBody(
                    context,
                    ref,
                    questions,
                    pageController,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => QuizError(
                    message:
                        err is Failure ? err.message : 'Something went wrong!',
                  ),
                ),
              ),
              quizState.status == QuizStatus.complete
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: quizQuestions.maybeWhen(
                        data: (questions) {
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: SizedBox(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.power_settings_new,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Quit Quiz',
                                          style: GoogleFonts.barlow(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: advancingButton(
                                  pageController,
                                  quizState,
                                  ref,
                                  questions,
                                  context,
                                ),
                              ),
                            ],
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector advancingButton(
    PageController pageController,
    QuizState quizState,
    WidgetRef ref,
    List<Question> questions,
    BuildContext context,
  ) {
    final int currentPageNumber =
        pageController.hasClients ? pageController.page!.toInt() : 0;

    return GestureDetector(
      onTap: () {
        if (pageController.hasClients && quizState.answered) {
          ref
              .read(quizControllerProvider.notifier)
              .nextQuestion(questions, currentPageNumber);
          if (currentPageNumber + 1 < questions.length) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.linear,
            );
          }
        }
      },
      child: Container(
        height: 50,
        // width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          color: quizState.answered ? Colors.cyan.shade400 : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            currentPageNumber + 1 < questions.length ? 'Next' : 'Finish',
            style: GoogleFonts.barlow(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
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

  // returns the state by default
  final quizState = ref.watch(quizControllerProvider);
  return quizState.status == QuizStatus.complete
      ? QuizResults(state: quizState, questions: questions)
      : QuizQuestions(
          questions: questions,
          pageController: pageController,
          state: quizState,
        );
}
