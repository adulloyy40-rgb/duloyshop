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
    final imageUrl = json['image_url']?.toString();

    final images = <String>[];

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl != 'null') {
      images.add(imageUrl);
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice:
          (json['discount_price'] as num?)?.toDouble(),
      images: images,
      category: json['category_name']?.toString() ??
          json['category']?.toString() ??
          '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount:
          (json['review_count'] as num?)?.toInt() ?? 0,
      stock:
          (json['stock'] as num?)?.toInt() ?? 0,
      variants: json['variants'] is List
          ? List<String>.from(
              (json['variants'] as List).map(
                (item) => item.toString(),
              ),
            )
          : <String>[],
      isWishlisted:
          json['is_wishlisted'] == true,
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
