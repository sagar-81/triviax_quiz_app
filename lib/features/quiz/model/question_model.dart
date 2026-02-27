class QuestionModel {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> shuffledAnswers;

  QuestionModel({required this.question, required this.correctAnswer, required this.incorrectAnswers})
    : shuffledAnswers = _shuffle(correctAnswer, incorrectAnswers);

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'],
      correctAnswer: json['correctAnswer'],
      incorrectAnswers: List<String>.from(json['incorrectAnswers']),
    );
  }

  static List<String> _shuffle(String correct, List<String> incorrect) {
    final all = [correct, ...incorrect];
    all.shuffle();
    return all;
  }
}
