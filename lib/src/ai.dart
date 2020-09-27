enum AIFormatType {
  FIXED_LENGTH,
  VARIABLE_LENGTH,
  VARIABLE_LENGTH_WITH_ISO_NUMBERS,
  FIXED_LENGTH_MEASURE,
  VARIABLE_LENGTH_MEASURE,
  DATE,
}

/// Application Identifier see https://www.gs1.org/standards/barcodes/application-identifiers?lang=en
class AI {
  final String ai;
  final String dataTitle;
  final AIFormatType type;
  final int length;
  final bool requiredFNC1;
  final String regExpString;
  final String description;

  const AI({
    this.ai,
    this.dataTitle,
    this.type,
    this.length = 0,
    this.requiredFNC1,
    this.regExpString = '',
    this.description,
  });

  RegExp get regExp => RegExp(r'^' + ai + r'(' + regExpString + r')$');

  static final Map<String, AI> AIS = {
    '00': const AI(
      ai: '00',
      length: 18,
      type: AIFormatType.FIXED_LENGTH,
      description: 'Serial Shipping Container Code (SSCC)',
      dataTitle: 'SSCC',
      regExpString: r'\d{18}',
      requiredFNC1: false,
    ),
    '01': const AI(
      ai: '01',
      length: 14,
      type: AIFormatType.FIXED_LENGTH,
      dataTitle: 'GTIN',
      regExpString: r'\d{14}',
      description: 'Global Trade Item Number (GTIN)',
    ),
    '02': const AI(
      ai: '02',
      length: 14,
      type: AIFormatType.FIXED_LENGTH,
      dataTitle: 'CONTENT',
    ),
    '10': const AI(
      ai: '10',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'BATCH/LOT',
    )
  };
}
