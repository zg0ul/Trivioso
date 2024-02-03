
import 'package:trivioso/models/category_model.dart';

abstract class BaseCategoryRepository {
  Future<List<Category>> getCategories(
  );
}
