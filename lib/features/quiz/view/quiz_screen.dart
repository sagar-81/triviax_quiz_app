import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triviax/features/result/result_screen.dart';
import '../provider/quiz_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider);

    final question = state.questions[state.currentIndex];
    final answers = question.shuffledAnswers;
    final totalQuestions = state.questions.length;
    final isLast = state.currentIndex == totalQuestions - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "TriviaX Quiz",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Question Counter
            Text(
              "Question ${state.currentIndex + 1} of $totalQuestions",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 15),

            /// Question Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Text(
                question.question,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final answer = answers[index];
                  final isSelected = selectedAnswer == answer;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = answer;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange.shade100 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade300, width: 2),
                        ),
                        child: Text(
                          answer,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.orange : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                if (state.currentIndex > 0)
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: state.currentIndex == 0
                            ? null
                            : () {
                                ref.read(quizProvider.notifier).previousQuestion();
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: state.currentIndex == 0 ? Colors.grey.shade300 : Colors.orange,
                            width: 1.8,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: state.currentIndex == 0 ? Colors.grey : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Previous",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: state.currentIndex == 0 ? Colors.grey : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                if (state.currentIndex > 0) const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: selectedAnswer == null
                        ? null
                        : () {
                            ref.read(quizProvider.notifier).saveAnswer(selectedAnswer!);

                            setState(() {
                              selectedAnswer = null;
                            });

                            if (isLast) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => ResultScreen(state: ref.read(quizProvider))),
                              );
                            } else {
                              ref.read(quizProvider.notifier).nextQuestion();
                            }
                          },
                    child: Text(isLast ? "Submit" : "Next", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
