part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
}

class SelectCategory extends CategoriesEvent {
  const SelectCategory(this.category);

  final Category category;

  @override
  List<Object?> get props => [category];
}

class FetchCategories extends CategoriesEvent {
  const FetchCategories({required this.key});

  final String key;

  @override
  List<Object> get props => [key];
}

class CreateCategory extends CategoriesEvent {
  const CreateCategory({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}
