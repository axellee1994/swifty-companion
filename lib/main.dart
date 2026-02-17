import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/services/dio_handler.dart';
import 'providers/auth_provider.dart';

// Turn main into an async function
Future<void> main() async {
  await dotenv.load(fileName: ".env");

  DioHandler.setup();

  //Create the AuthProvider and trigger the login
  final authProvider = AuthProvider();
  await authProvider.authenticate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Check terminal for the token!")),
      ),
    );
  }
}