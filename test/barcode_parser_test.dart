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

  test('Parse host barcode', () {
    final parser = GS1BarcodeParser.defaultParser();
    final result = parser.parse(barcode);
    print(result);
    expect(result.code.type, CodeType.GS1_128);
    expect(result.hasAI('01'), true);
    expect(result.getAIRawData('01'), '04012345678901');
  });

  test('Parse raw barcode from scanner', () {
    final parser = GS1BarcodeParser.defaultParser();
    final result = parser.parse(barcode2, codeType: CodeType.DATAMATRIX);
    print(result);
    expect(result.code.type, CodeType.DATAMATRIX);
    expect(result.hasAI('01'), true);
    expect(result.getAIRawData('01'), '04012345678901');
  });
}
