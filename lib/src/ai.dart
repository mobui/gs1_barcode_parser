enum AIFormatType {
  FIXED_LENGTH,
  VARIABLE_LENGTH,
  VARIABLE_LENGTH_WITH_ISO_NUMBERS,
  VARIABLE_LENGTH_WITH_ISO_CHARS,
  FIXED_LENGTH_MEASURE,
  VARIABLE_LENGTH_MEASURE,
  DATE,
}

/// Application Identifier
/// GS1 Application Identifiers (AIs) are prefixes used in barcodes and EPC/RFID-tags
/// to define the meaning and format of data attributes. This tool was developed
/// in response to the growing use of AIs in the various industry sectors to
/// include product data beyond the GTIN, such as the batch/lot number, serial number,
/// best before date and expiration date. It also allows users, solution providers and
/// GS1 Member Organisations to easily view, search and share details about individual
/// Application Identifiers through web-browsers or on a mobile device.
/// see https://www.gs1.org/standards/barcodes/application-identifiers?lang=en
class AI {
  static const _ALLOW_CHAR =
      '[\u{0021}-\u{0022}\u{0025}-\u{002f}\u{0030}-\u{0039}\u{003a}-\u{003f}\u{0041}-\u{005a}\u{005f}\u{0061}-\u{007a}]';

  static const _DATE_FIX_LENGTH = 6;

  final String _code;

  final String _dataTitle;

  final AIFormatType _type;

  final int _fixLength;
  final String _regExpString;
  final String _description;

  const AI({
    String code,
    String dataTitle,
    AIFormatType type,
    int fixLength,
    String regExpString,
    String description,
  }) : _fixLength = fixLength, _code = code, _dataTitle = dataTitle, _type = type, _regExpString = regExpString, _description = description;

  @override
  bool operator ==(Object other) => other is AI && other.code == code;

  @override
  int get hashCode => code.hashCode;

  /// AI Code
  String get code => _code;

  /// AI data title
  String get dataTitle => _dataTitle;

  /// AI data description
  String get description => _description;

  /// AI format type
  AIFormatType get type => _type;

  /// Regular expression
  RegExp get regExp => RegExp(_regExpString);

  /// Number of places for decimal element (for other is 0)
  int get numberOfDecimalPlaces =>
      (code.length == 4) ? int.parse(code[3], radix: 10) : 0;

  /// Length for AI with fixed length (for other is 0)
  int get fixLength {
    if (type == AIFormatType.FIXED_LENGTH) return _fixLength;
    if (type == AIFormatType.FIXED_LENGTH_MEASURE) return _fixLength;
    if (type == AIFormatType.DATE) return _DATE_FIX_LENGTH;
    return 0;
  }

  /// AIs List
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
    '3110': const AI(
        code: '3110',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m)',
        description:
            'Length or first dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3110(\d{6})$'),
    '3111': const AI(
        code: '3111',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m)',
        description:
            'Length or first dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3111(\d{6})$'),
    '3112': const AI(
        code: '3112',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m)',
        description:
            'Length or first dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3112(\d{6})$'),
    '3113': const AI(
        code: '3113',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m)',
        description:
            'Length or first dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3113(\d{6})$'),
    '3114': const AI(
        code: '3114',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m)',
        description:
            'Length or first dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3114(\d{6})$'),
    '3115': const AI(
        code: '3115',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m)',
        description: '',
        fixLength: 6,
        regExpString: r'^3115(\d{6})$'),
    '3120': const AI(
        code: '3110',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m)',
        description:
            'Width, diameter, or second dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3110(\d{6})$'),
    '3121': const AI(
        code: '3121',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m)',
        description:
            'Width, diameter, or second dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3121(\d{6})$'),
    '3122': const AI(
        code: '3122',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m)',
        description:
            'Width, diameter, or second dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3122(\d{6})$'),
    '3123': const AI(
        code: '3123',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m)',
        description:
            'Width, diameter, or second dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3123(\d{6})$'),
    '3124': const AI(
        code: '3124',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m)',
        description:
            'Width, diameter, or second dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3124(\d{6})$'),
    '3125': const AI(
        code: '3125',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m)',
        description:
            'Width, diameter, or second dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3125(\d{6})$'),
    '3130': const AI(
        code: '3130',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m)',
        description:
        'Depth, thickness, height, or third dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3130(\d{6})$'),
    '3131': const AI(
        code: '3131',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m)',
        description:
        'Depth, thickness, height, or third dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3131(\d{6})$'),
    '3132': const AI(
        code: '3132',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m)',
        description:
        'Depth, thickness, height, or third dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3132(\d{6})$'),
    '3133': const AI(
        code: '3133',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m)',
        description:
        'Depth, thickness, height, or third dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3133(\d{6})$'),
    '3134': const AI(
        code: '3134',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m)',
        description:
        'Depth, thickness, height, or third dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3134(\d{6})$'),
    '3135': const AI(
        code: '3135',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m)',
        description:
        'Depth, thickness, height, or third dimension, metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3135(\d{6})$'),
    '3140': const AI(
        code: '3140',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description:
        'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3141': const AI(
        code: '3141',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description:
        'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3141(\d{6})$'),
    '3142': const AI(
        code: '3142',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description:
        'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3142(\d{6})$'),
    '3143': const AI(
        code: '3143',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description:
        'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3144': const AI(
        code: '3144',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description:
        'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3145': const AI(
        code: '3145',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description:
        'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3150': const AI(
        code: '3140',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description:
        'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3151': const AI(
        code: '3151',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description:
        'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3151(\d{6})$'),
    '3152': const AI(
        code: '3152',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description:
        'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3152(\d{6})$'),
    '3153': const AI(
        code: '3153',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description:
        'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3153(\d{6})$'),
    '3154': const AI(
        code: '3154',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description:
        'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3154(\d{6})$'),
    '3155': const AI(
        code: '3155',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description:
        'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3155(\d{6})$'),
    '3160': const AI(
        code: '3160',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description:
        'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
    '3161': const AI(
        code: '3161',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description:
        'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3161(\d{6})$'),
    '3162': const AI(
        code: '3162',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description:
        'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3162(\d{6})$'),
    '3163': const AI(
        code: '3163',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description:
        'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
    '3164': const AI(
        code: '3164',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description:
        'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
    '3165': const AI(
        code: '3165',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description:
        'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
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
