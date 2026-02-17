import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../widgets/profile_page.dart';
import '../widgets/level_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("42 Swifty Companion")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: "Enter Intra Login",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) => userProvider.fetchUser(value.trim()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: userProvider.isLoading 
                  ? null 
                  : () => userProvider.fetchUser(_controller.text.trim()),
                child: userProvider.isLoading 
                  ? const CircularProgressIndicator() 
                  : const Text("Search User"),
              ),
              const SizedBox(height: 40),
              
              if (userProvider.userData != null)
                Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userProvider.userData!['image']['link'] ?? ''),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userProvider.userData!['displayname'] ?? "No Name",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Use the helper method from UserProvider to get the Core level
                    LevelBar(level: userProvider.getCoreLevel()),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: const Text("View Full Profile"),
                    ),
                  ],
                )
              else if (userProvider.errorMessage != null)
                Text(
                  userProvider.errorMessage!, 
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}