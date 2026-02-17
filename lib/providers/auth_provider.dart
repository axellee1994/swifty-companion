import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/services/dio_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {

  final _storage = const FlutterSecureStorage();
  
  Future<void> authenticate() async {
    try {
      // Basic Dio instance used here to avoid the Auth Interceptor loop
      final dio = Dio(BaseOptions(baseUrl: 'https://api.intra.42.fr'));
      
      final response = await dio.post(
        '/oauth/token',
        data: {
          'grant_type': 'client_credentials',
          'client_id': dotenv.env['API_UID'],
          'client_secret': dotenv.env['API_SECRET'],
        },
      );

      final token = response.data['access_token'];
      await _storage.write(key: 'access_token', value: token);
      
      print("🔄 New Token Acquired"); 
    } catch (e) {
      print("❌ Critical Auth Failure: $e");
    }
  }
}