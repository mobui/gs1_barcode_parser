import 'package:gs1_barcode_parser/src/code.dart';
import 'package:gs1_barcode_parser/src/code_parser.dart';
import 'package:test/test.dart';

main() {
  final codeParser = GS1PrefixCodeParser();
  final String gs1DataMatrix = ']d201034531200000111719112510ABCD1234';
  final String gs1QRCode = ']Q301034531200000111719112510ABCD1234';
  final String gs1WithoutFNC1 = '01034531200000111719112510ABCD1234';
  final String gs1Code128 = ']C101034531200000111719112510ABCD1234';
  final String gs1EAN = ']e001034531200000111719112510ABCD1234';

  test('parse GS1 Data Matrix code', () {
    final codeWithRest = codeParser(gs1DataMatrix);
    expect(codeWithRest.code.type, equals(CodeType.DATAMATRIX));
    expect(
        codeWithRest.code.fnc1, equals(Code.CODES[CodeType.DATAMATRIX].fnc1));
    expect(codeWithRest.rest, equals(gs1WithoutFNC1));
  });

  test('parse GS1 QR code', () {
    final codeWithRest = codeParser(gs1QRCode);
    expect(codeWithRest.code.type, equals(CodeType.QR_CODE));
    expect(codeWithRest.code.fnc1, equals(Code.CODES[CodeType.QR_CODE].fnc1));
    expect(codeWithRest.rest, equals(gs1WithoutFNC1));
  });

  test('parse GS1 Code-128 code', () {
    final codeWithRest = codeParser(gs1Code128);
    expect(codeWithRest.code.type, equals(CodeType.GS1_128));
    expect(codeWithRest.code.fnc1, equals(Code.CODES[CodeType.GS1_128].fnc1));
    expect(codeWithRest.rest, equals(gs1WithoutFNC1));
  });

  test('parse GS1 EAN code', () {
    final codeWithRest = codeParser(gs1EAN);
    expect(codeWithRest.code.type, equals(CodeType.EAN));
    expect(codeWithRest.code.fnc1, equals(Code.CODES[CodeType.EAN].fnc1));
    expect(codeWithRest.rest, equals(gs1WithoutFNC1));
  });

  test('parse GS1 code without fnc1', () {
    final codeWithRest = codeParser(gs1WithoutFNC1);
    expect(codeWithRest.code.type, equals(CodeType.UNDEFINED));
    expect(codeWithRest.code.fnc1, equals(Code.UNDEFINED_CODE.fnc1));
    expect(codeWithRest.rest, equals(gs1WithoutFNC1));
  });
}
