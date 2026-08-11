import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> variants;
  final bool isWishlisted;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.variants,
    this.isWishlisted = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    List<String>? images,
    String? category,
    double? rating,
    int? reviewCount,
    int? stock,
    List<String>? variants,
    bool? isWishlisted,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      images: images ?? this.images,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      variants: variants ?? this.variants,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  @override
  List<Object?> get props => [
        id, name, description, price, discountPrice, 
        images, category, rating, reviewCount, stock, variants, isWishlisted
      ];
}
