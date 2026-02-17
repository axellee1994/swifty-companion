import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'core/services/dio_handler.dart';
import 'core/constants/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'ui/screens/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");

  if (dotenv.env['API_UID'] == null || 
      dotenv.env['API_SECRET'] == null ||
      dotenv.env['API_UID']!.isEmpty || 
      dotenv.env['API_SECRET']!.isEmpty) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Fatal Error: .env file is missing or API keys are not configured correctly.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  final getIt = GetIt.instance; 
  getIt.registerLazySingleton(() => AuthProvider());
  
  // Initialize Dio singleton
  DioHandler.setup();

  final authProvider = getIt<AuthProvider>();

  // Attempt initial authentication
  try {
    await authProvider.authenticate();
  } catch (e) {
    debugPrint("Initial authentication failed: $e");
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swifty Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.fortyTwoTeal,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.fortyTwoTeal,
          secondary: AppColors.fortyTwoTeal,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.fortyTwoTeal,
            foregroundColor: Colors.white,
            minimumSize: const Size(88, 48),
          ),
        ),
      ),
      home: const SearchScreen(),
    );
  }
}