import 'package:gs1_barcode_parser/src/ai.dart';
import 'package:gs1_barcode_parser/src/element_parser.dart';
import 'package:gs1_barcode_parser/src/exception.dart';
import 'package:test/test.dart';

main() {
  final String gs1WithoutFNC1 = '01034531200000111719112510ABCD1234';
  final String gs1WithoutUnformatted = '0103453D200000111719112510ABCD1234';
  final String gs1WithoutFNC1Truncated = '010345312000';

  group('Parse fixed length element', () {
    final fixLengthParser = GS1ElementFixLengthParser();

    test('Successful parsed', () {
      final elementWithRest = fixLengthParser(gs1WithoutFNC1, AI.AIS['01']);
      print(elementWithRest.element.ai);
      print(elementWithRest.element.data);
      print(elementWithRest.rest);
    });

    test('Failed parse short data', () {
      expect(
          () => fixLengthParser(gs1WithoutFNC1Truncated, AI.AIS['01']),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message == 'Unexpected end of data for AI 01')));
    });

    test('Failed parse mismatched data ana A', () {
      expect(
          () => fixLengthParser(gs1WithoutFNC1, AI.AIS['02']),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message == 'Data and AI mismatch for AI 02')));
    });

    test('Failed parse with the wrong format', () {
      expect(
          () => fixLengthParser(gs1WithoutUnformatted, AI.AIS['01']),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^01(\d{14})$ flags= for AI 01')));
    });
  });
}
