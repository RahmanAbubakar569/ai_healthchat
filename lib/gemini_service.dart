import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyDFosEmFtlsRFvTmx1gKIViKMhsJFoxu_Y"; 
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  Future<String> getAIResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"]?[0]["content"]["parts"]?[0]["text"] ??
            "No AI response.";
      } else {
        return "Error: ${response.body}";
      }
    } catch (e) {
      return "Unable to fetch AI response, Try Again: $e";
    }
  }
}
