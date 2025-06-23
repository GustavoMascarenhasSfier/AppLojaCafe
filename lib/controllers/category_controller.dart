import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../repository/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository categoryRepository;

  CategoryController({required this.categoryRepository});

  final RxList<String> categoryList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await categoryRepository.fetchCategories();
      categoryList.assignAll(categories);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar categorias: $e');
      }
    }
  }
}
