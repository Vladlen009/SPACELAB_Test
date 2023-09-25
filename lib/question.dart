import 'dart:io';
import 'dart:convert';

void main() async{
  final List<Map<String, String>> answers = [];

  final jsonConfig = {
    'questions': [
      {
        'id': 1,
        'text': 'What is your marital status?',
        'options': ['Single', 'Married'],
        'next': {'Single': 2, 'Married': 3}
      },
      {
        'id': 2,
        'text': 'Are you planning on getting married next year?',
        'options': ['Yes', 'No'],
        'next': {'Yes': null, 'No': null}
      },
      {
        'id': 3,
        'text': 'How long have you been married?',
        'options': ['Less than a year', 'More than a year'],
        'next': {'Less than a year': null, 'More than a year': 4}
      },
      {
        'id': 4,
        'text': 'Have you celebrated your one year anniversary?',
        'options': ['Yes', 'No'],
        'next': {'Yes': null, 'No': null}
      },
    ]
  };

  void displayQuestion(Map<String, dynamic> question) {
    print(question['text']);
    for (var i = 0; i < question['options'].length; i++) {
      print('${i + 1}. ${question['options'][i]}');
    }

    final userChoice = stdin.readLineSync();
    final chosenOption = question['options'][int.parse(userChoice!) - 1];
    answers.add({question['text']: chosenOption});
    final nextQuestionId = question['next'][chosenOption];

    if (nextQuestionId != null) {
      final nextQuestion =
          jsonConfig['questions']?.firstWhere((q) => q['id'] == nextQuestionId);
      if (nextQuestion != null) displayQuestion(nextQuestion);
    }
  }

  final firstQuestion =
      jsonConfig['questions']?.firstWhere((q) => q['id'] == 1);
  if (firstQuestion != null) displayQuestion(firstQuestion);

  print('Your answers: ${jsonEncode(answers)}');
}
