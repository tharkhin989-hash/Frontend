/*import 'package:exe/model/get_category_data.dart';
import 'package:exe/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CategoryApi extends StatefulWidget {
  const CategoryApi({super.key});

  @override
  State<CategoryApi> createState() => _CategoryApiState();
}

class _CategoryApiState extends State<CategoryApi> {
  late final List<PlutoColumn> columns;
  List<PlutoRow> rows = [];

  bool isLoading = true;
  String? errorMessage;

  final Set<int> _deletedCategoryIds = {};
  final ApiService _apiService = ApiService();

  Object? get category => null;

  @override
  void initState() {
    super.initState();

    columns = [
      PlutoColumn(
        title: 'ID',
        field: 'category_id',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Description',
        field: 'description',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        width: 100,
        enableEditingMode: false,
        enableSorting: false,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          final row = rendererContext.row;

          final categoryId = int.parse(
            row.cells['category']!.value.toString(),
          );

          final categoryName =
              row.cells['name']!.value.toString();

          return IconButton(
            tooltip: 'Delete Category',
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            onPressed: _deletedCategoryIds.contains(category)
                ? null
                : () {
                    confirmDeleteCategory(
                      categoryId,
                      categoryName,
                    );
                  },
          );
        },
      ),
    ];

    loadCategories();
  }

  // Fetch categories from API
  Future<void> loadCategories() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final List<Category> categories =
          await _apiService.fetchCategories();

      final loadedRows = categories.map((category) {
        return PlutoRow(
          cells: {
            'category_id': PlutoCell(
              value: category.categoryId,
            ),
            'name': PlutoCell(
              value: category.name,
            ),
            'description': PlutoCell(
              value: category.description,
            ),
            'actions': PlutoCell(value: ''),
          },
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        rows = loadedRows;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // Confirm before deleting category
  Future<void> confirmDeleteCategory(
    int categoryId,
    String categoryName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text(
            'Are you sure you want to delete "$categoryName"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await deleteCategory(categoryId);
    }
  }

  // Delete category through API
  Future<void> deleteCategory(int category) async {
    if (_deletedCategoryIds.contains(category)) return;

    setState(() {
      _deletedCategoryIds.add(category);
    });

    try {
      await _apiService.deleteCategory(category);

      if (!mounted) return;

      setState(() {
        rows.removeWhere(
          (row) =>
              int.parse(
                row.cells['category_id']!.value.toString(),
              ) ==
              category,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _deletedCategoryIds.remove(category);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        actions: [
          IconButton(
            tooltip: 'Refresh Categories',
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : loadCategories,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(errorMessage!),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: loadCategories,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SizedBox.expand(
                    child: PlutoGrid(
                      columns: columns,
                      rows: rows,
                      configuration:
                          const PlutoGridConfiguration(),
                    ),
                  ),
      ),
    );
  }
}*/