import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:gs1_barcode_parser/src/exception.dart';
import 'package:test/test.dart';

main() {
  final String barcode8001 = '800111111111111111';
  final String barcode8002 = '8002+79605678797';
  final String barcode8003 = '800301111111111111XXX';
  final String barcode8004 = '800440628074100000001';
  final String barcode8005 = '8005123456';
  final String barcode8007 = '8007123456';

  group('8001', () {
    test('Parse 8001 - success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(barcode8001);
      expect(result.hasAI('8001'), true);
      expect(result.getAIRawData('8001'), '11111111111111');
    });

    test('Parse 8001 - very long', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('8001111111111111111'),
          throwsA(isA<GS1ParseException>()));
    });

    test('Parse 8001 - very short', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('80011111111111111'),
          throwsA(isA<GS1ParseException>()));
    });
    test('Parse 8001 - invalid symbol', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('800111111111111d'),
          throwsA(isA<GS1ParseException>()));
    });
  });

  group('8002', () {
    test('Parse 8002 - success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(barcode8002);
      expect(result.hasAI('8002'), true);
      expect(result.getAIRawData('8002'), '+79605678797');
    });

    test('Parse 8002 - very long', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('8002+796056787971000000001'),
          throwsA(isA<GS1ParseException>()));
    });
    test('Parse 8002 - invalid symbol', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('8002🤘79605678797'),
          throwsA(isA<GS1ParseException>()));
    });
  });

  group('8003', () {
    test('Parse 8003 - success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(barcode8003);
      expect(result.hasAI('8003'), true);
      expect(result.getAIRawData('8003'), '01111111111111XXX');
    });

    test('Parse 8003 - very long', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('800301111111111111zzz111111111111ccccccccccc'),
          throwsA(isA<GS1ParseException>()));
    });

    test('Parse 8003 - very short', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('80030111111111111'),
          throwsA(isA<GS1ParseException>()));
    });

    test('Parse 8003 - no first zero', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('800311111111111111'),
          throwsA(isA<GS1ParseException>()));
    });

    test('Parse 8003 - invalid symbol', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('800301111b11111111'),
          throwsA(isA<GS1ParseException>()));
    });
  });

  group('8004', () {
    test('Parse 8004', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(barcode8004);
      expect(result.hasAI('8004'), true);
      expect(result.getAIRawData('8004'), '40628074100000001');
    });

    test('Parse 8004 - very long', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('800401111111111111zzz111111111111ccccccccccc'),
          throwsA(isA<GS1ParseException>()));
    });
  });

  group('8005', () {
    test('Parse 8005 - success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(barcode8005);
      expect(result.hasAI('8005'), true);
      expect(result.getAIRawData('8005'), '123456');
    });

    test('Parse 8005 - very long', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(
          () => parser.parse('80051234567'), throwsA(isA<GS1ParseException>()));
    });

    test('Parse 8003 - very short', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(
          () => parser.parse('800512345'), throwsA(isA<GS1ParseException>()));
    });
  });

  group('8007', () {
    test('Parse 8007 - success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(barcode8007);
      expect(result.hasAI('8007'), true);
      expect(result.getAIRawData('8007'), '123456');
    });
    test('Parse 8007 - very long', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(
          () => parser.parse(
              '8007ahsdkjhaskjdhaskjdhajkshdkjashdkjahskjdhaskjdhkjashdkas'),
          throwsA(isA<GS1ParseException>()));
    });
  });

  group('8008', () {
    test('Parse 8008 - success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse('800824010111');
      expect(result.hasAI('8008'), true);
      expect(result.getAIRawData('8008'), '24010111');
    });

    test('Parse 8008 - success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse('8008240101120005');
      expect(result.hasAI('8008'), true);
      expect(result.getAIRawData('8008'), '240101120005');
    });

    test('Parse 8008 - parsed success', () {
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse('8008240101120005');
      expect(result.hasAI('8008'), true);
      expect(result.getAIParsedElement('8008')?.data as DateTime,
          DateTime(2024, 1, 1, 12, 0, 5));
    });

    test('Parse 8008 - very long', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(() => parser.parse('80082401011200051'),
          throwsA(isA<GS1ParseException>()));
    });

    test('Parse 8008 - very short', () {
      final parser = GS1BarcodeParser.defaultParser();
      expect(
          () => parser.parse('80082401011'), throwsA(isA<GS1ParseException>()));
    });
  });
}
