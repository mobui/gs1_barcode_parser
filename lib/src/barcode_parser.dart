import 'ai.dart';
import 'code.dart';
import 'code_parser.dart';
import 'element_parser.dart';
import 'exception.dart';

class GS1BarcodeParserConfig {
  static const DEFAULT_GROUP_SEPARATOR = '\u{001d}';
  static const DEFAULT_FNC1 = "\u{00e8}";

  /// Allow empty prefix for barcode see [Code]
  final bool allowEmptyPrefix;

  /// Group separator. Default 0xE8
  final String groupSeparator;

  GS1BarcodeParserConfig({
    this.allowEmptyPrefix = true,
    this.groupSeparator = DEFAULT_GROUP_SEPARATOR,
  });
}

class GS1BarcodeParser {
  final Map<AIFormatType, GS1ElementParser> _elementParsers;

  final GS1CodeParser _codeParser;

  final GS1BarcodeParserConfig _config;

  GS1BarcodeParser._({
    required GS1BarcodeParserConfig config,
    required GS1CodeParser codeParser,
    required Map<AIFormatType, GS1ElementParser> elementParsers,
  })  : _config = config,
        _elementParsers = elementParsers,
        _codeParser = codeParser;

  /// Create parser with default config
  factory GS1BarcodeParser.defaultParser() {
    return GS1BarcodeParser.configurableParser(GS1BarcodeParserConfig());
  }

  /// Create parser with custom config
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

  /// Parse barcode string
  GS1Barcode parse(String data, {CodeType? codeType}) {
    if (data.isEmpty) {
      GS1DataException(message: 'Barcode is empty');
    }

    final codeWithRest = _codeParser(
      _normalize(data, codeType: codeType),
    );
    if (codeWithRest.code.type == CodeType.UNDEFINED &&
        !_config.allowEmptyPrefix) {
      throw GS1DataException(message: 'FNC1 prefix not found');
    }

    String restOfBarcode = codeWithRest.rest;

    if (restOfBarcode.isEmpty) {
      throw GS1DataException(message: 'No date present');
    }

    final elements = <String, GS1ParsedElement>{};

    while (restOfBarcode.isNotEmpty) {
      final res = _identifyAI(restOfBarcode);
      elements.putIfAbsent(res.element.aiCode, () => res.element);
      restOfBarcode = res.rest;
    }

    return GS1Barcode(
      code: codeWithRest.code,
      elements: elements,
    );
  }

  /// Get ans parse AI
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

    final parser = _elementParsers[ai.type];
    if (parser == null) {
      throw GS1ParseException(
          message: 'Parser not found for $data [ai:${ai.type}]');
    }
    return parser(data, ai, _config);
  }

  /// Delete control characters in start of data
  String _normalize(String data, {CodeType? codeType}) {
    String result = data;
    while (result.startsWith(GS1BarcodeParserConfig.DEFAULT_GROUP_SEPARATOR) ||
        result.startsWith(GS1BarcodeParserConfig.DEFAULT_FNC1)) {
      result = result.substring(1);
    }
    if (codeType == null) {
      return result;
    } else {
      final fnc1 = Code.CODES[codeType]?.fnc1;
      if (fnc1 == null) {
        throw GS1ParseException(
            message: 'FNC1 not found for $data and codeType: $codeType');
      }
      return fnc1 + result;
    }
  }
}

class GS1ParsedElement<T> {
  /// AI code
  final String aiCode;

  /// ISO data (currency, country)
  final String iso;

  /// parsed data element
  final T data;

  /// raw data element
  final String rawData;

  const GS1ParsedElement({
    required this.aiCode,
    this.iso = '',
    required this.rawData,
    required this.data,
  });
}

class GS1Barcode {
  /// Barcode description
  final Code code;

  /// Map of parsed AI elements. Key - AI string, value - parsed element
  final Map<String, GS1ParsedElement> elements;

  const GS1Barcode({
    required this.code,
    required this.elements,
  });

  /// Get available AIs
  Iterable<String> get AIs => elements.keys;

  /// Checking for availability AI
  bool hasAI(String ai) => elements.containsKey(ai);

  /// Get parser AI element data
  dynamic getAIData(String ai) => elements[ai]?.data;

  /// Get raw AI element data
  String? getAIRawData(String ai) => elements[ai]?.rawData;

  /// Get AI element
  GS1ParsedElement? getAIParsedElement(String ai) => elements[ai];

  /// Get all parsed AI elements data
  Map<String, dynamic> get getAIsData => elements.values.fold(
      {},
      (previousValue, element) =>
          previousValue..putIfAbsent(element.aiCode, () => element.data));

  /// Get all AI elements
  Map<String, GS1ParsedElement> get getAIsParsedElement =>
      elements.values.fold<Map<String, GS1ParsedElement>>(
          {},
          (previousValue, element) =>
              previousValue..putIfAbsent(element.aiCode, () => element));

  /// Get all raw AI elements data
  Map<String, String> get getAIsRawData =>
      elements.values.fold<Map<String, String>>(
          {},
          (previousValue, element) => previousValue
            ..putIfAbsent(element.aiCode, () => element.rawData));

  @override
  String toString() {
    final elem = elements.entries.fold(
        '',
        (String previousValue, element) =>
            previousValue +
            '${element.key} (${AI.AIS[element.key]!.dataTitle}): ${element.value.data},\n');
    return 'code = ${code.codeTitle},\ndata = {\n$elem}';
  }
}
