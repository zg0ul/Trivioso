import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivioso/enums/difficulty.dart';
import 'package:trivioso/models/failure_model.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/providers/providers.dart';
import 'package:trivioso/repositories/quiz/base_quiz_repository.dart';


class QuizRepository extends BaseQuizRepository {
  final Ref _ref;

  QuizRepository(this._ref);

  @override
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  }) async {
    try {
      final queryParameters = {
        'amount': numQuestions,
        'category': categoryId,
        'type': 'multiple',
      };

      if (difficulty != Difficulty.any) {
        queryParameters.addAll(
          {'difficulty': EnumToString.convertToString(difficulty)},
        );
      }

      final response = await _ref.read(dioProvider).get(
        'https://opentdb.com/api.php',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        if (results.isNotEmpty) {
          return results.map((e) => Question.fromMap(e)).toList();
        }
      }
      return [];
    } on DioException catch (err) {
      print(err);
      throw Failure(
          message: err.response?.statusMessage ?? 'Something went wrong');
    } on SocketException catch (err) {
      print(err);
      throw const Failure(message: 'No internet connection');
    }
  }
}
