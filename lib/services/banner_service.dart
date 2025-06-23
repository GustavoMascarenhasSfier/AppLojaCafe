import '../models/models.dart';
import 'product_service.dart'; // Necessário para usar fetchProducts

import 'dart:math';

class BannerService {
  final ProductService productService; // Adicionar ProductService

  BannerService(this.productService); // Construtor

  Future<List<BannerModel>> fetchBanners() async {
    try {
      // Usar o ProductService para buscar todos os produtos
      final List<ProductModel> products = await productService.fetchProducts();

      products.shuffle(Random());

      final selectedProducts = products.take(4).toList();

      final banners = selectedProducts.map((product) {
        return BannerModel.fromProduct(product);
      }).toList();

      return banners;
    } catch (e) {
      throw Exception('Erro ao carregar banners (via ProductService): $e');
    }
  }
}
