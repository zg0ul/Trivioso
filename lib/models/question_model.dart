import 'package:equatable/equatable.dart';

class Question extends Equatable {
  const Question({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> answers;

  @override
  List<Object?> get props => [
        answers,
        correctAnswer,
        question,
        category,
        difficulty,
      ];

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
      question: map['question'] ?? '',
      correctAnswer: map['correct_answer'] ?? '',
      answers: List<String>.from(map['incorrect_answers'] ?? [])
        ..add(map['correct_answer'] ?? '')
        ..shuffle(),
    );
  }
}
