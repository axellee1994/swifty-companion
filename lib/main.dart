import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/services/dio_handler.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'ui/screens/search_screen.dart'; // Import your new file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  DioHandler.setup();

  final authProvider = AuthProvider();
  await authProvider.authenticate();
  
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
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00BABC),
      ),
      home: const SearchScreen(),
    );
  }
}