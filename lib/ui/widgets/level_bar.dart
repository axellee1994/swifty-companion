import 'package:flutter/material.dart';

class LevelBar extends StatelessWidget {
  final double level;

  const LevelBar({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    double progress = level - level.toInt(); 
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              value: progress,
              minHeight: 25,
              backgroundColor: Theme.of(context).colorScheme.surface,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              "Level ${level.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}