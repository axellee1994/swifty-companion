import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      return const Scaffold(
        body: Center(child: Text("No user data available")),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user['login'] ?? "Profile"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Common Core"),
              Tab(text: "Piscine"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Common Core (cursus_id: 21)
            _buildCursusView(context, userProvider, 21),
            // Tab 2: Piscine (cursus_id: 9)
            _buildCursusView(context, userProvider, 9),
          ],
        ),
      ),
    );
  }

  Widget _buildCursusView(BuildContext context, UserProvider provider, int cursusId) {
    final cursus = provider.getCursusData(cursusId);
    final projects = provider.getProjectsByCursus(cursusId);
    final List<dynamic> skills = cursus?['skills'] ?? [];

    if (cursus == null) {
      return const Center(child: Text("No data found for this cursus"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Level Representation
          LevelBar(level: (cursus['level'] as num).toDouble()),
          const SizedBox(height: 20),
          
          // 2. Neat Skills Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: const Icon(Icons.bolt, color: Color(0xFF00BABC)),
              title: const Text("Skills", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${skills.length} skills acquired"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SkillList(skills: skills),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          // 3. Neat Projects Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: const Icon(Icons.assignment, color: Color(0xFF00BABC)),
              title: const Text("Projects", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${projects.length} projects recorded"),
              initiallyExpanded: true, // Show projects by default
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
        final status = project['status'] ?? "Unknown";

        return ListTile(
          title: Text(project['project']['name'] ?? "Unknown Project"),
          subtitle: Text("Status: $status"),
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