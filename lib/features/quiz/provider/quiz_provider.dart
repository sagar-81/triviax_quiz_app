import 'package:flutter_riverpod/legacy.dart';
import '../model/question_model.dart';
import '../repository/quiz_repository.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});

class QuizState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final int lives;
  final bool isFinished;
  final int correctAnswers;
  final int wrongAnswers;

  QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.lives = 3,
    this.isFinished = false,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
  });

  QuizState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    int? lives,
    bool? isFinished,
    int? correctAnswers,
    int? wrongAnswers,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      isFinished: isFinished ?? this.isFinished,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState());

  final _repo = QuizRepository();

  Future<void> loadQuiz(String difficulty) async {
    final questions = await _repo.fetchQuestions(difficulty);
    state = QuizState(questions: questions);
  }

  void answerQuestion(String selected) {
    final question = state.questions[state.currentIndex];

    int newScore = state.score;
    int newLives = state.lives;
    int newCorrect = state.correctAnswers;
    int newWrong = state.wrongAnswers;

    if (selected == question.correctAnswer) {
      newScore += 10;
      newCorrect += 1;
    } else {
      newLives -= 1;
      newWrong += 1;
    }

    if (newLives <= 0 || state.currentIndex + 1 >= state.questions.length) {
      state = state.copyWith(
        score: newScore,
        lives: newLives,
        correctAnswers: newCorrect,
        wrongAnswers: newWrong,
        isFinished: true,
      );
    } else {
      state = state.copyWith(
        score: newScore,
        lives: newLives,
        correctAnswers: newCorrect,
        wrongAnswers: newWrong,
        currentIndex: state.currentIndex + 1,
      );
    }
  }

  void nextQuestion() {
    state = state.copyWith(currentIndex: state.currentIndex + 1);
  }

  void previousQuestion() {
    state = state.copyWith(currentIndex: state.currentIndex - 1);
  }

  void saveAnswer(String selected) {
    final question = state.questions[state.currentIndex];

    int newScore = state.score;
    int newCorrect = state.correctAnswers;
    int newWrong = state.wrongAnswers;

    if (selected == question.correctAnswer) {
      newScore += 10;
      newCorrect++;
    } else {
      newWrong++;
    }

    state = state.copyWith(score: newScore, correctAnswers: newCorrect, wrongAnswers: newWrong);
  }
}
