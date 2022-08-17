// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/categories_bloc.dart';
import 'package:kassku_mobile/utils/extensions/string_extension.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({
    super.key,
    required this.workspaceId,
  });

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoriesBloc(workspaceId)..add(const FetchCategories(key: '')),
      child: const _CategoryList(),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesState = context.watch<CategoriesBloc>().state;
    if (categoriesState is CategoriesError) {
      return Center(
        child: Text(categoriesState.message),
      );
    }
    if (categoriesState is CategoriesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (categoriesState is CategoriesLoaded) {
      return Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: categoriesState.categories.length + 1,
          itemBuilder: (context, index) {
            if (index == categoriesState.categories.length) {
              return const SizedBox(height: 24);
            }

            final category = categoriesState.categories[index];
            return ListTile(
              title: Text(category.textContent.originalText.capitalize),
              trailing: Text(
                '${category.usedCount} transaksi',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                final categoryBloc = BlocProvider.of<CategoriesBloc>(context);
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'Hapus kategori',
                    ),
                    content: RichText(
                      text: TextSpan(
                        text: 'Apakah anda yakin menghapus kategori',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text:
                                ' ${category.textContent.originalText.capitalize}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: '?',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          categoryBloc.add(DeleteCategory(category: category));
                        },
                        child: const Text('Ya'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Tidak'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    }
    return Container();
  }
}
