import 'package:equatable/equatable.dart';

import '../../../../product/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// TAMBAH PRODUK
// ============================================================

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

// ============================================================
// HAPUS PRODUK
// ============================================================

class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

// ============================================================
// TAMBAH QUANTITY
// ============================================================

class IncreaseCartQuantity extends CartEvent {
  final String productId;

  const IncreaseCartQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

// ============================================================
// KURANGI QUANTITY
// ============================================================

class DecreaseCartQuantity extends CartEvent {
  final String productId;

  const DecreaseCartQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

// ============================================================
// KOSONGKAN KERANJANG
// ============================================================

class ClearCart extends CartEvent {
  const ClearCart();
}
