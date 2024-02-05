import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
import 'package:trivioso/enums/quiz_status.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/providers/providers.dart';

// A button to go to the next question or finish the quiz
class AdvancingButton extends ConsumerWidget {
  final PageController pageController;
  final QuizState quizState;
  final List<Question> questions;
  const AdvancingButton({
    super.key,
    required this.pageController,
    required this.quizState,
    required this.questions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentPageNumber =
        pageController.hasClients && pageController.page != null
            ? pageController.page!.toInt()
            : 0;
    return GestureDetector(
      onTap: () {
        if (pageController.hasClients && quizState.answered) {
          ref
              .read(quizControllerProvider.notifier)
              .nextQuestion(questions, currentPageNumber);
          if (currentPageNumber + 1 < questions.length) {
            // control the page transition
            pageController.nextPage(
              // if duration is 0 then the page will not transition
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );

            ref.read(currentIndexProvider.notifier).state++;
          } else if (quizState.status == QuizStatus.complete) {
            ref.invalidate(currentIndexProvider);
          }
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: quizState.answered ? Colors.cyan.shade400 : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            ref.read(currentIndexProvider) + 1 < questions.length ? 'Next' : 'Finish',
            style: GoogleFonts.barlow(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
