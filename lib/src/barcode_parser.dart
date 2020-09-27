import 'ai.dart';
import 'code.dart';
import 'code_parser.dart';
import 'element_parser.dart';
import 'exception.dart';

class GS1BarcodeParserConfig {
  static const DEFAULT_GROUP_SEPARATOR = '\u{001d}';
  static const DEFAULT_FNC1 = "\u{00e8}";
  final bool allowEmptyPrefix;
  final String groupSeparator;

  GS1BarcodeParserConfig({
    this.allowEmptyPrefix = false,
    this.groupSeparator = DEFAULT_GROUP_SEPARATOR,
  });
}

class GS1BarcodeParser {
  final Map<AIFormatType, GS1ElementParser> _elementParsers;

  final GS1CodeParser _codeParser;

  final GS1BarcodeParserConfig _config;

  GS1BarcodeParser._({
    GS1BarcodeParserConfig config,
    GS1CodeParser codeParser,
    Map<AIFormatType, GS1ElementParser> elementParsers,
  })  : assert(elementParsers != null),
        assert(codeParser != null),
        assert(config != null),
        _config = config,
        _elementParsers = elementParsers,
        _codeParser = codeParser;

  factory GS1BarcodeParser.defaultParser() {
    return GS1BarcodeParser.configurableParser(GS1BarcodeParserConfig());
  }

  factory GS1BarcodeParser.configurableParser(GS1BarcodeParserConfig config) {
    final elementParsers = {
      AIFormatType.DATE: GS1DateParser(),
      AIFormatType.FIXED_LENGTH: GS1ElementFixLengthParser(),
      AIFormatType.FIXED_LENGTH_MEASURE: GS1ElementFixLengthMeasureParser(),
      AIFormatType.VARIABLE_LENGTH: GS1VariableLengthParser(),
      AIFormatType.VARIABLE_LENGTH_WITH_ISO_NUMBERS:
          GS1VariableLengthWithISONumbersParser(),
      AIFormatType.VARIABLE_LENGTH_MEASURE: GS1VariableLengthMeasureParser(),
      AIFormatType.VARIABLE_LENGTH_WITH_ISO_CHARS:
          GS1VariableLengthWithISOCharsParser(),
    };
    final codeParser = GS1PrefixCodeParser();

    return GS1BarcodeParser._(
      config: config,
      codeParser: codeParser,
      elementParsers: elementParsers,
    );
  }

  GS1Barcode parse(String data) {
    if (data.isEmpty) {
      GS1DataException(message: 'Barcode is empty');
    }

    final codeWithRest = _codeParser(data);
    if (codeWithRest.code.type == CodeType.UNDEFINED &&
        !_config.allowEmptyPrefix) {
      throw GS1DataException(message: 'FNC1 prefix not found');
    }

    String restOfBarcode = codeWithRest.rest;

    if (restOfBarcode.isEmpty) {
      throw GS1DataException(message: 'No date present');
    }

    final elements = <String, GS1ParsedElement>{};

    while (restOfBarcode.length > 0) {
      final res = _identifyAI(restOfBarcode);
      elements.putIfAbsent(res.element.aiCode, () => res.element);
      restOfBarcode = res.rest;
    }

    return GS1Barcode(
      code: codeWithRest.code,
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
      throw GS1ParseException(message: 'AI not found for $data');
    }
    return _elementParsers[ai.type](data, ai, _config);
  }
}

class GS1ParsedElement<T> {
  final String aiCode;
  final String iso;
  final T data;
  final String rawData;

  const GS1ParsedElement({
    this.aiCode,
    this.iso = '',
    this.rawData,
    this.data,
  });
}

class GS1Barcode {
  final Code code;
  final Map<String, GS1ParsedElement> elements;

  const GS1Barcode({
    this.code,
    this.elements,
  });

  List<String> get AIs => elements.keys;

  bool hasAI(String ai) => elements.containsKey(ai);

  dynamic getAIData(String ai) => elements[ai].data;

  String getAIRawData(String ai) => elements[ai].rawData;

  GS1ParsedElement getAIParsedElement(String ai) => elements[ai];

  Map<String, dynamic> get getAIsData => elements.values.fold(
      {},
      (previousValue, element) =>
          previousValue..putIfAbsent(element.aiCode, () => element.data));

  Map<String, GS1ParsedElement> get getAIsParsedElement =>
      elements.values.fold<Map<String, GS1ParsedElement>>(
          {},
          (previousValue, element) =>
              previousValue..putIfAbsent(element.aiCode, () => element));

  Map<String, String> get getAIsRawData =>
      elements.values.fold<Map<String, String>>(
          {},
          (previousValue, element) => previousValue
            ..putIfAbsent(element.aiCode, () => element.rawData));

  @override
  String toString() {
    final elem = elements.entries.fold(
        '',
        (previousValue, element) =>
            previousValue +
            '${element.key} (${AI.AIS[element.key].dataTitle}): ${element.value.data},\n');
    return 'code = ${code.codeTitle},\ndata = {\n$elem}';
  }
}
