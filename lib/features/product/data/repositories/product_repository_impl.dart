import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    required int page,
    required int limit,
    String? category,
    String? searchQuery,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final result = await remoteDataSource.getProducts(
        page: page,
        limit: limit,
        category: category,
        searchQuery: searchQuery,
        filters: filters,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetail(String id) async {
    try {
      final result = await remoteDataSource.getProductDetail(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(
    String query, {
    required int page,
    required int limit,
  }) async {
    return await getProducts(
      page: page,
      limit: limit,
      searchQuery: query,
    );
  }
}
