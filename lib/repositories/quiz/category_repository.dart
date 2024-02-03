import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/models/category_model.dart';
import 'package:trivioso/models/failure_model.dart';
import 'package:trivioso/providers/providers.dart';
import 'package:trivioso/repositories/quiz/base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final Ref _ref;

  CategoryRepository(this._ref);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _ref.read(dioProvider).get(
            'https://opentdb.com/api_category.php',
          );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results =
            List<Map<String, dynamic>>.from(data['trivia_categories'] ?? []);
        if (results.isNotEmpty) {
          return results.map((e) => Category.fromMap(e)).toList();
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
