import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:test/test.dart';

main() {
  final String barcode =
      ']C101040123456789011715012910ABC1233932971471131030005253922471142127649716';

  test('Instance object', () {
    final parser = GS1BarcodeParser.defaultParser();
    expect(parser, predicate((e) {
      return e is GS1BarcodeParser;
    }));
  });

  test('Instance object', () {
    final parser = GS1BarcodeParser.defaultParser();
    final result = parser.parse(barcode);
    print(result);
  });
}
