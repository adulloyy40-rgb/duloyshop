import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_config.dart';

class DioClient {
  final FlutterSecureStorage _secureStorage;

  late final Dio _dio;

  DioClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.defaultServerUrl}/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ambil server yang tersimpan.
          final apiBaseUrl =
              await AppConfig.getApiBaseUrl();

          options.baseUrl = apiBaseUrl;

          // Ambil access token.
          final token =
              await _secureStorage.read(
            key: 'access_token',
          );

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] =
                'Bearer $token';
          }

          handler.next(options);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken =
                await _secureStorage.read(
              key: 'refresh_token',
            );

            if (refreshToken != null &&
                refreshToken.isNotEmpty) {
              try {
                final response =
                    await _dio.post(
                  '/auth/refresh',
                  data: {
                    'refresh_token': refreshToken,
                  },
                );

                final newToken =
                    response.data['access_token']
                        ?.toString();

                if (newToken != null &&
                    newToken.isNotEmpty) {
                  await _secureStorage.write(
                    key: 'access_token',
                    value: newToken,
                  );

                  final requestOptions =
                      error.requestOptions;

                  requestOptions.headers[
                          'Authorization'] =
                      'Bearer $newToken';

                  final retryResponse =
                      await _dio.fetch(
                    requestOptions,
                  );

                  return handler.resolve(
                    retryResponse,
                  );
                }
              } catch (_) {
                await _secureStorage.delete(
                  key: 'access_token',
                );

                await _secureStorage.delete(
                  key: 'refresh_token',
                );
              }
            }
          }

          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Dio get dio => _dio;
}
