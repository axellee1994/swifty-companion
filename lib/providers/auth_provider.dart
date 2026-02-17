import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import '../core/services/dio_handler.dart';

Future<void> authenticate() async {
  try {
    // 1. Start DIO
    final dio = getIt<DioHandler>().dio; 
    
    // 2. Make the POST request
    final response = await dio.post(
        'https://api.intra.42.fr/oauth/token',
        data: {
            'grant_type' : 'client_credentials',
            'client_id': dotenv.env['API_UID'],
            'client_secret': dotenv.env['API_SECRET']
        }
    );

    // 3. Print the token to see if it worked
    print(response.data); 
    
  } catch (e) {
    print("Error: $e");
  }
}