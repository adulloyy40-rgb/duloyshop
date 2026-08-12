import 'package:equatable/equatable.dart';

import '../../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({
    this.items = const [],
  });

  // ============================================================
  // TOTAL ITEM
  // ============================================================

  int get totalItems {
    return items.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  // ============================================================
  // TOTAL HARGA
  // ============================================================

  double get totalPrice {
    return items.fold(
      0.0,
      (total, item) => total + item.subtotal,
    );
  }

  // ============================================================
  // COPY STATE
  // ============================================================

  CartState copyWith({
    List<CartItem>? items,
  }) {
    return CartState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}
