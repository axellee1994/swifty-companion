class ProjectList extends StatelessWidget {
  final List<dynamic> projects;

  const ProjectList({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Crucial if inside another scrollable
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        final isValidated = project['validated?'] ?? false;
        final status = project['status'];

        return ListTile(
          title: Text(project['project']['name']),
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