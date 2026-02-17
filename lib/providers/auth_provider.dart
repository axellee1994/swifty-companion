import 'package:dio/dio.dart';

Future<void> authenticate() async {
  try {
    final dio = getIt<DioHandler>().dio; 
    
    // 2. Make the POST request
    final response = await dio.post(
        'https://api.intra.42.fr/oauth/token',
        data: {
            'grant_type' : 'client_credientials',
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