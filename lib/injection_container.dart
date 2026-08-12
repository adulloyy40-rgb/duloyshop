import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';

import 'features/product/data/datasources/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';

import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';

import 'features/product/presentation/bloc/product_list/product_list_bloc.dart';
import 'features/product/presentation/bloc/product_detail/product_detail_bloc.dart';

import 'features/cart/presentation/bloc/cart/cart_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================================
  // EXTERNAL
  // ============================================================

  const secureStorage = FlutterSecureStorage();

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => secureStorage,
  );

  // ============================================================
  // NETWORK
  // ============================================================

  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      sl<FlutterSecureStorage>(),
    ),
  );

  sl.registerLazySingleton<Dio>(
    () => sl<DioClient>().dio,
  );

  // ============================================================
  // PRODUCT DATA SOURCE
  // ============================================================

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      sl<Dio>(),
    ),
  );

  // ============================================================
  // PRODUCT REPOSITORY
  // ============================================================

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
    ),
  );

  // ============================================================
  // PRODUCT USE CASE
  // ============================================================

  sl.registerLazySingleton<GetProducts>(
    () => GetProducts(
      sl<ProductRepository>(),
    ),
  );

  // ============================================================
  // PRODUCT LIST BLOC
  // ============================================================

  sl.registerFactory<ProductListBloc>(
    () => ProductListBloc(
      getProducts: sl<GetProducts>(),
    ),
  );

  // ============================================================
  // PRODUCT DETAIL BLOC
  // ============================================================

  sl.registerFactory<ProductDetailBloc>(
    () => ProductDetailBloc(
      productRepository: sl<ProductRepository>(),
    ),
  );

  // ============================================================
  // CART BLOC
  // ============================================================
  //
  // PENTING:
  // CartBloc menggunakan LAZY SINGLETON.
  //
  // Jangan gunakan registerFactory di sini.
  //
  // Dengan singleton:
  //
  // Product Detail
  //       ↓
  //     CartBloc
  //       ↓
  //   AddToCart
  //       ↓
  //    Cart Page
  //       ↓
  // CartBloc yang SAMA
  //

  sl.registerLazySingleton<CartBloc>(
    () => CartBloc(),
  );
}
