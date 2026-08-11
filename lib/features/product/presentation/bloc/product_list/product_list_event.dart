import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductListEvent {
  final String? category;
  final Map<String, dynamic>? filters;

  const LoadProducts({this.category, this.filters});

  @override
  List<Object?> get props => [category, filters];
}

class LoadMoreProducts extends ProductListEvent {}

class RefreshProducts extends ProductListEvent {
  final String? category;

  const RefreshProducts({this.category});

  @override
  List<Object?> get props => [category];
}

class SearchProducts extends ProductListEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}
