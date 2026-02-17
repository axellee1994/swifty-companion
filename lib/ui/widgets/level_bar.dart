Widget buildLevelBar(double level) {
  double progress = level - level.toInt(); // Gets the decimal part (e.g., 0.42)
  
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 20,
            backgroundColor: Colors.grey[800],
            color: const Color(0xFF00BABC),
          ),
          Text(
            "Level ${level.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    ],
  );
}