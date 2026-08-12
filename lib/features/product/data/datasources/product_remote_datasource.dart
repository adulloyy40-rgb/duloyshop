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

class ProductRemoteDataSourceImpl
    implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  String _getServerUrl(Response response) {
    final baseUrl =
        response.requestOptions.baseUrl;

    if (baseUrl.endsWith('/api')) {
      return baseUrl.substring(
        0,
        baseUrl.length - 4,
      );
    }

    if (baseUrl.endsWith('/api/')) {
      return baseUrl.substring(
        0,
        baseUrl.length - 5,
      );
    }

    return baseUrl.replaceAll(
      RegExp(r'/$'),
      '',
    );
  }

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

    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = category;
    }

    if (searchQuery != null &&
        searchQuery.isNotEmpty) {
      queryParameters['q'] = searchQuery;
    }

    if (filters != null && filters.isNotEmpty) {
      queryParameters.addAll(filters);
    }

    final response = await dio.get(
      '/products',
      queryParameters: queryParameters,
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw Exception(
        'Format response API tidak valid.',
      );
    }

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ??
            'Gagal mengambil data produk.',
      );
    }

    final data = responseData['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Data produk tidak valid.',
      );
    }

    final items = data['items'];

    if (items is! List) {
      throw Exception(
        'Daftar produk tidak valid.',
      );
    }

    final serverUrl =
        _getServerUrl(response);

    return items.map((json) {
      final productJson =
          Map<String, dynamic>.from(
        json as Map,
      );

      return ProductModel.fromJson(
        productJson,
        serverUrl: serverUrl,
      );
    }).toList();
  }

  @override
  Future<ProductModel> getProductDetail(
    String id,
  ) async {
    final response = await dio.get(
      '/products/$id',
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw Exception(
        'Format response API tidak valid.',
      );
    }

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ??
            'Gagal mengambil detail produk.',
      );
    }

    final data = responseData['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Data detail produk tidak valid.',
      );
    }

    final serverUrl =
        _getServerUrl(response);

    return ProductModel.fromJson(
      Map<String, dynamic>.from(data),
      serverUrl: serverUrl,
    );
  }
}
