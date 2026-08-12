import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

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
    final hasDiscount =
        product.discountPrice != null &&
        product.discountPrice! < product.price;

    final imageUrl = product.images.isNotEmpty
        ? product.images.first
        : '';

    return GestureDetector(
      onTap: () {
        context.push(
          '/product/${product.id}',
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Hero(
                      tag:
                          'product_image_${product.id}',
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) {
                                return Container(
                                  color:
                                      Colors.grey.shade200,
                                  child:
                                      const Center(
                                    child:
                                        CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorWidget:
                                  (context, url, error) {
                                return _imagePlaceholder();
                              },
                            )
                          : _imagePlaceholder(),
                    ),
                  ),

                  if (hasDiscount)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(
                            4.r,
                          ),
                        ),
                        child: Text(
                          '-${((1 - product.discountPrice! / product.price) * 100).round()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor:
                            Colors.black54,
                        child: Icon(
                          product.isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              product.isWishlisted
                                  ? Colors.red
                                  : Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 13.sp,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          product.rating
                              .toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color:
                                Colors.grey[600],
                          ),
                        ),
                        Text(
                          ' (${product.reviewCount})',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color:
                                Colors.grey[500],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      'Stok: ${product.stock}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color:
                            product.stock > 0
                                ? Colors.grey[600]
                                : Colors.red,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatPrice(
                              product.discountPrice ??
                                  product.price,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Theme.of(context)
                                      .primaryColor,
                            ),
                          ),
                        ),

                        if (hasDiscount) ...[
                          SizedBox(width: 4.w),
                          Text(
                            _formatPrice(
                              product.price,
                            ),
                            style: TextStyle(
                              fontSize: 9.sp,
                              decoration:
                                  TextDecoration
                                      .lineThrough,
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48.sp,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}
