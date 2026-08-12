import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';

import '../../../cart/presentation/bloc/cart/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart/cart_event.dart';

import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_detail/product_detail_event.dart';
import '../bloc/product_detail/product_detail_state.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  String _formatPrice(double price) {
    final value = price.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(value[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductDetailBloc>()
        ..add(
          LoadProductDetail(productId),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
          centerTitle: true,
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            // ==================================================
            // LOADING
            // ==================================================

            if (state is ProductDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

            if (state is ProductDetailError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 56.sp,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Gagal Memuat Produk',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<ProductDetailBloc>()
                              .add(
                                LoadProductDetail(productId),
                              );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ==================================================
            // PRODUCT LOADED
            // ==================================================

            if (state is ProductDetailLoaded) {
              final product = state.product;

              final imageUrl = product.images.isNotEmpty
                  ? product.images.first
                  : '';

              final hasDiscount =
                  product.discountPrice != null &&
                  product.discountPrice! < product.price;

              final displayPrice =
                  product.discountPrice ?? product.price;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // GAMBAR PRODUK
                    // ==================================================

                    AspectRatio(
                      aspectRatio: 1,
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (
                                context,
                                url,
                              ) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child:
                                        CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorWidget: (
                                context,
                                url,
                                error,
                              ) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons
                                        .image_not_supported_outlined,
                                    size: 64.sp,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons
                                    .image_not_supported_outlined,
                                size: 64.sp,
                                color: Colors.grey,
                              ),
                            ),
                    ),

                    // ==================================================
                    // INFORMASI PRODUK
                    // ==================================================

                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          // ==================================================
                          // KATEGORI
                          // ==================================================

                          if (product.category.isNotEmpty)
                            Text(
                              product.category,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                          SizedBox(height: 6.h),

                          // ==================================================
                          // NAMA PRODUK
                          // ==================================================

                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10.h),

                          // ==================================================
                          // RATING
                          // ==================================================

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                product.rating
                                    .toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(${product.reviewCount} ulasan)',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // ==================================================
                          // HARGA
                          // ==================================================

                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  _formatPrice(displayPrice),
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              if (hasDiscount) ...[
                                SizedBox(width: 10.w),
                                Text(
                                  _formatPrice(product.price),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey,
                                    decoration:
                                        TextDecoration
                                            .lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // ==================================================
                          // STOK
                          // ==================================================

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Stok tersedia: ${product.stock}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // ==================================================
                          // DESKRIPSI
                          // ==================================================

                          Text(
                            'Deskripsi Produk',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Text(
                            product.description.isNotEmpty
                                ? product.description
                                : 'Tidak ada deskripsi produk.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: Colors.grey[700],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // ==================================================
                          // VARIAN
                          // ==================================================

                          if (product.variants.isNotEmpty) ...[
                            Text(
                              'Varian Produk',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children:
                                  product.variants.map(
                                (variant) {
                                  return Chip(
                                    label: Text(variant),
                                  );
                                },
                              ).toList(),
                            ),
                            SizedBox(height: 24.h),
                          ],

                          // ==================================================
                          // TAMBAH KE KERANJANG
                          // ==================================================

                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton.icon(
                              onPressed: product.stock > 0
                                  ? () {
                                      // Masukkan produk ke CartBloc.
                                      sl<CartBloc>().add(
                                        AddToCart(product),
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${product.name} ditambahkan ke keranjang.',
                                          ),
                                          behavior:
                                              SnackBarBehavior
                                                  .floating,
                                        ),
                                      );
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                              ),
                              label: Text(
                                product.stock > 0
                                    ? 'Tambah ke Keranjang'
                                    : 'Stok Habis',
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // ==================================================
            // INITIAL / FALLBACK
            // ==================================================

            return const Center(
              child: Text(
                'Memuat detail produk...',
              ),
            );
          },
        ),
      ),
    );
  }
}
