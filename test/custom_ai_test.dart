import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:test/test.dart';

main() {
  final String barcode = '0150602641158911020414891725122811210101';

  group('Parse custom invalid barcode', () {
    final parser =
        GS1BarcodeParser.configurableParser(GS1BarcodeParserConfig(customAIs: {
      '01': const AI(
        code: '01',
        fixLength: 13,
        type: AIFormatType.FIXED_LENGTH,
        dataTitle: 'GTIN',
        regExpString: r'^01(\d{13})$',
        description: 'EAN13',
      ),
    }));
    final result = parser.parse(barcode);
    test('codeType', () {
      expect(result.code.type, CodeType.UNDEFINED);
    });
    test('hasAI', () {
      expect(result.hasAI('01'), true);
    });
    test('getAIRawData', () {
      expect(result.getAIRawData('01'), '5060264115891');
    });

    test('hasAI', () {
      expect(result.hasAI('10'), true);
    });

    test('getAIRawData', () {
      expect(result.getAIRawData('10'), '2041489');
    });

    test('hasAI', () {
      expect(result.hasAI('17'), true);
    });
    test('getAIRawData', () {
      expect(result.getAIRawData('17'), '251228');
    });
    test('hasAI', () {
      expect(result.hasAI('11'), true);
    });

    test('getAIRawData', () {
      expect(result.getAIRawData('11'), '210101');
    });
  });
}
