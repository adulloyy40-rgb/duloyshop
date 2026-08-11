import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'features/product/data/datasources/product_remote_datasource.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/presentation/bloc/product_list/product_list_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  const secureStorage = FlutterSecureStorage();

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => secureStorage,
  );

  sl.registerLazySingleton(
    () => DioClient(sl<FlutterSecureStorage>()).dio,
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetProducts>(
    () => GetProducts(sl()),
  );

  // Blocs
  sl.registerFactory<ProductListBloc>(
    () => ProductListBloc(
      getProducts: sl(),
    ),
  );
}
