import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/user_provider.dart';
import 'level_bar.dart';
import 'skills_chip.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.userData;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No user data available")));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text("Student Profile")),
        body: Column(
          children: [
            _buildUserHeader(context, userProvider),
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Common Core"),
                Tab(text: "Piscine"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCursusView(context, userProvider, 21),
                  _buildCursusView(context, userProvider, 9),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, UserProvider provider) {
    final user = provider.userData!;
    final profileImageUrl = provider.getProfileImage();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[800],
            backgroundImage: profileImageUrl.isNotEmpty 
                ? CachedNetworkImageProvider(profileImageUrl) 
                : null,
            child: profileImageUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 12),
          Text(
            user['displayname'] ?? 'Unknown User',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "@${user['login']}",
            style: TextStyle(
              fontSize: 16, 
              color: Theme.of(context).primaryColor, 
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(user['email'] ?? 'No email', style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(context, "Wallet", "${user['wallet']} ₳"),
              _buildStatItem(context, "Eval Points", "${user['correction_point']}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value, 
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Theme.of(context).primaryColor
          )
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCursusView(BuildContext context, UserProvider provider, int cursusId) {
    final cursus = provider.getCursusData(cursusId);
    final projects = provider.getProjectsByCursus(cursusId);
    final List<dynamic> skills = cursus?['skills'] ?? [];

    if (cursus == null) return const Center(child: Text("No data found for this cursus"));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LevelBar(level: (cursus['level'] as num).toDouble()),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: Icon(Icons.bolt, color: Theme.of(context).primaryColor),
              title: const Text("Skills", style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SkillList(skills: skills),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: Icon(Icons.assignment, color: Theme.of(context).primaryColor),
              title: const Text("Projects", style: TextStyle(fontWeight: FontWeight.bold)),
              initiallyExpanded: true,
              children: [
                ProjectList(projects: projects),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectList extends StatelessWidget {
  final List<dynamic> projects;
  const ProjectList({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        final isValidated = project['validated?'] ?? false;
        return ListTile(
          title: Text(project['project']['name'] ?? "Unknown Project"),
          subtitle: Text("Status: ${project['status'] ?? "Unknown"}"),
          trailing: Text(
            "${project['final_mark'] ?? 0}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isValidated ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}