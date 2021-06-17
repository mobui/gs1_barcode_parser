import 'package:gs1_barcode_parser/src/code.dart';

class CodeWithRest {
  final Code code;
  final String rest;

  const CodeWithRest({
    required this.code,
    required this.rest,
  });
}

abstract class GS1CodeParser {
  CodeWithRest call(String data);
}

class GS1PrefixCodeParser implements GS1CodeParser {
  @override
  CodeWithRest call(String data) {
    var code = Code.CODES.values.firstWhere(
        (element) => data.startsWith(element.fnc1),
        orElse: () => Code.UNDEFINED_CODE);

    return CodeWithRest(
      rest: data.substring(code.fnc1.length),
      code: code,
    );
  }
}
