import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../core/services/dio_handler.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? userData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchUser(String login) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final dio = GetIt.instance<DioHandler>().dio;
      
      final response = await dio.get('/v2/users/$login');

      userData = response.data;
      print("✅ Found User: ${userData!['displayname']}");
      
    } catch (e) {
      errorMessage = "User not found or API error";
      print("❌ Error fetching user: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}