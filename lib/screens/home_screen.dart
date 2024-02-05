import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:trivioso/models/failure_model.dart';
import 'package:trivioso/providers/providers.dart';
import 'package:trivioso/widgets/buttons/start_quiz_button.dart';
import 'package:trivioso/widgets/dropdowns/category_dropdown.dart';
import 'package:trivioso/widgets/dropdowns/difficulty_dropdown.dart';
import 'package:trivioso/widgets/questions_number_input.dart';
import 'package:trivioso/widgets/quiz_error.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(quizCategoryProvider);

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
          body: categories.when(
            data: (categories) {
              // when the categories are retrieved from the API, build the rest of the UI
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Trivioso',
                            style: GoogleFonts.pirataOne(
                              fontSize: 60,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '- A Quiz Game -',
                            style: GoogleFonts.barlow(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 20),
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Choose a category',
                                style: GoogleFonts.barlow(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CategoryDropdownWidget(categories: categories),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Choose a difficulty level',
                                style: GoogleFonts.barlow(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const DifficultyDropdownWidget(),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Choose number of questions',
                                style: GoogleFonts.barlow(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const QuestionNumberInput(),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 50),
                      const StartQuizButton(),
                    ],
                  ),
                ),
              );
            },
            // custom loading indicator using the loading_indicator package
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
              message: err is Failure ? err.message : 'Something went wrong!',
            ),
          ),
        ),
      ),
    );
  }
}
