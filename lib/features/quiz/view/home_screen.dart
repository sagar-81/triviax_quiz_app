import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quiz_screen.dart';
import '../provider/quiz_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("TriviaX")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            difficultyButton(context, ref, "easy"),
            difficultyButton(context, ref, "medium"),
            difficultyButton(context, ref, "hard"),
          ],
        ),
      ),
    );
  }

  Widget difficultyButton(BuildContext context, WidgetRef ref, String level) {
    final Map<String, List<Color>> difficultyColors = {
      "easy": [const Color(0xFF16C47F), const Color(0xFF0E9F6E)],
      "medium": [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      "hard": [const Color(0xFFEF4444), const Color(0xFFDC2626)],
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: GestureDetector(
        onTap: () async {
          await ref.read(quizProvider.notifier).loadQuiz(level);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: difficultyColors[level]!,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: difficultyColors[level]!.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              level.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
