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

    final elements = <AI, GS1ParsedElement>{};

    while (restOfBarcode.length > 0) {
      final res = _identifyAI(restOfBarcode);
      elements.putIfAbsent(AI.AIS[res.element.aiCode], () => res.element);
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
  final Map<AI, GS1ParsedElement> elements;

  const GS1Barcode({
    this.code,
    this.elements,
  });

  List<String> get AIs => elements.keys.map((e) => e.code).toList();

  bool hasAI(String ai) => elements.keys.map((e) => e.code).contains(ai);

  dynamic getAIData(String ai) => elements.values
      .firstWhere((element) => element.aiCode == ai, orElse: null)
      ?.data;

  String getAIRawData(String ai) => elements.values
      .firstWhere((element) => element.aiCode == ai, orElse: null)
      ?.rawData;

  GS1ParsedElement getAIDataAsParsedElement(String ai) => elements.values
      .firstWhere((element) => element.aiCode == ai, orElse: null);

  Map<String, dynamic> get getAIsData => elements.values.fold(
      {},
      (previousValue, element) =>
          previousValue.putIfAbsent(element.aiCode, () => element.data));

  Map<String, GS1ParsedElement> get getAIsDataAsParsedElement =>
      elements.values.fold<Map<String, GS1ParsedElement>>(
          {},
          (previousValue, element) =>
              previousValue..putIfAbsent(element.aiCode, () => element));

  Map<String, dynamic> get getAIsRawData => elements.values.fold(
      {},
      (previousValue, element) =>
          previousValue.putIfAbsent(element.aiCode, () => element.rawData));

  @override
  String toString() {
    final elem = elements.entries.fold(
        '',
        (previousValue, element) =>
            previousValue +
            '${element.key.code} (${element.key.dataTitle}): ${element.value.data},\n');
    return 'code = ${code.codeTitle},\ndata = {\n$elem}';
  }
}
