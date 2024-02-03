import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/providers/providers.dart';
import 'package:trivioso/widgets/answer_card.dart';

class QuizQuestions extends ConsumerWidget {
  final PageController pageController;
  final QuizState state;
  final List<Question> questions;
  const QuizQuestions(
      {super.key,
      required this.pageController,
      required this.state,
      required this.questions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberOfQuestions = ref.read(numberOfQuestionsProvider);
    final quizTabStatus = ref.watch(quizTabStatusProvider(numberOfQuestions));
    final currentIndex = ref.watch(currentIndexProvider);

    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        final question = questions[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: Text(
                '${question.category} Quiz',
                style: GoogleFonts.barlow(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Question ',
                      style: GoogleFonts.barlow(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '${index + 1}',
                      style: GoogleFonts.barlow(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '/${questions.length}',
                      style: GoogleFonts.barlow(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: quizTabStatus.asMap().entries.map((entry) {
                    final index = entry.key;
                    final isAnswered = entry.value != null;
                    final isCorrect = entry.value == true;

                    Color color;
                    if (isAnswered) {
                      color = isCorrect ? Colors.green : Colors.red;
                    } else {
                      color =
                          index == currentIndex ? Colors.white : Colors.grey;
                    }

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 20,
                        height: 3,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    );
                  }).toList()
                  // children: List.generate(
                  //   quizTabStatus.length,
                  //   (index) => Expanded(
                  //     child: Container(
                  //       margin: const EdgeInsets.all(5),
                  //       width: 20,
                  //       height: 3,
                  //       decoration: BoxDecoration(
                  //         color: currentIndex == index
                  //             ? Colors.white
                  //             : ref
                  //                         .watch(quizTabStatusProvider.notifier)
                  //                         .state[index] ==
                  //                     true
                  //                 ? Colors.green
                  //                 : ref
                  //                             .watch(
                  //                                 quizTabStatusProvider.notifier)
                  //                             .state[index] ==
                  //                         false
                  //                     ? Colors.red
                  //                     : Colors.grey,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Text(
                HtmlCharacterEntities.decode(question.question),
                style: GoogleFonts.barlow(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Column(
              children: question.answers
                  .map(
                    (e) => AnswerCard(
                      answer: e,
                      isSelected: state.selectedAnswer == e,
                      isCorrect: e == question.correctAnswer,
                      isDisplayingAnswer: state.answered,
                      onTap: () {
                        ref
                            .read(quizControllerProvider.notifier)
                            .submitAnswer(question, e, currentIndex, ref);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
