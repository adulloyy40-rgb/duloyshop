import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int page,
    required int limit,
    String? category,
    String? searchQuery,
    Map<String, dynamic>? filters,
  });
  
  Future<ProductModel> getProductDetail(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    required int page,
    required int limit,
    String? category,
    String? searchQuery,
    Map<String, dynamic>? filters,
  }) async {
    final response = await dio.get(
      '/products',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (searchQuery != null) 'q': searchQuery,
        if (filters != null) ...filters,
      },
    );

    return (response.data['data'] as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  @override
  Future<ProductModel> getProductDetail(String id) async {
    final response = await dio.get('/products/$id');
    return ProductModel.fromJson(response.data['data']);
  }
}
