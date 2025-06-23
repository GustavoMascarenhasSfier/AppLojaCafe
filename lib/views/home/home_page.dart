import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import './../../widgets/widgets.dart';
import './../../views/views.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cartController = Get.find<CartController>();
  final controller = Get.find<HomeController>();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      controller.filterProducts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar produtos...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              BannerCarousel(banners: controller.banners),
              const SizedBox(height: 16),
              const Text(
                'Categorias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 35,
                child: Obx(() => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final categoria = controller.categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryTile(
                            category: categoria,
                            onTap: () {
                              Get.toNamed(
                                  '/category/${Uri.encodeComponent(categoria)}');
                            },
                          ),
                        );
                      },
                    )),
              ),
              const SizedBox(height: 16),
              const Text(
                'Produtos em destaque',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.filteredProducts.isEmpty &&
                    _searchController.text.isNotEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhum produto encontrado para a sua busca.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return ProductCard(
                      product: product,
                      cartAnimationMethod: (imageKey) {
                        cartController.itemSelectedCartAnimations(imageKey);
                      },
                      onTap: () {
                        Get.to(() => ProductDetailPage(product: product));
                      },
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
