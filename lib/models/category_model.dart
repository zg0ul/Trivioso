import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.categoryName,
    required this.categoryId,
  });

  final String categoryName;
  final int categoryId;

  String get name => categoryName;
  int get id => categoryId;

  @override
  List<Object?> get props => [
        categoryName,
        categoryId,
      ];

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryName: map['name'] ?? '',
      categoryId: map['id'] ?? 9,
    );
  }
}
