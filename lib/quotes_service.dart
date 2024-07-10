import 'dart:convert';
import 'package:http/http.dart' as http;

class QuotesService {
  static const String baseUrl = 'https://api.quotable.io';

  static Future<String> fetchRandomQuote() async {
    final response = await http.get(Uri.parse('$baseUrl/random'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return '${data['content']} - ${data['author']}';
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
