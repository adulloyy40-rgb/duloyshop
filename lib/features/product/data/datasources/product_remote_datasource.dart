import 'package:dio/dio.dart';

import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
    Map<String, dynamic>? filters,
  });

  Future<ProductModel> getProductDetail(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? searchQuery,
    Map<String, dynamic>? filters,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (category != null) {
      queryParameters['category'] = category;
    }

    if (searchQuery != null) {
      queryParameters['q'] = searchQuery;
    }

    if (filters != null) {
      queryParameters.addAll(filters);
    }

    final response = await dio.get(
      '/products',
      queryParameters: queryParameters,
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
