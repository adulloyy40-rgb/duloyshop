import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';

import 'features/cart/presentation/bloc/cart/cart_bloc.dart';

import 'features/product/data/datasources/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';

import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';

import 'features/product/presentation/bloc/product_list/product_list_bloc.dart';
import 'features/product/presentation/bloc/product_detail/product_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================================
  // External
  // ============================================================

  const secureStorage = FlutterSecureStorage();

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => secureStorage,
  );

  // ============================================================
  // Network
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
  // Data Sources
  // ============================================================

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      sl<Dio>(),
    ),
  );

  // ============================================================
  // Repository
  // ============================================================

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
    ),
  );

  // ============================================================
  // Use Cases
  // ============================================================

  sl.registerLazySingleton<GetProducts>(
    () => GetProducts(
      sl<ProductRepository>(),
    ),
  );

  // ============================================================
  // Product List BLoC
  // ============================================================

  sl.registerFactory<ProductListBloc>(
    () => ProductListBloc(
      getProducts: sl<GetProducts>(),
    ),
  );

  // ============================================================
  // Product Detail BLoC
  // ============================================================

  sl.registerFactory<ProductDetailBloc>(
    () => ProductDetailBloc(
      productRepository: sl<ProductRepository>(),
    ),
  );

  // ============================================================
  // Cart BLoC
  // ============================================================

  sl.registerFactory<CartBloc>(
    () => CartBloc(),
  );
}
