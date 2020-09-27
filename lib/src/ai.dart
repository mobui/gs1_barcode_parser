enum AIFormatType {
  FIXED_LENGTH,
  VARIABLE_LENGTH,
  VARIABLE_LENGTH_WITH_ISO_NUMBERS,
  VARIABLE_LENGTH_WITH_ISO_CHARS,
  FIXED_LENGTH_MEASURE,
  VARIABLE_LENGTH_MEASURE,
  DATE,
}

/// Application Identifier see https://www.gs1.org/standards/barcodes/application-identifiers?lang=en
class AI {
  static const _ALLOW_CHAR =
      '[\u{0021}-\u{0022}\u{0025}-\u{002f}\u{0030}-\u{0039}\u{003a}-\u{003f}\u{0041}-\u{005a}\u{005f}\u{0061}-\u{007a}]';

  final String code;
  final String dataTitle;
  final AIFormatType type;
  final int fixLength;
  final String regExpString;
  final String description;

  const AI({
    this.code,
    this.dataTitle,
    this.type,
    this.fixLength = 0,
    this.regExpString = '',
    this.description,
  });

  @override
  bool operator ==(Object other) => other is AI && other.code == code;

  @override
  int get hashCode => code.hashCode;

  RegExp get regExp => RegExp(regExpString);

  int get numberOfDecimalPlaces =>
      (code.length == 4) ? int.parse(code[3], radix: 10) : 0;

  static final Map<String, AI> AIS = {
    '00': const AI(
      code: '00',
      fixLength: 18,
      type: AIFormatType.FIXED_LENGTH,
      description: 'Serial Shipping Container Code (SSCC)',
      dataTitle: 'SSCC',
      regExpString: r'^00(\d{18})$',
    ),
    '01': const AI(
      code: '01',
      fixLength: 14,
      type: AIFormatType.FIXED_LENGTH,
      dataTitle: 'GTIN',
      regExpString: r'^01(\d{14})$',
      description: 'Global Trade Item Number (GTIN)',
    ),
    '02': const AI(
      code: '02',
      fixLength: 14,
      type: AIFormatType.FIXED_LENGTH,
      dataTitle: 'CONTENT',
      description: 'GTIN of contained trade items',
      regExpString: r'^02(\d{14})$',
    ),
    '10': const AI(
      code: '10',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'BATCH/LOT',
      regExpString: '^10($_ALLOW_CHAR{0,20})\$',
      description: 'Batch or lot number',
    ),
    '11': const AI(
      code: '11',
      type: AIFormatType.DATE,
      dataTitle: 'PROD DATE',
      regExpString: r'^11(\d{6})$',
      description: 'Production date (YYMMDD)',
    ),
    '12': const AI(
      code: '12',
      type: AIFormatType.DATE,
      dataTitle: 'DUE DATE',
      regExpString: r'^12(\d{6})$',
      description: 'Due date (YYMMDD)',
    ),
    '13': const AI(
      code: '13',
      type: AIFormatType.DATE,
      dataTitle: 'PACK DATE',
      regExpString: r'^13(\d{6})$',
      description: 'Packaging date (YYMMDD)',
    ),
    '17': const AI(
      code: '17',
      type: AIFormatType.DATE,
      dataTitle: 'USE BY OR EXPIRY',
      description: 'Expiration date (YYMMDD)',
      fixLength: 6,
      regExpString: r'^17(\d{6})$',
    ),
    '3103': const AI(
        code: '3103',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (kg)',
        description: 'Net weight, kilograms (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3103(\d{6})$'),
    '3922': const AI(
        code: '3922',
        type: AIFormatType.VARIABLE_LENGTH_MEASURE,
        dataTitle: 'PRICE',
        description:
            'Applicable amount payable, single monetary area (variable measure trade item)',
        regExpString: r'^3922(\d{0,15})$'),
    '3932': const AI(
        code: '3932',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_NUMBERS,
        dataTitle: 'PRICE',
        description:
            'Applicable amount payable with ISO currency code (variable measure trade item)',
        regExpString: r'^3932(\d{3})(\d{0,15})$'),
    '421': const AI(
        code: '421',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_CHARS,
        dataTitle: 'SHIP TO POST',
        description: 'Ship to / Deliver to postal code with ISO country code',
        regExpString: '^421(\\d{3})($_ALLOW_CHAR{0,9})\$'),
  };
}
