import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:gs1_barcode_parser/src/element_parser.dart';
import 'package:gs1_barcode_parser/src/exception.dart';
import 'package:test/test.dart';

main() {
  final GS1BarcodeParserConfig config = GS1BarcodeParserConfig();

  group('Parse fixed length element', () {
    final String gs1WithoutFNC1 = '01034531200000111719112510ABCD1234';
    final String gs1WithoutUnformatted = '0103453D200000111719112510ABCD1234';
    final String gs1WithoutFNC1Truncated = '010345312000';
    final fixLengthParser = GS1ElementFixLengthParser();

    test('Fixed length element successful parsed', () {
      final elementWithRest =
          fixLengthParser(gs1WithoutFNC1, AI.AIS['01'] as AI, config);
      expect(elementWithRest.rest, equals('1719112510ABCD1234'));
      expect(elementWithRest.element.data, equals('03453120000011'));
      expect(elementWithRest.element.aiCode, equals('01'));
      expect(elementWithRest.element.rawData, equals('03453120000011'));
    });

    test('Fixed length element failed parse short data', () {
      expect(
          () => fixLengthParser(
              gs1WithoutFNC1Truncated, AI.AIS['01'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^01(\d{14})$ flags= for AI 01')));
    });

    test('Fixed length element failed parse mismatched data an AI', () {
      expect(
          () => fixLengthParser(gs1WithoutFNC1, AI.AIS['02'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^02(\d{14})$ flags= for AI 02')));
    });

    test('Fixed length element failed parse with the wrong format', () {
      expect(
          () => fixLengthParser(
              gs1WithoutUnformatted, AI.AIS['01'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^01(\d{14})$ flags= for AI 01')));
    });
  });

  group('Parse date element', () {
    final dateParser = GS1DateParser();
    final String gs1WithoutFNC1 = '1715012910ABC12339329714711';
    final String gs1WithoutUnformatted = '1715D12910ABC12339329714711';
    final String gs1WithoutFNC1Truncated = '17150';

    test('Date element successful parsed', () {
      final elementWithRest =
          dateParser(gs1WithoutFNC1, AI.AIS['17'] as AI, config);
      expect(elementWithRest.rest, equals('10ABC12339329714711'));
      expect(elementWithRest.element.data, equals(DateTime(2015, 1, 29)));
      expect(elementWithRest.element.rawData, equals('150129'));
      expect(elementWithRest.element.aiCode, equals('17'));
    });

    test('Date element failed parse short data', () {
      expect(
          () => dateParser(gs1WithoutFNC1Truncated, AI.AIS['17'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^17(\d{6})$ flags= for AI 17')));
    });

    test('Fixed length element failed parse mismatched data an AI', () {
      expect(
          () => dateParser(gs1WithoutFNC1, AI.AIS['16'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^16(\d{6})$ flags= for AI 16')));
    });

    test('Fixed length element failed parse with the wrong format', () {
      expect(
          () => dateParser(gs1WithoutUnformatted, AI.AIS['17'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^17(\d{6})$ flags= for AI 17')));
    });
  });

  group('Variable length element', () {
    final variableLengthParser = GS1VariableLengthParser();
    final String gs1WithoutFNC1 = '10ABC12339329714711';
    final String gs1WithoutUnformatted = '10AПC12339329714711';
    final String gs1WithoutFNC1Truncated = '1039329714711';

    test('Variable length element successful parsed', () {
      final elementWithRest =
          variableLengthParser(gs1WithoutFNC1, AI.AIS['10'] as AI, config);
      expect(elementWithRest.rest, equals('39329714711'));
      expect(elementWithRest.element.data, equals('ABC123'));
      expect(elementWithRest.element.rawData, equals('ABC123'));
      expect(elementWithRest.element.aiCode, equals('10'));
    });

    test('Variable length empty element successful parsed', () {
      final elementWithRest = variableLengthParser(
          gs1WithoutFNC1Truncated, AI.AIS['10'] as AI, config);
      expect(elementWithRest.rest, equals('39329714711'));
      expect(elementWithRest.element.data, equals(''));
      expect(elementWithRest.element.rawData, equals(''));
      expect(elementWithRest.element.aiCode, equals('10'));
    });

    test('Variable length  element failed parse mismatched data an AI', () {
      expect(
          () =>
              variableLengthParser(gs1WithoutFNC1, AI.AIS['21'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^21([!-"%-/0-9:-?A-Z_a-z]{0,20})$ flags= for AI 21')));
    });

    test('Variable length element failed parse with the wrong format', () {
      expect(
          () => variableLengthParser(
              gs1WithoutUnformatted, AI.AIS['10'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^10([!-"%-/0-9:-?A-Z_a-z]{0,20})$ flags= for AI 10')));
    });
  });

  group('Fixed length measure element', () {
    final fixLengthMeasureParser = GS1ElementFixLengthMeasureParser();
    final String gs1WithoutFNC1 = '31030005253922471142127649716';
    final String gs1WithoutUnformatted = '31030A05253922471142127649716';
    final String gs1WithoutFNC1Truncated = '310300';

    test('Variable length element successful parsed', () {
      final elementWithRest =
          fixLengthMeasureParser(gs1WithoutFNC1, AI.AIS['3103'] as AI, config);
      expect(elementWithRest.rest, equals('3922471142127649716'));
      expect(elementWithRest.element.data, equals(0.525));
      expect(elementWithRest.element.rawData, equals('000525'));
      expect(elementWithRest.element.aiCode, equals('3103'));
    });

    test('Fixed length measure  element failed parse short data', () {
      expect(
          () => fixLengthMeasureParser(
              gs1WithoutFNC1Truncated, AI.AIS['3103'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^3103(\d{6})$ flags= for AI 3103')));
    });

    test('Fixed length measure element failed parse mismatched data an AI', () {
      expect(
          () => fixLengthMeasureParser(
              gs1WithoutFNC1, AI.AIS['3102'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^3102(\d{6})$ flags= for AI 3102')));
    });

    test('Fixed length measure element failed parse with the wrong format', () {
      expect(
          () => fixLengthMeasureParser(
              gs1WithoutUnformatted, AI.AIS['3103'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^3103(\d{6})$ flags= for AI 3103')));
    });
  });

  group('Variable length with ISO number element', () {
    final variableLengthWithISONumbersParser =
        GS1VariableLengthWithISONumbersParser();
    final String gs1WithoutFNC1 = '3932971471131030005253922471142127649716';
    final String gs1WithoutUnformatted =
        '39329A147131030005253922471142127649716';
    final String gs1WithoutUnformatted2 =
        '393297147A131030005253922471142127649716';
    final String gs1WithoutFNC1Truncated = '393297';

    test('Variable length with ISO number element successful parsed', () {
      final elementWithRest = variableLengthWithISONumbersParser(
          gs1WithoutFNC1, AI.AIS['3932'] as AI, config);
      expect(elementWithRest.rest, equals('31030005253922471142127649716'));
      expect(elementWithRest.element.data, equals(47.11));
      expect(elementWithRest.element.rawData, equals('9714711'));
      expect(elementWithRest.element.iso, equals('971'));
      expect(elementWithRest.element.aiCode, equals('3932'));
    });

    test('Variable length with ISO number element failed parse short data', () {
      expect(
          () => variableLengthWithISONumbersParser(
              gs1WithoutFNC1Truncated, AI.AIS['3932'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^3932(\d{3})(\d{0,15})$ flags= for AI 3932')));
    });

    test(
        'Variable length with ISO number element failed parse mismatched data an AI',
        () {
      expect(
          () => variableLengthWithISONumbersParser(
              gs1WithoutFNC1, AI.AIS['3933'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^3933(\d{3})(\d{0,15})$ flags= for AI 3933')));
    });

    test(
        'Variable length with ISO number element failed parse with the wrong format',
        () {
      expect(
          () => variableLengthWithISONumbersParser(
              gs1WithoutUnformatted, AI.AIS['3933'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^3933(\d{3})(\d{0,15})$ flags= for AI 3933')));
    });

    test(
        'Variable length with ISO number element failed parse with the wrong format 2',
        () {
      expect(
          () => variableLengthWithISONumbersParser(
              gs1WithoutUnformatted2, AI.AIS['3933'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^3933(\d{3})(\d{0,15})$ flags= for AI 3933')));
    });
  });

  group('Variable length with ISO chars element', () {
    final variableLengthWithISOCharsParser =
        GS1VariableLengthWithISOCharsParser();
    final String gs1WithoutFNC1 = '4212764971631030005253922471142127649716';
    final String gs1WithoutUnformatted =
        '4212A64971631030005253922471142127649716';
    final String gs1WithoutUnformatted2 =
        '421276497П631030005253922471142127649716';
    final String gs1WithoutFNC1Truncated = '42127';

    test('Variable length with ISO chars element successful parsed', () {
      final elementWithRest = variableLengthWithISOCharsParser(
          gs1WithoutFNC1, AI.AIS['421'] as AI, config);
      expect(elementWithRest.rest, equals('31030005253922471142127649716'));
      expect(elementWithRest.element.data, equals('49716'));
      expect(elementWithRest.element.rawData, equals('27649716'));
      expect(elementWithRest.element.iso, equals('276'));
      expect(elementWithRest.element.aiCode, equals('421'));
    });

    test('Variable length with ISO chars  element failed parse short data', () {
      expect(
          () => variableLengthWithISOCharsParser(
              gs1WithoutFNC1Truncated, AI.AIS['421'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^421(\d{3})([!-"%-/0-9:-?A-Z_a-z]{0,9})$ flags= for AI 421')));
    });

    test(
        'Variable length with ISO chars  element failed parse mismatched data an AI',
        () {
      expect(
          () => variableLengthWithISOCharsParser(
              gs1WithoutFNC1, AI.AIS['10'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^10([!-"%-/0-9:-?A-Z_a-z]{0,20})$ flags= for AI 10')));
    });

    test(
        'Variable length with ISO chars  element failed parse with the wrong format',
        () {
      expect(
          () => variableLengthWithISOCharsParser(
              gs1WithoutUnformatted, AI.AIS['421'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^421(\d{3})([!-"%-/0-9:-?A-Z_a-z]{0,9})$ flags= for AI 421')));
    });

    test(
        'Variable length with ISO chars  element failed parse with the wrong format 2',
        () {
      expect(
          () => variableLengthWithISOCharsParser(
              gs1WithoutUnformatted2, AI.AIS['421'] as AI, config),
          throwsA(predicate((e) =>
              e is GS1ParseException &&
              e.message ==
                  r'Data format mismatch RegExp: pattern=^421(\d{3})([!-"%-/0-9:-?A-Z_a-z]{0,9})$ flags= for AI 421')));
    });
  });
}
