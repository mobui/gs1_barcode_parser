import 'dart:math';

import 'package:gs1_barcode_parser/src/ai.dart';
import 'package:gs1_barcode_parser/src/barcode_parser.dart';

import 'exception.dart';

class ParsedElementWithRest {
  final GS1ParsedElement element;
  final String rest;

  const ParsedElementWithRest({
    required this.element,
    required this.rest,
  });
}

abstract class GS1ElementParser {
  ParsedElementWithRest call(String data, AI ai, GS1BarcodeParserConfig config);

  bool verify(String elementData, AI ai) {
    return ai.regExp.hasMatch(elementData);
  }

  double parseFloatingPoint(String numberPart, int numberOfDecimals) {
    final offset = numberPart.length - numberOfDecimals;
    final numberPartFloat =
        numberPart.substring(0, offset) + '.' + numberPart.substring(offset);
    return double.parse(numberPartFloat);
  }

  String getRest(String data, int offset, GS1BarcodeParserConfig config) {
    var result = data.length < offset ? '' : data.substring(offset);
    while (result.startsWith(config.groupSeparator)) {
      result = result.substring(1);
    }
    return result;
  }
}

class GS1DateParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(
      String data, AI ai, GS1BarcodeParserConfig config) {
    final offset = ai.code.length + ai.fixLength;
    final elementStr = data.substring(0, min(offset, data.length));

    if (!verify(elementStr, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.code}');
    }

    final elementDate = elementStr.substring(ai.code.length);
    var year = _year2ToYear4(int.parse(elementDate.substring(0, 2), radix: 10));
    final month = int.parse(elementDate.substring(2, 4), radix: 10);
    final day = int.parse(elementDate.substring(4), radix: 10);

    final element = GS1ParsedElement<DateTime>(
      rawData: elementDate,
      aiCode: ai.code,
      data: DateTime(year, month, day),
    );

    final rest = getRest(data, offset, config);
    return ParsedElementWithRest(element: element, rest: rest);
  }

  _year2ToYear4(int year) {
    return year > 50 ? year + 1900 : year = year + 2000;
  }
}

class GS1ElementFixLengthParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(
      String data, AI ai, GS1BarcodeParserConfig config) {
    final offset = ai.code.length + ai.fixLength;

    final elementStr = data.substring(0, min(offset, data.length));

    if (!verify(elementStr, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.code}');
    }
    final elementValue = elementStr.substring(ai.code.length);

    final element = GS1ParsedElement<String>(
      rawData: elementValue,
      aiCode: ai.code,
      data: elementValue,
    );
    final rest = getRest(data, offset, config);

    return ParsedElementWithRest(element: element, rest: rest);
  }
}

class GS1ElementFixLengthMeasureParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(
      String data, AI ai, GS1BarcodeParserConfig config) {
    final offset = ai.code.length + ai.fixLength;

    final elementStr = data.substring(0, min(offset, data.length));

    if (!verify(elementStr, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.code}');
    }

    final elementValue = elementStr.substring(ai.code.length);

    final element = GS1ParsedElement<double>(
        rawData: elementValue,
        aiCode: ai.code,
        data: parseFloatingPoint(elementValue, ai.numberOfDecimalPlaces));
    final rest = getRest(data, offset, config);

    return ParsedElementWithRest(element: element, rest: rest);
  }
}

class GS1VariableLengthParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(
      String data, AI ai, GS1BarcodeParserConfig config) {
    final posOfGS = data.indexOf(config.groupSeparator);
    final offset = posOfGS == -1 ? data.length : posOfGS;
    final elementStr = data.substring(0, offset);

    if (!verify(elementStr, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.code}');
    }

    final elementValue = elementStr.substring(ai.code.length);

    final element = GS1ParsedElement<String>(
      aiCode: ai.code,
      rawData: elementValue,
      data: elementValue,
    );
    final rest = getRest(data, offset, config);

    return ParsedElementWithRest(
      element: element,
      rest: rest,
    );
  }
}

class GS1VariableLengthMeasureParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(
      String data, AI ai, GS1BarcodeParserConfig config) {
    final posOfGS = data.indexOf(config.groupSeparator);
    final offset = posOfGS == -1 ? data.length : posOfGS;
    final elementStr = data.substring(0, offset);

    if (!verify(elementStr, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.code}');
    }

    final numberPart = data.substring(ai.code.length, offset);
    final rest = getRest(data, offset, config);
    final element = GS1ParsedElement<double>(
        rawData: numberPart,
        aiCode: ai.code,
        data: parseFloatingPoint(numberPart, ai.numberOfDecimalPlaces));
    return ParsedElementWithRest(element: element, rest: rest);
  }
}

class GS1VariableLengthWithISONumbersParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(
      String data, AI ai, GS1BarcodeParserConfig config) {
    final posOfGS = data.indexOf(config.groupSeparator);
    final offset = posOfGS == -1 ? data.length : posOfGS;
    final elementStr = data.substring(0, offset);

    if (!verify(elementStr, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.code}');
    }

    final numberPart = elementStr.substring(ai.code.length + 3);
    final isoPart = elementStr.substring(ai.code.length, ai.code.length + 3);

    final rest = getRest(data, offset, config);
    final element = GS1ParsedElement<double>(
        rawData: elementStr.substring(ai.code.length),
        aiCode: ai.code,
        iso: isoPart,
        data: parseFloatingPoint(numberPart, ai.numberOfDecimalPlaces));

    return ParsedElementWithRest(element: element, rest: rest);
  }
}

class GS1VariableLengthWithISOCharsParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(
      String data, AI ai, GS1BarcodeParserConfig config) {
    final posOfGS = data.indexOf(config.groupSeparator);
    final offset = posOfGS == -1 ? data.length : posOfGS;
    final elementStr = data.substring(0, offset);

    if (!verify(elementStr, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.code}');
    }

    final charPart = elementStr.substring(ai.code.length + 3);
    final isoPart = elementStr.substring(ai.code.length, ai.code.length + 3);

    final rest = getRest(data, offset, config);
    final element = GS1ParsedElement<String>(
      rawData: elementStr.substring(ai.code.length),
      aiCode: ai.code,
      iso: isoPart,
      data: charPart,
    );

    return ParsedElementWithRest(element: element, rest: rest);
  }
}
