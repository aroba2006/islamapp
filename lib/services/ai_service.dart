import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AIService {
  // This is the URL from your Cloudflare dashboard
  static const String _workerUrl = 'https://islamic-ai-proxy.kennynoby.workers.dev';

  Future<String> getIslamicAnswer({
    required String question,
    required BuildContext context,
  }) async {
    // Detects if the app is in Arabic, French, or English
    final language = Localizations.localeOf(context).languageCode; 

    try {
      // Sends the question to your invisible Cloudflare server
      final response = await http.post(
        Uri.parse(_workerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          'language': language,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Reads the smart answer from Gemini
        final data = jsonDecode(utf8.decode(response.bodyBytes)); 
        return data['answer'];
      } else {
        return _offlineFallback(language);
      }
    } catch (e) {
      // If the user's internet drops, it shows this safe message instead of crashing
      return _offlineFallback(language);
    }
  }

  String _offlineFallback(String lang) {
    if (lang == 'ar') return 'عذراً، لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مرة أخرى.';
    if (lang == 'fr') return 'Désolé, pas de connexion internet. Veuillez vérifier votre réseau et réessayer.';
    return 'Sorry, no internet connection. Please check your network and try again.';
  }
}