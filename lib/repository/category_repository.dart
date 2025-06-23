class CategoryRepository {
  CategoryRepository();

  Future<List<String>> fetchCategories() async {
    return Future.value(['Hot Coffee', 'Iced Coffee', 'Coffee']);
  }
}
