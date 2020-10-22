import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';

main() {
  final String barcode =
      ']C101040123456789011715012910ABC1233932971471131030005253922471142127649716';

  final parser = GS1BarcodeParser.defaultParser();
  final result = parser.parse(barcode);
  print(result);
}
