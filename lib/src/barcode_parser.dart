import 'ai.dart';
import 'code.dart';
import 'code_parser.dart';
import 'element_parser.dart';
import 'exception.dart';

class GS1BarcodeParser {
  static final DEFAULT_GROUP_SEPARATOR = "\u{001d}";
  static final DEFAULT_FNC1 = "\u{00e8}";

  final bool _allowEmptyPrefix;

  final Map<AIFormatType, GS1ElementParser> _elementParsers;

  final GS1CodeParser _codeParser;

  GS1BarcodeParser._({
    bool allowEmptyPrefix,
    GS1CodeParser codeParser,
    Map<AIFormatType, GS1ElementParser> elementParsers,
  })  : assert(elementParsers != null),
        assert(codeParser != null),
        _allowEmptyPrefix = allowEmptyPrefix,
        _elementParsers = elementParsers,
        _codeParser = codeParser;

  factory GS1BarcodeParser.byDefault({bool allowEmptyPrefix = false}) {
    return GS1BarcodeParser._(
        allowEmptyPrefix: allowEmptyPrefix,
        codeParser: GS1PrefixCodeParser(),
        elementParsers: {
          AIFormatType.FIXED_LENGTH: GS1ElementFixLengthParser(),
          AIFormatType.VARIABLE_LENGTH: GS1VariableLengthParser(),
        });
  }

  factory GS1BarcodeParser.byDefaultWithAllowEmptyPrefix() {
    return GS1BarcodeParser.byDefault(allowEmptyPrefix: true);
  }

  GS1Barcode parse(String data) {
    if (data.isEmpty) {
      GS1DataException(message: 'Barcode is empty');
    }

    final codeWithRest = _codeParser(data);
    if (codeWithRest.code.type == CodeType.UNDEFINED && !_allowEmptyPrefix) {
      throw GS1DataException(message: 'FNC1 prefix not found');
    }

    String restOfBarcode = codeWithRest.rest;

    if (restOfBarcode.isEmpty) {
      throw GS1DataException(message: 'No date present');
    }

    final elements = <String, GS1ParsedElement>{};

    while (restOfBarcode.length > 0) {
      final res = _identifyAI(restOfBarcode);
      elements.putIfAbsent(res.element.ai, () => res.element);
      restOfBarcode = res.rest;
    }

    return GS1Barcode(
      codeName: codeWithRest.code.codeTitle,
      elements: elements,
    );
  }

  ParsedElementWithRest _identifyAI(String data) {
    final twoNumber = data.substring(0, 2);
    var ai = AI.AIS[twoNumber];

    if (ai == null) {
      final threeNumber = data.substring(0, 3);
      ai = AI.AIS[threeNumber];
    }
    if (ai == null) {
      final fourNumber = data.substring(0, 4);
      ai = AI.AIS[fourNumber];
    }
    if (ai == null) {
      throw GS1ParseException(message: 'AI not found');
    }
    return _elementParsers[ai.type](data, ai);
  }
}

class GS1ParsedElement<T> {
  final String ai;
  final String aiTitle;
  final String unit;
  final T data;

  const GS1ParsedElement({
    this.ai,
    this.aiTitle,
    this.unit = '',
    this.data,
  });
}

class GS1Barcode {
  final String codeName;
  final Map<String, GS1ParsedElement> elements;

  const GS1Barcode({
    this.codeName,
    this.elements,
  });
}
