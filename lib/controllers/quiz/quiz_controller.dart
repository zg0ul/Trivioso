import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
import 'package:trivioso/enums/quiz_status.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/providers/providers.dart';

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState.initial());
  void submitAnswer(
    Question currentQuestion,
    String answer,
    int currentIndex,
    WidgetRef ref,
  ) {
    if (state.answered) return;
    if (currentQuestion.correctAnswer == answer) {
      ref.read(quizTabStatusProvider.notifier).state[currentIndex] = true;
      state = state.copyWith(
        selectedAnswer: answer,
        correct: [...state.correct, currentQuestion],
        status: QuizStatus.correct,
      );
    } else {
      ref.read(quizTabStatusProvider.notifier).state[currentIndex] = false;
      state = state.copyWith(
        selectedAnswer: answer,
        incorrect: [...state.incorrect, currentQuestion],
        status: QuizStatus.incorrect,
      );
    }
  }

  void nextQuestion(List<Question> questions, int currentIndex) {
    state = state.copyWith(
      selectedAnswer: '',
      status: currentIndex + 1 < questions.length
          ? QuizStatus.initial
          : QuizStatus.complete,
    );
  }

  void reset() {
    state = QuizState.initial();
  }
}
