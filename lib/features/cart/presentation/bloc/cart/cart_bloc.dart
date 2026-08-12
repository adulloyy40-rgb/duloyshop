import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseCartQuantity>(_onIncreaseQuantity);
    on<DecreaseCartQuantity>(_onDecreaseQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) {
    final items = List<CartItem>.from(state.items);

    final existingIndex = items.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      final existingItem = items[existingIndex];

      items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      items.add(
        CartItem(
          product: event.product,
          quantity: 1,
        ),
      );
    }

    emit(
      state.copyWith(items: items),
    );
  }

  void _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) {
    final items = state.items
        .where(
          (item) => item.product.id != event.productId,
        )
        .toList();

    emit(
      state.copyWith(items: items),
    );
  }

  void _onIncreaseQuantity(
    IncreaseCartQuantity event,
    Emitter<CartState> emit,
  ) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index == -1) {
      return;
    }

    final item = items[index];

    if (item.quantity >= item.product.stock) {
      return;
    }

    items[index] = item.copyWith(
      quantity: item.quantity + 1,
    );

    emit(
      state.copyWith(items: items),
    );
  }

  void _onDecreaseQuantity(
    DecreaseCartQuantity event,
    Emitter<CartState> emit,
  ) {
    final items = List<CartItem>.from(state.items);

    final index = items.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index == -1) {
      return;
    }

    final item = items[index];

    if (item.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(
        quantity: item.quantity - 1,
      );
    }

    emit(
      state.copyWith(items: items),
    );
  }

  void _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) {
    emit(
      const CartState(),
    );
  }
}
