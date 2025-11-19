import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _endpoint = 'http://37.114.50.91:8310/transcribe';
  static Future<String?> transcribe(String url) async {
    final uri = Uri.parse(_endpoint);
    final body = jsonEncode({'url': url, 'format': 'json', 'language': 'en'});
    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (resp.statusCode == 200) {
        try {
          final Map<String, dynamic> data = jsonDecode(resp.body);
          final transcription = data['transcription'];
          if (transcription is Map && transcription.containsKey('text')) {
            return transcription['text'] as String?;
          }
          if (transcription is String) return transcription;
          if (data.containsKey('text') && data['text'] is String) {
            return data['text'] as String?;
          }

          return null;
        } on FormatException catch (_) {
          throw Exception('write a valid URL');
        }
      } else {
        throw Exception('Failed to transcribe');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
