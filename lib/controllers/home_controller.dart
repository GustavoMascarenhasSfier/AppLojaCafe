import 'package:get/get.dart';

import './../repository/repository.dart';
import './../models/models.dart';
import './category_controller.dart';

class HomeController extends GetxController {
  final BannerRepository bannerRepository;
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;

  HomeController({
    required this.bannerRepository,
    required this.categoryRepository,
    required this.productRepository,
  });

  final banners = <BannerModel>[].obs;
  final categories = <String>[].obs;
  final featuredProducts = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final productsApi = await productRepository.fetchProducts();
      featuredProducts.assignAll(productsApi);
      filteredProducts.assignAll(productsApi);

      final bannersGenerated = await bannerRepository.getBanners();
      banners.assignAll(bannersGenerated);

      // Agora, o CategoryController busca suas próprias categorias fixas.
      Get.find<CategoryController>().fetchCategories();
      categories.assignAll(Get.find<CategoryController>().categoryList);
    } catch (e) {
      errorMessage.value = 'Erro ao carregar a Home: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(featuredProducts);
    } else {
      filteredProducts.assignAll(featuredProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }
}
