import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../injection_container.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _formatPrice(double price) {
    final value = price.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 &&
          (value.length - i) % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(value[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CartBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang'),
          centerTitle: true,
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.items.isEmpty) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  tooltip: 'Kosongkan keranjang',
                  icon: const Icon(
                    Icons.delete_sweep_outlined,
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text(
                            'Kosongkan Keranjang?',
                          ),
                          content: const Text(
                            'Semua produk di keranjang akan dihapus.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  dialogContext,
                                );
                              },
                              child: const Text(
                                'Batal',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<CartBloc>()
                                    .add(
                                      const ClearCart(),
                                    );

                                Navigator.pop(
                                  dialogContext,
                                );
                              },
                              child: const Text(
                                'Kosongkan',
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            // ==================================================
            // KERANJANG KOSONG
            // ==================================================

            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding:
                      EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons
                            .shopping_cart_outlined,
                        size: 80.sp,
                        color:
                            Colors.grey,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Keranjang masih kosong',
                        style:
                            TextStyle(
                          fontSize:
                              20.sp,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'Tambahkan produk terlebih dahulu.',
                        textAlign:
                            TextAlign.center,
                        style:
                            TextStyle(
                          fontSize:
                              14.sp,
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ==================================================
            // ADA PRODUK
            // ==================================================

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding:
                        EdgeInsets.all(16.w),
                    itemCount:
                        state.items.length,
                    separatorBuilder:
                        (_, _) =>
                            SizedBox(
                      height: 12.h,
                    ),
                    itemBuilder:
                        (context, index) {
                      final item =
                          state.items[index];

                      final product =
                          item.product;

                      final imageUrl =
                          product.images
                                  .isNotEmpty
                              ? product
                                  .images
                                  .first
                              : '';

                      final price =
                          product
                                  .discountPrice ??
                              product.price;

                      return Container(
                        padding:
                            EdgeInsets.all(
                          12.w,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors
                              .grey
                              .shade900,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14.r,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            // IMAGE
                            ClipRRect(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                10.r,
                              ),
                              child: imageUrl
                                      .isNotEmpty
                                  ? Image
                                      .network(
                                      imageUrl,
                                      width:
                                          85.w,
                                      height:
                                          85.w,
                                      fit: BoxFit
                                          .cover,
                                      errorBuilder:
                                          (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return
                                            Container(
                                          width:
                                              85.w,
                                          height:
                                              85.w,
                                          color: Colors
                                              .grey
                                              .shade800,
                                          child:
                                              const Icon(
                                            Icons
                                                .image_not_supported_outlined,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width:
                                          85.w,
                                      height:
                                          85.w,
                                      color: Colors
                                          .grey
                                          .shade800,
                                      child:
                                          const Icon(
                                        Icons
                                            .image_not_supported_outlined,
                                      ),
                                    ),
                            ),

                            SizedBox(
                              width: 12.w,
                            ),

                            // INFO
                            Expanded(
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines:
                                        2,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        TextStyle(
                                      fontSize:
                                          16.sp,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                        6.h,
                                  ),

                                  Text(
                                    _formatPrice(
                                      price,
                                    ),
                                    style:
                                        TextStyle(
                                      fontSize:
                                          15.sp,
                                      color: Colors
                                          .blueAccent,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                        10.h,
                                  ),

                                  Row(
                                    children: [
                                      // MINUS

                                      IconButton(
                                        visualDensity:
                                            VisualDensity
                                                .compact,
                                        onPressed:
                                            () {
                                          context
                                              .read<
                                                  CartBloc>()
                                              .add(
                                                DecreaseCartQuantity(
                                                  product
                                                      .id,
                                                ),
                                              );
                                        },
                                        icon:
                                            const Icon(
                                          Icons
                                              .remove_circle_outline,
                                        ),
                                      ),

                                      Text(
                                        '${item.quantity}',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              15.sp,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      // PLUS

                                      IconButton(
                                        visualDensity:
                                            VisualDensity
                                                .compact,
                                        onPressed:
                                            item.quantity <
                                                    product.stock
                                                ? () {
                                                    context
                                                        .read<
                                                            CartBloc>()
                                                        .add(
                                                          IncreaseCartQuantity(
                                                            product.id,
                                                          ),
                                                        );
                                                  }
                                                : null,
                                        icon:
                                            const Icon(
                                          Icons
                                              .add_circle_outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // DELETE

                            IconButton(
                              onPressed: () {
                                context
                                    .read<
                                        CartBloc>()
                                    .add(
                                      RemoveFromCart(
                                        product.id,
                                      ),
                                    );
                              },
                              icon:
                                  const Icon(
                                Icons
                                    .delete_outline,
                                color:
                                    Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ==================================================
                // BOTTOM TOTAL
                // ==================================================

                SafeArea(
                  top: false,
                  child: Container(
                    padding:
                        EdgeInsets.all(
                      16.w,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .grey
                          .shade900,
                      borderRadius:
                          BorderRadius.only(
                        topLeft:
                            Radius.circular(
                          20.r,
                        ),
                        topRight:
                            Radius.circular(
                          20.r,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Text(
                              'Total ${state.totalItems} item',
                              style:
                                  TextStyle(
                                fontSize:
                                    14.sp,
                                color:
                                    Colors.grey,
                              ),
                            ),
                            Text(
                              _formatPrice(
                                state.totalPrice,
                              ),
                              style:
                                  TextStyle(
                                fontSize:
                                    21.sp,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 12.h,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          height: 52.h,
                          child:
                              ElevatedButton(
                            onPressed:
                                () {
                              ScaffoldMessenger
                                  .of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Checkout akan kita buat pada tahap berikutnya.',
                                  ),
                                ),
                              );
                            },
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  Colors
                     .blueAccent,
                              foregroundColor:
                                  Colors.white,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  14.r,
                                ),
                              ),
                            ),
                            child:
                                const Text(
                              'Lanjut Checkout',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
