import 'models.dart';

class ProductModel {
  final int id;
  final String title;
  final double price; // Simulado
  final String description;
  final String category; // Derivado do tipo de café (Hot/Iced)
  final String image;
  final RatingModel rating; // Simulado

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json,
      {String type = 'Coffee'}) {
    // Garante que o ID é um inteiro, convertendo de num se necessário.
    final int productId = (json['id'] as num).toInt();

    return ProductModel(
      id: productId,
      title: json['title'] ?? 'Café Desconhecido',
      price: 5.99 + (productId % 5), // Usando productId como int
      description: json['description'] ?? 'Delicioso café.',
      category: type,
      image: json['image'] ?? 'https://via.placeholder.com/150',
      rating: RatingModel(
          rate: 4.0 + (productId % 10) * 0.1, // Usando productId como int
          count: 50 +
              (productId %
                  50)), // Usando productId como int - Esta é a linha 38
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toJson()
    };
  }
}
