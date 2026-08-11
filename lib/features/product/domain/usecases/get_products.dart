import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts implements UseCase<List<Product>, ProductParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(ProductParams params) async {
    return await repository.getProducts(
      page: params.page,
      limit: params.limit,
      category: params.category,
      searchQuery: params.searchQuery,
      filters: params.filters,
    );
  }
}

class ProductParams extends Equatable {
  final int page;
  final int limit;
  final String? category;
  final String? searchQuery;
  final Map<String, dynamic>? filters;

  const ProductParams({
    this.page = 1,
    this.limit = 10,
    this.category,
    this.searchQuery,
    this.filters,
  });

  @override
  List<Object?> get props => [page, limit, category, searchQuery, filters];
}
