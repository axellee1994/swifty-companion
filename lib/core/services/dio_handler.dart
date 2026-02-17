import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../providers/auth_provider.dart';

class DioHandler {
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioHandler._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.intra.42.fr',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        ) {
    
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        
        onError: (DioException e, handler) async {
          // BONUS: Check if token expired
          if (e.response?.statusCode == 401) {
            print("🚨 Token expired! Attempting to refresh...");
            
            try {
              final authProvider = GetIt.instance<AuthProvider>();
              await authProvider.authenticate();
              
              final newToken = await _storage.read(key: 'access_token');
              
              if (newToken != null) {
                e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                
                // Create a clean Dio instance to retry the request and resolve the original request
                final retryDio = Dio(BaseOptions(baseUrl: 'https://api.intra.42.fr'));
                final response = await retryDio.fetch(e.requestOptions);
                
                return handler.resolve(response);
              }
            } catch (retryError) {
              print("❌ Automatic refresh failed: $retryError");
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }

  static void setup() {
    GetIt.instance.registerLazySingleton(() => DioHandler._internal());
  }
}