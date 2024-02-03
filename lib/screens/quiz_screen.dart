import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:trivioso/enums/quiz_status.dart';
import 'package:trivioso/models/failure_model.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/providers/providers.dart';
import 'package:trivioso/widgets/buttons/advancing_button.dart';
import 'package:trivioso/widgets/buttons/quit_button.dart';
import 'package:trivioso/widgets/quiz_error.dart';
import 'package:trivioso/widgets/quiz_questions.dart';
import 'package:trivioso/widgets/quiz_results.dart';
import 'package:tuple/tuple.dart';

class QuizScreen extends HookConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberOfQuestions = ref.watch(numberOfQuestionsProvider);
    final categoryId = ref.watch(categoryIdProvider);
    final difficulty = ref.watch(selectedDifficultyProvider);
    final quizQuestions = ref.watch(
      quizQuestionProvider(
        Tuple3(numberOfQuestions, categoryId, difficulty!),
      ),
    );
    final quizState = ref.watch(quizControllerProvider);
    final pageController = usePageController(); // provided by flutter_hooks
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 100],
          colors: [
            Color.fromARGB(255, 21, 23, 24),
            Color.fromARGB(255, 38, 39, 41),
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
                  data: (questions) {
                    return _buildBody(
                      context,
                      ref,
                      questions,
                      pageController,
                    );
                  },
                  loading: () => const Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: LoadingIndicator(
                        strokeWidth: 2,
                        indicatorType: Indicator.ballSpinFadeLoader,
                        colors: [
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                  error: (err, stack) => QuizError(
                    message:
                        err is Failure ? err.message : 'Something went wrong!',
                  ),
                ),
              ),
              // if the quiz is finished, don't show the advancing or quit buttons
              quizState.status == QuizStatus.complete
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: quizQuestions.maybeWhen(
                        data: (questions) {
                          return Row(
                            children: [
                              const Expanded(
                                child: QuitButton(),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AdvancingButton(
                                  pageController: pageController,
                                  quizState: quizState,
                                  questions: questions,
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

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    List<Question> questions,
    PageController pageController,
  ) {
    if (questions.isEmpty) {
      return const QuizError(message: 'No Questions found');
    }

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
}
