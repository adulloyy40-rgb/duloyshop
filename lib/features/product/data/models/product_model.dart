import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.discountPrice,
    required super.images,
    required super.category,
    required super.rating,
    required super.reviewCount,
    required super.stock,
    required super.variants,
    super.isWishlisted,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      stock: json['stock'] ?? 0,
      variants: List<String>.from(json['variants'] ?? []),
      isWishlisted: json['is_wishlisted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'images': images,
      'category': category,
      'rating': rating,
      'review_count': reviewCount,
      'stock': stock,
      'variants': variants,
      'is_wishlisted': isWishlisted,
    };
  }
}
