import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:test/test.dart';

main() {
  final String barcode =
      ']C101040123456789011715012910ABC1233932971471131030005253922471142127649716';

  final String barcode2 =
      '01040123456789011715012910ABC123393297147113103000525392247114212764971691';

  test('Instance object', () {
    final parser = GS1BarcodeParser.defaultParser();
    expect(parser, predicate((e) {
      return e is GS1BarcodeParser;
    }));
  });

  group('Parse host barcode', () {
    final parser = GS1BarcodeParser.defaultParser();
    final result = parser.parse(barcode);
    test('codeType', () {
      expect(result.code.type, CodeType.GS1_128);
    });
    test('hasAI', () {
      expect(result.hasAI('01'), true);
    });
    test('getAIRawData', () {
      expect(result.getAIRawData('01'), '04012345678901');
    });
  });

  test('Parse raw barcode from scanner', () {
    final parser = GS1BarcodeParser.defaultParser();
    final result = parser.parse(barcode2, codeType: CodeType.DATAMATRIX);
    expect(result.code.type, CodeType.DATAMATRIX);
    expect(result.hasAI('01'), true);
    expect(result.getAIRawData('01'), '04012345678901');
  });

  test('Parse raw barcode from scanner with 714 AI', () {
    final String barcode3 = '0105609380810435212674577536673210A2075I0172509307149507343';
    final parser = GS1BarcodeParser.defaultParser();
    final result = parser.parse(barcode3,);
    expect(result.code.type, CodeType.UNDEFINED);
    expect(result.hasAI('714'), true);
    expect(result.getAIRawData('714'), '9507343');
  });

}
