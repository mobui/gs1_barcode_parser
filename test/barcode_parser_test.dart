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
    final String barcode3 =
        '0105609380810435212674577536673210A2075I0172509307149507343';
    final parser = GS1BarcodeParser.defaultParser();
    final result = parser.parse(
      barcode3,
    );
    expect(result.code.type, CodeType.UNDEFINED);
    expect(result.hasAI('714'), true);
    expect(result.getAIRawData('714'), '9507343');
  });

  // barcode examples from https://честныйзнак.рф/upload/Структура%20DataMatrix.pdf
  group('parse CRPT marking codes', () {
    test('tobacco block', () {
      final String barcode1 = '010460043993125621JgXJ5.T800511200093Mdlr';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode1,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04600439931256');
      expect(result.getAIRawData('21'), 'JgXJ5.T');
      expect(result.getAIRawData('8005'), '112000');
      expect(result.getAIRawData('93'), 'Mdlr');
    });
    test('tobacco transport', () {
      final String barcode2 = '011460043993762021NH9X1JF1012940183';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode2,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '14600439937620');
      expect(result.getAIRawData('21'), 'NH9X1JF');
      expect(result.getAIRawData('10'), '12940183');
    });
    test('light industry', () {
      final String barcode3 =
          '010460780959150821sSBmxTYIFT(eq91FFD092testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode3,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04607809591508');
      expect(result.getAIRawData('21'), 'sSBmxTYIFT(eq');
      expect(result.getAIRawData('91'), 'FFD0');
      expect(result.getAIRawData('92'),
          'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest');
    });
    test('perfume', () {
      final String barcode4 =
          '010460780959133121e/Fw:xeo47NK291F01092Afwuf6d3c9oszbRy/Vb+hRUl1wokz/8UOthdpBYw9A0=';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode4,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04607809591331');
      expect(result.getAIRawData('21'), 'e/Fw:xeo47NK2');
      expect(result.getAIRawData('91'), 'F010');
      expect(
        result.getAIRawData('92'),
        'Afwuf6d3c9oszbRy/Vb+hRUl1wokz/8UOthdpBYw9A0=',
      );
    });
    test('shoes', () {
      final String barcode5 =
          '010406047769798721QkmvHY.+O5crD91809392Za6ZlkdG3zynfnllYpMQSrbZ7Gu+OKqJ9fCRZu+X5A7V7D7Th7ROcrRPbmLHpqV2BLI0YWuUTPYKadnk40Zjqw==';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode5,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04060477697987');
      expect(result.getAIRawData('21'), 'QkmvHY.+O5crD');
      expect(result.getAIRawData('91'), '8093');
      expect(
        result.getAIRawData('92'),
        'Za6ZlkdG3zynfnllYpMQSrbZ7Gu+OKqJ9fCRZu+X5A7V7D7Th7ROcrRPbmLHpqV2BLI0YWuUTPYKadnk40Zjqw==',
      );
    });
    test('photo', () {
      final String barcode6 =
          '010460780959145421m9tNPzJTWzuc9exC5/M+91EE0792vdIdf340vdN01ot+7YRyUb0XRbSQEAe4C4wjaAysm4M=';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode6,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04607809591454');
      expect(result.getAIRawData('21'), 'm9tNPzJTWzuc9exC5/M+');
      expect(result.getAIRawData('91'), 'EE07');
      expect(
        result.getAIRawData('92'),
        'vdIdf340vdN01ot+7YRyUb0XRbSQEAe4C4wjaAysm4M=',
      );
    });
    test('tiers', () {
      final String barcode7 =
          '0104607809591423215MGWI6OyoG3Jt91F01092xodkJv/PmhAHaiZBDNK8Kj83G4L4uPwDCoapvr28joY=';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode7,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04607809591423');
      expect(result.getAIRawData('21'), '5MGWI6OyoG3Jt');
      expect(result.getAIRawData('91'), 'F010');
      expect(
        result.getAIRawData('92'),
        'xodkJv/PmhAHaiZBDNK8Kj83G4L4uPwDCoapvr28joY=',
      );
    });
    test('meds', () {
      final String barcode7 =
          '010460714356059821FGXEAGA5A1GAH91EE0692VW/n3g0hYP6kqx1WjVy/fnpKT+i7N3FT8QPUyzzKQT4=';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode7,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04607143560598');
      expect(result.getAIRawData('21'), 'FGXEAGA5A1GAH');
      expect(result.getAIRawData('91'), 'EE06');
      expect(
        result.getAIRawData('92'),
        'VW/n3g0hYP6kqx1WjVy/fnpKT+i7N3FT8QPUyzzKQT4=',
      );
    });
    test('milk', () {
      final String barcode8 = '0103041094787443215Qbag!93Zjqw';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode8,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '03041094787443');
      expect(result.getAIRawData('21'), '5Qbag!');
      expect(result.getAIRawData('93'), 'Zjqw');
    });
    test('milk with weight', () {
      final String barcode10 = "0103041094787443215Qbag!93Zjqw3103000353";
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode10,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '03041094787443');
      expect(result.getAIRawData('21'), '5Qbag!');
      expect(result.getAIRawData('93'), 'Zjqw');
      expect(result.getAIRawData('3103'), '000353');
    });
    test('packaged water', () {
      final String barcode11 = "010463633245536021561BtxPs9VbAP93dGVz";
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode11,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04636332455360');
      expect(result.getAIRawData('21'), '561BtxPs9VbAP');
      expect(result.getAIRawData('93'), 'dGVz');
    });
    test('BAA', () {
      final String barcode12 = "0104260071832047215DKwJEavSWpj593dGVz";
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode12,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04260071832047');
      expect(result.getAIRawData('21'), '5DKwJEavSWpj5');
      expect(result.getAIRawData('93'), 'dGVz');
    });
    test('beer', () {
      final String barcode13 = "0104636332455339215qa5?WHJssbI-93dGVz";
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode13,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04636332455339');
      expect(result.getAIRawData('21'), '5qa5?WHJssbI-');
      expect(result.getAIRawData('93'), 'dGVz');
    });
    test('antiseptics', () {
      final String barcode14 = '0105015025322223215pE?s!Cbc0_MJ93dGVz';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode14,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '05015025322223');
      expect(result.getAIRawData('21'), '5pE?s!Cbc0_MJ');
      expect(result.getAIRawData('93'), 'dGVz');
    });
    test('bycycles', () {
      final String barcode15 =
          '0104640088090997215tjNZHkB"<jQY91FFD092dGVzdGgUDZKISuwvUUiqzzWuUNnBVJhvRbOxG2W2Tg8=';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode15,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04640088090997');
      expect(result.getAIRawData('21'), '5tjNZHkB"<jQY');
      expect(result.getAIRawData('91'), 'FFD0');
      expect(result.getAIRawData('92'),
          'dGVzdGgUDZKISuwvUUiqzzWuUNnBVJhvRbOxG2W2Tg8=');
    });
    test('wheelchairs', () {
      final String barcode16 =
          '0104640088091000215gMpn5CJG37mF91FFD092dGVzdOvwCHl95aQdMlRHin6E0crdgMSvg18oBi/wagQ=';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode16,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04640088091000');
      expect(result.getAIRawData('21'), '5gMpn5CJG37mF');
      expect(result.getAIRawData('91'), 'FFD0');
      expect(result.getAIRawData('92'),
          'dGVzdOvwCHl95aQdMlRHin6E0crdgMSvg18oBi/wagQ=');
    });
    test('canned fish,meat,vegetable and animal feed', () {
      final String barcode17 =
          '0104809011017511215abcde91A12392Test1234Test5678Test1234Test5678Test1234Test';
      final parser = GS1BarcodeParser.defaultParser();
      final result = parser.parse(
        barcode17,
      );
      expect(result.hasAI('21'), true);
      expect(result.getAIRawData('01'), '04809011017511');
      expect(result.getAIRawData('21'), '5abcde');
      expect(result.getAIRawData('91'), 'A123');
      expect(result.getAIRawData('92'),
          'Test1234Test5678Test1234Test5678Test1234Test');
    });
  });
}
