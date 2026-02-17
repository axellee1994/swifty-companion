import 'package:flutter/material.dart';

class SkillList extends StatelessWidget {
  final List<dynamic> skills;

  const SkillList({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const Text("No skills listed for this cursus.");
    }

    // Sort skills by level descending to show strongest skills first
    final sortedSkills = List.from(skills);
    sortedSkills.sort((a, b) => b['level'].compareTo(a['level']));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: sortedSkills.map((skill) {
          final String name = skill['name'] ?? 'Unknown';
          final double level = (skill['level'] as num).toDouble();
          // Normalize level for progress bar (assuming max skill level is ~20)
          final double progress = (level / 20).clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text(level.toStringAsFixed(2), style: const TextStyle(color: Color(0xFF00BABC))),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[800],
                    color: const Color(0xFF00BABC),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}