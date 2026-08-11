import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../bloc/product_list/product_list_event.dart';
import '../bloc/product_list/product_list_state.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  final String? category;

  const ProductListPage({super.key, this.category});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductListBloc>().add(LoadMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductListBloc>()..add(LoadProducts(category: widget.category)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category ?? 'Semua Produk'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => context.push('/cart'),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProductListBloc>().add(
                                  LoadProducts(category: widget.category),
                                );
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onChanged: (value) {
                  if (value.length > 2) {
                    context.read<ProductListBloc>().add(SearchProducts(value));
                  }
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  if (state is ProductListInitial || state is ProductListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductListError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProductListBloc>().add(
                                    RefreshProducts(category: widget.category),
                                  );
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ProductListLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text('Tidak ada produk'));
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProductListBloc>().add(
                              RefreshProducts(category: widget.category),
                            );
                      },
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemCount: state.hasReachedMax
                            ? state.products.length
                            : state.products.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.products.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final product = state.products[index];
                          return ProductCard(product: product);
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
