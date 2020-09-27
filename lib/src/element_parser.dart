import 'package:gs1_barcode_parser/src/ai.dart';
import 'package:gs1_barcode_parser/src/barcode_parser.dart';

import 'exception.dart';

class ParsedElementWithRest {
  final GS1ParsedElement element;
  final String rest;

  const ParsedElementWithRest({
    this.element,
    this.rest,
  });
}

abstract class GS1ElementParser {
  ParsedElementWithRest call(String data, AI ai);

  bool verify(String elementData, AI ai) {
    return ai.regExp.hasMatch(ai.ai + elementData);
  }
}

class GS1ElementFixLengthParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(String data, AI ai) {
    final offset = ai.ai.length + ai.length;

    if (data.length < offset) {
      throw GS1ParseException(
          message: 'Unexpected end of data for AI ${ai.ai}');
    }
    if (!data.startsWith(ai.ai)) {
      throw GS1ParseException(message: 'Data and AI mismatch for AI ${ai.ai}');
    }

    final elementData = data.substring(ai.ai.length, offset);

    if (!verify(elementData, ai)) {
      throw GS1ParseException(
          message: 'Data format mismatch ${ai.regExp} for AI ${ai.ai}');
    }

    final element = GS1ParsedElement<String>(
        ai: ai.ai, aiTitle: ai.dataTitle, data: elementData);

    final rest = data.substring(element.ai.length + element.data.length);
    return ParsedElementWithRest(element: element, rest: rest);
  }
}

class GS1VariableLengthParser extends GS1ElementParser {
  @override
  ParsedElementWithRest call(String data, AI ai) {
    final posOfGS = data.indexOf(GS1BarcodeParser.DEFAULT_GROUP_SEPARATOR);
    if (posOfGS == -1) {
      return ParsedElementWithRest(
          element: GS1ParsedElement<String>(
              ai: ai.ai,
              aiTitle: ai.dataTitle,
              data: data.substring(ai.ai.length)),
          rest: '');
    } else {
      return ParsedElementWithRest(
          element: GS1ParsedElement<String>(
              ai: ai.ai,
              aiTitle: ai.dataTitle,
              data: data.substring(ai.ai.length, posOfGS)),
          rest: data.substring(posOfGS + 1));
    }
  }
}
