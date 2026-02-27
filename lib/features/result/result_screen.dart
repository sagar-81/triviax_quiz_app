import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:triviax/features/quiz/provider/quiz_provider.dart';
import 'dart:math';

import 'package:triviax/features/quiz/view/home_screen.dart';

class ResultScreen extends StatefulWidget {
  final QuizState state;
  const ResultScreen({super.key, required this.state});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));

    // if (widget.state.score >= 50) {
    _controller.play();
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = widget.state.questions.length;
    final totalMarks = totalQuestions * 10;
    final percentage = ((widget.state.score / totalMarks) * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.06,
              numberOfParticles: 50,
              maxBlastForce: 30,
              minBlastForce: 15,
              gravity: 0.2,
              colors: const [Colors.orange, Colors.red, Colors.blue, Colors.green, Colors.purple],
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: -pi / 4,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 8,
              gravity: 0.2,
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: -3 * pi / 4,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 8,
              gravity: 0.2,
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Quiz Completed 🎉",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${widget.state.score} / $totalMarks",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),

                    const SizedBox(height: 10),

                    Text("$percentage%", style: const TextStyle(fontSize: 18, color: Colors.grey)),

                    const SizedBox(height: 20),

                    LinearProgressIndicator(
                      value: widget.state.score / totalMarks,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    const SizedBox(height: 30),

                    /// DETAILS
                    buildResultRow("Total Questions", totalQuestions.toString()),
                    buildResultRow("Correct Answers", widget.state.correctAnswers.toString()),
                    buildResultRow("Wrong Answers", widget.state.wrongAnswers.toString()),
                    buildResultRow("Lives Remaining", widget.state.lives.toString()),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text("Play Again", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
