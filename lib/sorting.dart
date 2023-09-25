import 'dart:convert';

typedef Rule = List<Map<String, dynamic>> Function(
    List<Map<String, dynamic>> data, dynamic condition);

// Модуль для правила "include"
List<Map<String, dynamic>> includeRule(
    List<Map<String, dynamic>> data, dynamic condition) {
  return data.where((element) {
    return condition.every((cond) {
      return element[cond.keys.first] == cond.values.first;
    });
  }).toList();
}

// Модуль для правила "exclude"
List<Map<String, dynamic>> excludeRule(
    List<Map<String, dynamic>> data, dynamic condition) {
  return data.where((element) {
    return condition.every((cond) {
      return element[cond.keys.first] != cond.values.first;
    });
  }).toList();
}

// Модуль для правила "sort_by"
List<Map<String, dynamic>> sortByRule(
    List<Map<String, dynamic>> data, dynamic condition) {
  return [...data]..sort((a, b) {
      for (var key in condition) {
        var res = Comparable.compare(a[key], b[key]);
        if (res != 0) return res;
      }
      return 0;
    });
}

void main() {
  const String inputJson = '''
  {
    "data": [
      {"user": "mike@mail.com", "rating": 20, "disabled": false},
      {"user": "greg@mail.com", "rating": 14, "disabled": false},
      {"user": "john@mail.com", "rating": 25, "disabled": true}
    ],
    "condition": {"exclude": [{"disabled": true}], "sort_by": ["rating"]}
  }
  ''';

  final Map<String, Rule> rules = {
    'include': includeRule,
    'exclude': excludeRule,
    'sort_by': sortByRule,
  };

  var input = jsonDecode(inputJson);
  var data = List<Map<String, dynamic>>.from(input['data']);
  var condition = input['condition'];

  for (var rule in condition.keys) {
    if (rules.containsKey(rule)) {
      data = rules[rule]!(data, condition[rule]);
    }
  }

  print(jsonEncode({'result': data}));
}
