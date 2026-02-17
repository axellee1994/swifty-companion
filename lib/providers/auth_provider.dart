import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import '../core/services/dio_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {

  final _storage = const FlutterSecureStorage();
  
  Future<void> authenticate() async {
    try {
      final dio = GetIt.instance<DioHandler>().dio;
      
      final response = await dio.post(
          '/oauth/token',
          data: {
              'grant_type': 'client_credentials',
              'client_id': dotenv.env['API_UID'],
              'client_secret': dotenv.env['API_SECRET'],
          }
      );

      final token = response.data['access_token'];

      // Save the token
      await _storage.write(key: 'access_token', value: token);

      print("Token Response: ${response.data}"); 
      
    } catch (e) {
      print("Error logging in: $e");
    }
  }
}