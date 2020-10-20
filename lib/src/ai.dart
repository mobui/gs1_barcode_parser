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

  static const _DATE_FIX_LENGTH = 6;

  final String code;
  final String dataTitle;
  final AIFormatType type;
  final int _fixLength;
  final String regExpString;
  final String description;

  const AI({
    this.code,
    this.dataTitle,
    this.type,
    int fixLength,
    this.regExpString = '',
    this.description,
  }) : _fixLength = fixLength;

  @override
  bool operator ==(Object other) => other is AI && other.code == code;

  @override
  int get hashCode => code.hashCode;

  RegExp get regExp => RegExp(regExpString);

  int get numberOfDecimalPlaces =>
      (code.length == 4) ? int.parse(code[3], radix: 10) : 0;

  int get fixLength {
    if (type == AIFormatType.FIXED_LENGTH) return _fixLength;
    if (type == AIFormatType.FIXED_LENGTH_MEASURE) return _fixLength;
    if (type == AIFormatType.DATE) return _DATE_FIX_LENGTH;
    return 0;
  }

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
    '15': const AI(
      code: '15',
      type: AIFormatType.DATE,
      dataTitle: 'BEST BEFORE or BEST BY',
      regExpString: r'^15(\d{6})$',
      description: 'Best before date (YYMMDD)',
    ),
    '16': const AI(
      code: '16',
      type: AIFormatType.DATE,
      dataTitle: 'SELL BY',
      regExpString: r'^16(\d{6})$',
      description: 'Sell by date (YYMMDD)',
    ),
    '17': const AI(
      code: '17',
      type: AIFormatType.DATE,
      dataTitle: 'USE BY OR EXPIRY',
      description: 'Expiration date (YYMMDD)',
      regExpString: r'^17(\d{6})$',
    ),
    '20': const AI(
      code: '16',
      type: AIFormatType.FIXED_LENGTH,
      dataTitle: 'VARIANT',
      regExpString: r'^20(\d{2})$',
      fixLength: 2,
      description: 'Internal product variant',
    ),
    '21': const AI(
      code: '21',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'SERIAL',
      regExpString: '^21($_ALLOW_CHAR{0,20})\$',
      description: 'Serial number',
    ),
    '22': const AI(
      code: '22',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'CPV',
      regExpString: '^22($_ALLOW_CHAR{0,20})\$',
      description: 'Consumer product variant',
    ),
    '235': const AI(
      code: '235',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'TPX',
      regExpString: '^235($_ALLOW_CHAR{0,28})\$',
      description: 'Third Party Controlled, Serialised Extension of GTIN (TPX)',
    ),
    '240': const AI(
      code: '240',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'ADDITIONAL ID',
      regExpString: '^240($_ALLOW_CHAR{0,30})\$',
      description:
          'Additional product identification assigned by the manufacturer',
    ),
    '241': const AI(
      code: '241',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'CUST. PART NO.',
      regExpString: '^241($_ALLOW_CHAR{0,30})\$',
      description: 'Customer part number',
    ),
    '242': const AI(
      code: '242',
      type: AIFormatType.VARIABLE_LENGTH_MEASURE,
      dataTitle: 'MTO VARIANT',
      regExpString: r'^242(\d{0,6})$',
      description: 'Made-to-Order variation number',
    ),
    '243': const AI(
      code: '243',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'PCN',
      regExpString: '^243($_ALLOW_CHAR{0,20})\$',
      description: 'Packaging component number',
    ),
    '250': const AI(
      code: '250',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'SECONDARY SERIAL',
      regExpString: '^250($_ALLOW_CHAR{0,30})\$',
      description: 'Secondary serial number',
    ),
    '251': const AI(
      code: '251',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'REF. TO SOURCE',
      regExpString: '^251($_ALLOW_CHAR{0,30})\$',
      description: 'Reference to source entity',
    ),
    '253': const AI(
      code: '253',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'GDTI',
      regExpString: '^253(\\d{13})($_ALLOW_CHAR{0,17})\$',
      description: 'Global Document Type Identifier (GDTI)',
    ),
    '254': const AI(
      code: '254',
      type: AIFormatType.VARIABLE_LENGTH,
      dataTitle: 'GLN EXTENSION COMPONENT',
      regExpString: '^254($_ALLOW_CHAR{0,20})\$',
      description: 'GLN extension component',
    ),
    '255': const AI(
      code: '253',
      type: AIFormatType.VARIABLE_LENGTH_MEASURE,
      dataTitle: '255',
      regExpString: r'^255(\d{13})(\d{0,12})$',
      description: 'Global Coupon Number (GCN)',
    ),
    '30': const AI(
      code: '30',
      type: AIFormatType.VARIABLE_LENGTH_MEASURE,
      dataTitle: 'VAR. COUNT',
      regExpString: r'^242(\d{0,6})$',
      description: 'Variable count of items (variable measure trade item)',
    ),
    '3100': const AI(
        code: '3100',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (kg)',
        description: 'Net weight, kilograms (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3100(\d{6})$'),
    '3101': const AI(
        code: '3101',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (kg)',
        description: 'Net weight, kilograms (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3101(\d{6})$'),
    '3102': const AI(
        code: '3102',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (kg)',
        description: 'Net weight, kilograms (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3102(\d{6})$'),
    '3103': const AI(
        code: '3103',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (kg)',
        description: 'Net weight, kilograms (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3103(\d{6})$'),
    '3104': const AI(
        code: '3104',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (kg)',
        description: 'Net weight, kilograms (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3104(\d{6})$'),
    '3105': const AI(
        code: '3105',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (kg)',
        description: 'Net weight, kilograms (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3105(\d{6})$'),
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
    '3933': const AI(
        code: '3933',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_NUMBERS,
        dataTitle: 'PRICE',
        description:
            'Applicable amount payable with ISO currency code (variable measure trade item)',
        regExpString: r'^3933(\d{3})(\d{0,15})$'),
    '421': const AI(
        code: '421',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_CHARS,
        dataTitle: 'SHIP TO POST',
        description: 'Ship to / Deliver to postal code with ISO country code',
        regExpString: '^421(\\d{3})($_ALLOW_CHAR{0,9})\$'),
    '423': const AI(
        code: '423',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_NUMBERS,
        dataTitle: 'COUNTRY - INITIAL PROCESS.',
        description: 'Country of initial processing',
        regExpString: r'^423(\d{3})(\d{0,12})$'),
  };
}
