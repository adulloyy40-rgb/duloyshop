import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProducts getProducts;
  
  int _currentPage = 1;
  static const int _limit = 10;
  String? _currentCategory;
  String? _currentSearchQuery;
  Map<String, dynamic>? _currentFilters;

  ProductListBloc({required this.getProducts}) : super(ProductListInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    _currentPage = 1;
    _currentCategory = event.category;
    _currentFilters = event.filters;

    final result = await getProducts(ProductParams(
      page: _currentPage,
      limit: _limit,
      category: _currentCategory,
      filters: _currentFilters,
    ));

    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) => emit(ProductListLoaded(
        products: products,
        hasReachedMax: products.length < _limit,
        currentPage: _currentPage,
      )),
    );
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (state is! ProductListLoaded) return;
    
    final currentState = state as ProductListLoaded;
    if (currentState.hasReachedMax) return;

    _currentPage++;

    final result = await getProducts(ProductParams(
      page: _currentPage,
      limit: _limit,
      category: _currentCategory,
      searchQuery: _currentSearchQuery,
      filters: _currentFilters,
    ));

    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) {
        if (products.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(ProductListLoaded(
            products: [...currentState.products, ...products],
            hasReachedMax: products.length < _limit,
            currentPage: _currentPage,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductListState> emit,
  ) async {
    add(LoadProducts(category: event.category, filters: _currentFilters));
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    _currentPage = 1;
    _currentSearchQuery = event.query;

    final result = await getProducts(ProductParams(
      page: _currentPage,
      limit: _limit,
      searchQuery: _currentSearchQuery,
    ));

    result.fold(
      (failure) => emit(ProductListError(failure.message)),
      (products) => emit(ProductListLoaded(
        products: products,
        hasReachedMax: products.length < _limit,
        currentPage: _currentPage,
      )),
    );
  }
}
