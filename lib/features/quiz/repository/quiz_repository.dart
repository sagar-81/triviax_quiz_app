import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/question_model.dart';

class QuizRepository {
  Future<List<QuestionModel>> fetchQuestions(String difficulty) async {
    final url =
        'https://the-trivia-api.com/api/questions?limit=10&difficulty=$difficulty';

    final response = await http.get(Uri.parse(url));

    final data = json.decode(response.body) as List;

    return data.map((e) => QuestionModel.fromJson(e)).toList();
  }
}