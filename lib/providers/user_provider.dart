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

  /// Helper to find the Common Core (cursus_id: 21) level
  double getCoreLevel() {
    if (userData == null || userData!['cursus_users'] == null) return 0.0;
    
    final List<dynamic> cursusList = userData!['cursus_users'];
    
    // Search for cursus_id 21, which is the standard ID for 42cursus (Common Core)
    final coreCursus = cursusList.firstWhere(
      (c) => c['cursus_id'] == 21,
      orElse: () => cursusList.isNotEmpty ? cursusList.last : null,
    );

    if (coreCursus == null) return 0.0;
    
    return (coreCursus['level'] as num).toDouble();
  }

  /// NEW: Helper to get specific cursus data (Level, Grade, etc.)
  Map<String, dynamic>? getCursusData(int id) {
    if (userData == null || userData!['cursus_users'] == null) return null;
    final List<dynamic> cursus = userData!['cursus_users'];
    
    try {
      return cursus.firstWhere((c) => c['cursus_id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// NEW: Helper to filter projects belonging to a specific cursus
  List<dynamic> getProjectsByCursus(int cursusId) {
    if (userData == null || userData!['projects_users'] == null) return [];
    final List<dynamic> allProjects = userData!['projects_users'];
    
    // Filter projects that belong to the specific cursus ID
    return allProjects.where((p) {
      final List<dynamic> cursusIds = p['cursus_ids'] ?? [];
      return cursusIds.contains(cursusId);
    }).toList();
  }
}