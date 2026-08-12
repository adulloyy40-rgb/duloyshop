import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';

// ============================================================
// PRODUCT
// ============================================================

import 'features/product/data/datasources/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';

import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';

import 'features/product/presentation/bloc/product_list/product_list_bloc.dart';
import 'features/product/presentation/bloc/product_detail/product_detail_bloc.dart';

// ============================================================
// CART
// ============================================================

import 'features/cart/presentation/bloc/cart/cart_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================================
  // External
  // ============================================================

  const secureStorage = FlutterSecureStorage();

  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => secureStorage,
    );
  }

  // ============================================================
  // Network
  // ============================================================

  if (!sl.isRegistered<DioClient>()) {
    sl.registerLazySingleton<DioClient>(
      () => DioClient(
        sl<FlutterSecureStorage>(),
      ),
    );
  }

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      () => sl<DioClient>().dio,
    );
  }

  // ============================================================
  // Product Data Source
  // ============================================================

  if (!sl.isRegistered<ProductRemoteDataSource>()) {
    sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(
        sl<Dio>(),
      ),
    );
  }

  // ============================================================
  // Product Repository
  // ============================================================

  if (!sl.isRegistered<ProductRepository>()) {
    sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(
        remoteDataSource: sl<ProductRemoteDataSource>(),
      ),
    );
  }

  // ============================================================
  // Product Use Cases
  // ============================================================

  if (!sl.isRegistered<GetProducts>()) {
    sl.registerLazySingleton<GetProducts>(
      () => GetProducts(
        sl<ProductRepository>(),
      ),
    );
  }

  // ============================================================
  // Product List BLoC
  // ============================================================

  if (!sl.isRegistered<ProductListBloc>()) {
    sl.registerFactory<ProductListBloc>(
      () => ProductListBloc(
        getProducts: sl<GetProducts>(),
      ),
    );
  }

  // ============================================================
  // Product Detail BLoC
  // ============================================================

  if (!sl.isRegistered<ProductDetailBloc>()) {
    sl.registerFactory<ProductDetailBloc>(
      () => ProductDetailBloc(
        productRepository: sl<ProductRepository>(),
      ),
    );
  }

  // ============================================================
  // CART BLoC
  // ============================================================
  //
  // Menggunakan LazySingleton supaya satu CartBloc
  // digunakan bersama oleh halaman Detail Produk dan
  // halaman Keranjang.
  //
  // JANGAN menggunakan registerFactory di sini.
  //

  if (!sl.isRegistered<CartBloc>()) {
    sl.registerLazySingleton<CartBloc>(
      () => CartBloc(),
    );
  }
}
