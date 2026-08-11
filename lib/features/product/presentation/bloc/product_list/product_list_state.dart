import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;

  const ProductListLoaded({
    required this.products,
    required this.hasReachedMax,
    required this.currentPage,
  });

  ProductListLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [products, hasReachedMax, currentPage];
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError(this.message);

  @override
  List<Object> get props => [message];
}
