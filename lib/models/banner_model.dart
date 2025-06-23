import './../models/models.dart';

class BannerModel {
  final int id;
  final String title;
  final double price;
  final String imageUrl;

  BannerModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  factory BannerModel.fromProduct(ProductModel product) {
    return BannerModel(
      id: product.id,
      title: product.title,
      price: product.price,
      imageUrl: product.image,
    );
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    // Este fromJson é mais para compatibilidade, o BannerService vai usar fromProduct.
    return BannerModel(
      id: json['id'],
      title: json['title'] ?? 'Banner Item',
      price: (json['price'] as num?)?.toDouble() ??
          0.0, // Preço simulado se o JSON não tiver
      imageUrl: json['image'] ??
          'https://via.placeholder.com/300', // Imagem padrão se o JSON não tiver
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
