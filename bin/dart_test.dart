import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

Future<String> detectLanguage(String text) async {
  const headers = {
    'content-type': 'application/x-www-form-urlencoded',
    'Accept-Encoding': 'application/gzip',
    'X-RapidAPI-Key': 'db1796083cmsh45b90710c79dfc7p139b66jsn60964f6acad5',
    'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com',
  };

  final data = {
    'q': text,
  };

  final url =
      'https://google-translate1.p.rapidapi.com/language/translate/v2/detect';

  final dio = Dio();
  try {
    final response = await dio.post(
      url,
      data: data,
      options: Options(
        headers: headers,
      ),
    );

    final detections = response.data['data']['detections'][0];
    if (detections.isNotEmpty) {
      final language = detections[0]['language'];
      return language;
    }
    return 'unknown_language'; // Handle the case when no detections are available
  } catch (e) {
    print('Request failed with error: $e.');
    return 'unknown_language'; // Return a default value in case of error
  }
}

String _readLine() {
  final input = stdin.readLineSync();
  return input?.trim() ?? "";
}

Future<Map<String, dynamic>> translate3(String item) async {
  var params = {
    'q': item,
    'target': 'uk',
    'source': 'en',
  };

  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept-Encoding': 'application/gzip',
    'X-RapidAPI-Key': '818ccaa283msh8e954e6c61f133ap13d25ajsn295ed402174b',
    'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com',
  };

  var dio = Dio();

  try {
    var response = await dio.post(
      'https://google-translate1.p.rapidapi.com/language/translate/v2',
      data: params,
      options: Options(
        headers: headers,
      ),
    );

    // print(response.data);

    return response.data; // No need for additional decoding
  } catch (e) {
    print('Request failed with error: $e.');
    return {}; // Return an empty map as a default value for error cases
  }
}

void main() async {
  while (true) {
    printWarning(
        "Введите команду ('translate', 'detect', или 'end' для выхода): ");
    final command = _readLine();

    if (command == "end") {
      printWarning("Приложение завершено.");
      break;
    } else if (command == "translate") {
      printWarning("Введите слово для перевода:");
      final word = _readLine();

      final translation = await translate3(word);
      String translatedText =
          translation['data']['translations'][0]['translatedText'];

      printWarning("Перевод слова '$word': $translatedText");
    } else if (command == "detect") {
      printWarning("Введите текст для определения языка:");
      final text = _readLine();

      final language = await detectLanguage(text);

      printWarning("language $text : $language");
      // print(colorize("Определенный язык: ${language['data']['detections'][0][0]['language']}"));
    } else {
      printError(
          "Неверная команда. Пожалуйста, введите 'translate', 'detect' или 'end'.");
    }
  }
}