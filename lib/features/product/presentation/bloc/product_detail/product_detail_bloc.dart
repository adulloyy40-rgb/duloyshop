import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/product_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository productRepository;

  ProductDetailBloc({
    required this.productRepository,
  }) : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    final result = await productRepository.getProductDetail(
      event.productId,
    );

    result.fold(
      (failure) {
        emit(
          ProductDetailError(failure.message),
        );
      },
      (product) {
        emit(
          ProductDetailLoaded(product),
        );
      },
    );
  }
}
