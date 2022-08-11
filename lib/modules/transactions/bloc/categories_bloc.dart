import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kassku_mobile/models/category.dart';
import 'package:kassku_mobile/repositories/categories_repository.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this.workspaceId) : super(CategoriesInitial()) {
    on<FetchCategories>(_searchCategories);
    on<CreateCategory>(_createCategory);
    on<SelectCategory>(_selectCategory);
  }

  final _repo = CategoriesRepository();
  final String workspaceId;

  Future<void> _selectCategory(
    SelectCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading(state));
    final data = event.category;

    final categories = state.categories.map((category) {
      if (category.id == data.id) {
        return data;
      }
      final cat = category..isSelected = false;

      return cat;
    }).toList();

    emit(CategoriesLoaded(categories));
  }

  Future<void> _searchCategories(
    FetchCategories event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.getCategories(event.key, workspaceId),
      onError: (_) {
        emit(CategoriesError(state, 'Error loading categories'));
      },
    );

    final data = result.data as List<Category>;

    emit(CategoriesLoaded(data));
  }

  Future<void> _createCategory(
    CreateCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.createCategory(event.name, workspaceId),
      onError: (_) {
        emit(CategoriesLoaded(state.categories));
      },
    );

    final data = result.data as Category;

    emit(CategoriesLoaded([data, ...state.categories]));

    data.isSelected = true;
    add(SelectCategory(data));
  }
}
