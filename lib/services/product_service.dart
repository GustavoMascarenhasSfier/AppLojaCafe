import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../common/common.dart';
import 'package:get/get.dart'; // Necessário para firstWhereOrNull

class ProductService {
  Future<List<ProductModel>> fetchProducts() async {
    final hotCoffeeResponse =
        await http.get(Uri.parse('${Common.baseUrl}/coffee/hot'));
    final icedCoffeeResponse =
        await http.get(Uri.parse('${Common.baseUrl}/coffee/iced'));

    List<ProductModel> allProducts = [];

    if (hotCoffeeResponse.statusCode == 200) {
      final List<dynamic> hotData = json.decode(hotCoffeeResponse.body);
      allProducts.addAll(hotData
          .map((json) => ProductModel.fromJson(json, type: 'Hot Coffee'))
          .toList());
    } else {
      throw Exception(
          'Erro ao carregar cafés quentes: ${hotCoffeeResponse.statusCode}');
    }

    if (icedCoffeeResponse.statusCode == 200) {
      final List<dynamic> icedData = json.decode(icedCoffeeResponse.body);
      allProducts.addAll(icedData
          .map((json) => ProductModel.fromJson(json, type: 'Iced Coffee'))
          .toList());
    } else {
      throw Exception(
          'Erro ao carregar cafés gelados: ${icedCoffeeResponse.statusCode}');
    }

    return allProducts;
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    String endpoint;
    String type;

    if (category.toLowerCase() == 'hot coffee') {
      endpoint = '/coffee/hot';
      type = 'Hot Coffee';
    } else if (category.toLowerCase() == 'iced coffee') {
      endpoint = '/coffee/iced';
      type = 'Iced Coffee';
    } else {
      // Se a categoria for genérica 'Coffee' ou desconhecida, busca todos.
      return fetchProducts();
    }

    final response = await http.get(Uri.parse('${Common.baseUrl}$endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => ProductModel.fromJson(json, type: type))
          .toList();
    } else {
      throw Exception(
          'Erro ao carregar produtos por categoria "$category": ${response.statusCode}');
    }
  }

  Future<ProductModel> fetchProductById(int id) async {
    // Para buscar por ID, precisamos buscar em ambas as categorias e encontrar.
    // É menos eficiente, mas a API não tem um endpoint específico por ID.
    final allProducts = await fetchProducts();
    final product = allProducts.firstWhereOrNull((p) => p.id == id);

    if (product != null) {
      return product;
    } else {
      throw Exception('Produto com id $id não encontrado.');
    }
  }
}
