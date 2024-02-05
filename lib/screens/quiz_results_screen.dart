import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/providers/providers.dart';
import 'package:trivioso/widgets/buttons/go_home_button.dart';
import 'package:trivioso/widgets/buttons/play_again_button.dart';

class QuizResultsScreen extends ConsumerWidget {
  final QuizState quizState;
  final List<Question> quizQuestions;
  const QuizResultsScreen({
    super.key,
    required this.quizState,
    required this.quizQuestions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizCategoryName = ref.read(selectedCategoryProvider)!.categoryName;
    final quizDifficulty = ref.read(selectedDifficultyProvider)!;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Quiz Completed",
            style: GoogleFonts.barlow(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Summary:",
                  style: GoogleFonts.barlow(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Correct answers: ',
                        style: GoogleFonts.barlow(
                          color: Colors.white70,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '${quizState.correct.length}',
                        style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' /${quizQuestions.length}',
                        style: GoogleFonts.barlow(
                          color: Colors.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Category: ',
                        style: GoogleFonts.barlow(
                          color: Colors.white70,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: quizCategoryName,
                        style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 24,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Difficulty: ',
                        style: GoogleFonts.barlow(
                          color: Colors.white70,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: quizDifficulty.name,
                        style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 24,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // const SizedBox(height: 40),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GoHomeButton(),
              PlayAgainButton(),
            ],
          ),
        ],
      ),
    );
  }
}
