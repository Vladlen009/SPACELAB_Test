import 'dart:convert';
import 'dart:math';

// Конвертаційна таблиця за замовчуванням
const defaultConversionTable = {
  'm': 1.0, // метр
  'cm': 0.01, // сантиметр
  'mm': 0.001, // міліметр
  'km': 1000.0, // кілометр
  'in': 0.0254, // дюйм
  'ft': 0.3048, // фут
  'yd': 0.9144, // ярд
  'mi': 1609.34, // миля
  'nmi': 1852.0, // морська миля
};
double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

Map<String, dynamic> convertDistance(
    Map<String, dynamic> input, Map<String, double> conversionTable) {
  if (!input.containsKey('distance') || !input.containsKey('convert_to')) {
    throw 'Invalid input format';
  }

  final distance = input['distance'];
  if (distance == null ||
      !distance.containsKey('unit') ||
      !distance.containsKey('value')) {
    throw 'Invalid distance format';
  }

  final unit = distance['unit'];
  final value = distance['value'];
  final convertTo = input['convert_to'];

  if (!conversionTable.containsKey(unit) ||
      !conversionTable.containsKey(convertTo)) {
    throw 'Unsupported unit';
  }

  if (value == null || value <= 0) {
    throw 'Invalid distance value';
  }

  // Конвертація в метри
  final inMeters = value * conversionTable[unit]!;
  // Конвертація в цільову одиницю
  final convertedValue = inMeters / conversionTable[convertTo]!;

  return {'unit': convertTo, 'value': roundDouble(convertedValue, 2)};
}

void main() {
  // Тестовий JSON
  const String inputJson = '''
  {"distance": {"unit": "m", "value": 0.5}, "convert_to": "in"}
  ''';

  // Розширена конвертаційна таблиця
  final conversionTable = {
    ...defaultConversionTable,
    'mi': 1609.34,
    'nmi': 1852.0,
  };

  final input = jsonDecode(inputJson);

  try {
    final output = convertDistance(input, conversionTable);
    print(jsonEncode(output));
  } catch (e) {
    print('Error: $e');
  }
}
