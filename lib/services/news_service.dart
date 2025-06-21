import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class NewsService {
  static const String apiKey = '4520a8888b234c4aa2137823706dd2aa'; // Replace this
  static const String baseUrl =
      'https://newsapi.org/v2/top-headlines?country=us&category=';

  static Future<List<Article>> fetchNews(String category) async {
    final response = await http.get(Uri.parse('$baseUrl$category&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['articles'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
