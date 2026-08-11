import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    required int page,
    required int limit,
    String? category,
    String? searchQuery,
    Map<String, dynamic>? filters,
  });
  
  Future<Either<Failure, Product>> getProductDetail(String id);
  
  Future<Either<Failure, List<Product>>> searchProducts(
    String query, {
    required int page,
    required int limit,
  });
}
