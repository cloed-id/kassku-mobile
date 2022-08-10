part of 'categories_bloc.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState(this.categories);

  final List<Category> categories;

  @override
  List<Object> get props => [categories];
}

class CategoriesInitial extends CategoriesState {
  CategoriesInitial() : super([]);
}

class CategoriesLoading extends CategoriesState {
  CategoriesLoading(CategoriesState state) : super(state.categories);
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded(super.categories);
}

class CategoriesError extends CategoriesState {
  CategoriesError(CategoriesState state, this.message)
      : super(state.categories);

  final String message;
}
