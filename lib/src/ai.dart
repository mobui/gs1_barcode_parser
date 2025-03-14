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

  final int? _fixLength;
  final String _regExpString;
  final String _description;

  const AI({
    required String code,
    required String dataTitle,
    required AIFormatType type,
    int? fixLength,
    required String regExpString,
    required String description,
  })  : _fixLength = fixLength,
        _code = code,
        _dataTitle = dataTitle,
        _type = type,
        _regExpString = regExpString,
        _description = description;

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
    if (type == AIFormatType.FIXED_LENGTH) return _fixLength ?? 0;
    if (type == AIFormatType.FIXED_LENGTH_MEASURE) return _fixLength ?? 0;
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
      fixLength: AI._DATE_FIX_LENGTH,
      dataTitle: 'PROD DATE',
      regExpString: r'^11(\d{6})$',
      description: 'Production date (YYMMDD)',
    ),
    '12': const AI(
      code: '12',
      type: AIFormatType.DATE,
      fixLength: AI._DATE_FIX_LENGTH,
      dataTitle: 'DUE DATE',
      regExpString: r'^12(\d{6})$',
      description: 'Due date (YYMMDD)',
    ),
    '13': const AI(
      code: '13',
      type: AIFormatType.DATE,
      fixLength: AI._DATE_FIX_LENGTH,
      dataTitle: 'PACK DATE',
      regExpString: r'^13(\d{6})$',
      description: 'Packaging date (YYMMDD)',
    ),
    '15': const AI(
      code: '15',
      type: AIFormatType.DATE,
      fixLength: AI._DATE_FIX_LENGTH,
      dataTitle: 'BEST BEFORE or BEST BY',
      regExpString: r'^15(\d{6})$',
      description: 'Best before date (YYMMDD)',
    ),
    '16': const AI(
      code: '16',
      type: AIFormatType.DATE,
      fixLength: AI._DATE_FIX_LENGTH,
      dataTitle: 'SELL BY',
      regExpString: r'^16(\d{6})$',
      description: 'Sell by date (YYMMDD)',
    ),
    '17': const AI(
      code: '17',
      type: AIFormatType.DATE,
      fixLength: AI._DATE_FIX_LENGTH,
      dataTitle: 'USE BY OR EXPIRY',
      description: 'Expiration date (YYMMDD)',
      regExpString: r'^17(\d{6})$',
    ),
    '20': const AI(
      code: '20',
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
      regExpString: r'^30(\d{0,8})$',
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
        description: 'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3141': const AI(
        code: '3141',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description: 'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3141(\d{6})$'),
    '3142': const AI(
        code: '3142',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description: 'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3142(\d{6})$'),
    '3143': const AI(
        code: '3143',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description: 'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3144': const AI(
        code: '3144',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description: 'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3145': const AI(
        code: '3145',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2)',
        description: 'Area, square metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3150': const AI(
        code: '3140',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description: 'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3140(\d{6})$'),
    '3151': const AI(
        code: '3151',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description: 'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3151(\d{6})$'),
    '3152': const AI(
        code: '3152',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description: 'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3152(\d{6})$'),
    '3153': const AI(
        code: '3153',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description: 'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3153(\d{6})$'),
    '3154': const AI(
        code: '3154',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description: 'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3154(\d{6})$'),
    '3155': const AI(
        code: '3155',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (l)',
        description: 'Net volume, litres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3155(\d{6})$'),
    '3160': const AI(
        code: '3160',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description: 'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
    '3161': const AI(
        code: '3161',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description: 'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3161(\d{6})$'),
    '3162': const AI(
        code: '3162',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description: 'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3162(\d{6})$'),
    '3163': const AI(
        code: '3163',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description: 'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
    '3164': const AI(
        code: '3164',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description: 'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
    '3165': const AI(
        code: '3165',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET VOLUME (m3)',
        description: 'Net volume, cubic metres (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3160(\d{6})$'),
    '3200': const AI(
        code: '3200',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (lb)',
        description: 'Net weight, pounds (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3200(\d{6})$'),
    '3201': const AI(
        code: '3201',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (lb)',
        description: 'Net weight, pounds (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3201(\d{6})$'),
    '3202': const AI(
        code: '3202',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (lb)',
        description: 'Net weight, pounds (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3202(\d{6})$'),
    '3203': const AI(
        code: '3203',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (lb)',
        description: 'Net weight, pounds (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3203(\d{6})$'),
    '3204': const AI(
        code: '3204',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (lb)',
        description: 'Net weight, pounds (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3200(\d{6})$'),
    '3205': const AI(
        code: '3205',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'NET WEIGHT (lb)',
        description: 'Net weight, pounds (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3200(\d{6})$'),
    '3210': const AI(
        code: '3210',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in)',
        description:
            'Length or first dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3210(\d{6})$'),
    '3211': const AI(
        code: '3211',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in)',
        description:
            'Length or first dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3211(\d{6})$'),
    '3212': const AI(
        code: '3210',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in)',
        description:
            'Length or first dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3211(\d{6})$'),
    '3213': const AI(
        code: '3213',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in)',
        description:
            'Length or first dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3213(\d{6})$'),
    '3214': const AI(
        code: '3214',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in)',
        description:
            'Length or first dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3214(\d{6})$'),
    '3215': const AI(
        code: '3214',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in)',
        description:
            'Length or first dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3214(\d{6})$'),
    '3220': const AI(
        code: '3220',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft)',
        description:
            'Length or first dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3220(\d{6})$'),
    '3221': const AI(
        code: '3221',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft)',
        description:
            'Length or first dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3221(\d{6})$'),
    '3222': const AI(
        code: '3222',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft)',
        description:
            'Length or first dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3222(\d{6})$'),
    '3223': const AI(
        code: '3223',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft)',
        description:
            'Length or first dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3223(\d{6})$'),
    '3224': const AI(
        code: '3224',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft)',
        description:
            'Length or first dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3224(\d{6})$'),
    '3225': const AI(
        code: '3225',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft)',
        description:
            'Length or first dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3225(\d{6})$'),
    '3230': const AI(
        code: '3230',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd)',
        description:
            'Length or first dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3230(\d{6})$'),
    '3231': const AI(
        code: '3231',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd)',
        description:
            'Length or first dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3231(\d{6})$'),
    '3232': const AI(
        code: '3232',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd)',
        description:
            'Length or first dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3232(\d{6})$'),
    '3233': const AI(
        code: '3233',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd)',
        description:
            'Length or first dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3233(\d{6})$'),
    '3234': const AI(
        code: '3234',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd)',
        description:
            'Length or first dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3234(\d{6})$'),
    '3235': const AI(
        code: '3230',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd)',
        description:
            'Length or first dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3235(\d{6})$'),
    '3240': const AI(
        code: '3240',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in)',
        description:
            'Width, diameter, or second dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3240(\d{6})$'),
    '3241': const AI(
        code: '3241',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in)',
        description:
            'Width, diameter, or second dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3241(\d{6})$'),
    '3242': const AI(
        code: '3242',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in)',
        description:
            'Width, diameter, or second dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3242(\d{6})$'),
    '3243': const AI(
        code: '3243',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in)',
        description:
            'Width, diameter, or second dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3243(\d{6})$'),
    '3244': const AI(
        code: '3244',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in)',
        description:
            'Width, diameter, or second dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3244(\d{6})$'),
    '3245': const AI(
        code: '3245',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in)',
        description:
            'Width, diameter, or second dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3245(\d{6})$'),
    '3250': const AI(
        code: '3250',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft)',
        description:
            'Width, diameter, or second dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3250(\d{6})$'),
    '3251': const AI(
        code: '3251',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft)',
        description:
            'Width, diameter, or second dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3251(\d{6})$'),
    '3252': const AI(
        code: '3252',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft)',
        description:
            'Width, diameter, or second dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3252(\d{6})$'),
    '3253': const AI(
        code: '3253',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft)',
        description:
            'Width, diameter, or second dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3253(\d{6})$'),
    '3254': const AI(
        code: '3254',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft)',
        description:
            'Width, diameter, or second dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3254(\d{6})$'),
    '3255': const AI(
        code: '3255',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft)',
        description:
            'Width, diameter, or second dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3255(\d{6})$'),
    '3260': const AI(
        code: '3260',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd)',
        description:
            'Width, diameter, or second dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3260(\d{6})$'),
    '3261': const AI(
        code: '3261',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd)',
        description:
            'Width, diameter, or second dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3261(\d{6})$'),
    '3262': const AI(
        code: '3262',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd)',
        description:
            'Width, diameter, or second dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3262(\d{6})$'),
    '3263': const AI(
        code: '3263',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd)',
        description:
            'Width, diameter, or second dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3263(\d{6})$'),
    '3264': const AI(
        code: '3264',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd)',
        description:
            'Width, diameter, or second dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3264(\d{6})$'),
    '3265': const AI(
        code: '3265',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd)',
        description:
            'Width, diameter, or second dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3265(\d{6})$'),
    '3270': const AI(
        code: '3270',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in)',
        description:
            'Depth, thickness, height, or third dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3270(\d{6})$'),
    '3271': const AI(
        code: '3271',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in)',
        description:
            'Depth, thickness, height, or third dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3271(\d{6})$'),
    '3272': const AI(
        code: '3272',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in)',
        description:
            'Depth, thickness, height, or third dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3272(\d{6})$'),
    '3273': const AI(
        code: '3273',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in)',
        description:
            'Depth, thickness, height, or third dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3273(\d{6})$'),
    '3274': const AI(
        code: '3274',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in)',
        description:
            'Depth, thickness, height, or third dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3274(\d{6})$'),
    '3275': const AI(
        code: '3275',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in)',
        description:
            'Depth, thickness, height, or third dimension, inches (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3275(\d{6})$'),
    '3280': const AI(
        code: '3280',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft)',
        description:
            'Depth, thickness, height, or third dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3280(\d{6})$'),
    '3281': const AI(
        code: '3281',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft)',
        description:
            'Depth, thickness, height, or third dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3281(\d{6})$'),
    '3282': const AI(
        code: '3282',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft)',
        description:
            'Depth, thickness, height, or third dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3282(\d{6})$'),
    '3283': const AI(
        code: '3283',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft)',
        description:
            'Depth, thickness, height, or third dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3283(\d{6})$'),
    '3284': const AI(
        code: '3284',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft)',
        description:
            'Depth, thickness, height, or third dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3284(\d{6})$'),
    '3285': const AI(
        code: '3285',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft)',
        description:
            'Depth, thickness, height, or third dimension, feet (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3285(\d{6})$'),
    '3290': const AI(
        code: '3290',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd)',
        description:
            'Depth, thickness, height, or third dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3290(\d{6})$'),
    '3291': const AI(
        code: '3291',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd)',
        description:
            'Depth, thickness, height, or third dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3291(\d{6})$'),
    '3292': const AI(
        code: '3292',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd)',
        description:
            'Depth, thickness, height, or third dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3292(\d{6})$'),
    '3293': const AI(
        code: '3293',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd)',
        description:
            'Depth, thickness, height, or third dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3293(\d{6})$'),
    '3294': const AI(
        code: '3294',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd)',
        description:
            'Depth, thickness, height, or third dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3294(\d{6})$'),
    '3295': const AI(
        code: '3295',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd)',
        description:
            'Depth, thickness, height, or third dimension, yards (variable measure trade item)',
        fixLength: 6,
        regExpString: r'^3295(\d{6})$'),
    '3300': const AI(
        code: '3295',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (kg)',
        description: 'Logistic weight, kilograms',
        fixLength: 6,
        regExpString: r'^3300(\d{6})$'),
    '3301': const AI(
        code: '3301',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (kg)',
        description: 'Logistic weight, kilograms',
        fixLength: 6,
        regExpString: r'^3301(\d{6})$'),
    '3302': const AI(
        code: '3302',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (kg)',
        description: 'Logistic weight, kilograms',
        fixLength: 6,
        regExpString: r'^3302(\d{6})$'),
    '3303': const AI(
        code: '3303',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (kg)',
        description: 'Logistic weight, kilograms',
        fixLength: 6,
        regExpString: r'^3303(\d{6})$'),
    '3304': const AI(
        code: '3304',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (kg)',
        description: 'Logistic weight, kilograms',
        fixLength: 6,
        regExpString: r'^3304(\d{6})$'),
    '3305': const AI(
        code: '3305',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (kg)',
        description: 'Logistic weight, kilograms',
        fixLength: 6,
        regExpString: r'^3305(\d{6})$'),
    '3310': const AI(
        code: '3310',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m), log',
        description: 'Length or first dimension, metres',
        fixLength: 6,
        regExpString: r'^3310(\d{6})$'),
    '3311': const AI(
        code: '3311',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m), log',
        description: 'Length or first dimension, metres',
        fixLength: 6,
        regExpString: r'^3311(\d{6})$'),
    '3312': const AI(
        code: '3312',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m), log',
        description: 'Length or first dimension, metres',
        fixLength: 6,
        regExpString: r'^3312(\d{6})$'),
    '3313': const AI(
        code: '3313',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m), log',
        description: 'Length or first dimension, metres',
        fixLength: 6,
        regExpString: r'^3313(\d{6})$'),
    '3314': const AI(
        code: '3314',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m), log',
        description: 'Length or first dimension, metres',
        fixLength: 6,
        regExpString: r'^3314(\d{6})$'),
    '3315': const AI(
        code: '3315',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (m), log',
        description: 'Length or first dimension, metres',
        fixLength: 6,
        regExpString: r'^3315(\d{6})$'),
    '3320': const AI(
        code: '3320',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m), log',
        description: 'Width, diameter, or second dimension, metres',
        fixLength: 6,
        regExpString: r'^3320(\d{6})$'),
    '3321': const AI(
        code: '3321',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m), log',
        description: 'Width, diameter, or second dimension, metres',
        fixLength: 6,
        regExpString: r'^3321(\d{6})$'),
    '3322': const AI(
        code: '3322',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m), log',
        description: 'Width, diameter, or second dimension, metres',
        fixLength: 6,
        regExpString: r'^3322(\d{6})$'),
    '3323': const AI(
        code: '3323',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m), log',
        description: 'Width, diameter, or second dimension, metres',
        fixLength: 6,
        regExpString: r'^3323(\d{6})$'),
    '3324': const AI(
        code: '3324',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m), log',
        description: 'Width, diameter, or second dimension, metres',
        fixLength: 6,
        regExpString: r'^3324(\d{6})$'),
    '3325': const AI(
        code: '3325',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (m), log',
        description: 'Width, diameter, or second dimension, metres',
        fixLength: 6,
        regExpString: r'^3325(\d{6})$'),
    '3330': const AI(
        code: '3330',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m), log',
        description: 'Depth, thickness, height, or third dimension, metres',
        fixLength: 6,
        regExpString: r'^3330(\d{6})$'),
    '3331': const AI(
        code: '3331',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m), log',
        description: 'Depth, thickness, height, or third dimension, metres',
        fixLength: 6,
        regExpString: r'^3331(\d{6})$'),
    '3332': const AI(
        code: '3332',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m), log',
        description: 'Depth, thickness, height, or third dimension, metres',
        fixLength: 6,
        regExpString: r'^3332(\d{6})$'),
    '3333': const AI(
        code: '3333',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m), log',
        description: 'Depth, thickness, height, or third dimension, metres',
        fixLength: 6,
        regExpString: r'^3333(\d{6})$'),
    '3334': const AI(
        code: '3334',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m), log',
        description: 'Depth, thickness, height, or third dimension, metres',
        fixLength: 6,
        regExpString: r'^3334(\d{6})$'),
    '3335': const AI(
        code: '3335',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (m), log',
        description: 'Depth, thickness, height, or third dimension, metres',
        fixLength: 6,
        regExpString: r'^3335(\d{6})$'),
    '3340': const AI(
        code: '3340',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2), log',
        description: 'Area, square metres',
        fixLength: 6,
        regExpString: r'^3340(\d{6})$'),
    '3341': const AI(
        code: '3341',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2), log',
        description: 'Area, square metres',
        fixLength: 6,
        regExpString: r'^3341(\d{6})$'),
    '3342': const AI(
        code: '3342',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2), log',
        description: 'Area, square metres',
        fixLength: 6,
        regExpString: r'^3342(\d{6})$'),
    '3343': const AI(
        code: '3343',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2), log',
        description: 'Area, square metres',
        fixLength: 6,
        regExpString: r'^3343(\d{6})$'),
    '3344': const AI(
        code: '3344',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2), log',
        description: 'Area, square metres',
        fixLength: 6,
        regExpString: r'^3344(\d{6})$'),
    '3345': const AI(
        code: '3345',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'AREA (m2), log',
        description: 'Area, square metres',
        fixLength: 6,
        regExpString: r'^3345(\d{6})$'),
    '3350': const AI(
        code: '3350',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (l), log',
        description: 'Logistic volume, litres',
        fixLength: 6,
        regExpString: r'^3350(\d{6})$'),
    '3351': const AI(
        code: '3351',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (l), log',
        description: 'Logistic volume, litres',
        fixLength: 6,
        regExpString: r'^3351(\d{6})$'),
    '3352': const AI(
        code: '3352',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (l), log',
        description: 'Logistic volume, litres',
        fixLength: 6,
        regExpString: r'^3352(\d{6})$'),
    '3353': const AI(
        code: '3353',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (l), log',
        description: 'Logistic volume, litres',
        fixLength: 6,
        regExpString: r'^3353(\d{6})$'),
    '3354': const AI(
        code: '3354',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (l), log',
        description: 'Logistic volume, litres',
        fixLength: 6,
        regExpString: r'^3354(\d{6})$'),
    '3355': const AI(
        code: '3355',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (l), log',
        description: 'Logistic volume, litres',
        fixLength: 6,
        regExpString: r'^3355(\d{6})$'),
    '3360': const AI(
        code: '3360',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (m3), log',
        description: 'Logistic volume, cubic metres',
        fixLength: 6,
        regExpString: r'^3360(\d{6})$'),
    '3361': const AI(
        code: '3361',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (m3), log',
        description: 'Logistic volume, cubic metres',
        fixLength: 6,
        regExpString: r'^3361(\d{6})$'),
    '3362': const AI(
        code: '3362',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (m3), log',
        description: 'Logistic volume, cubic metres',
        fixLength: 6,
        regExpString: r'^3362(\d{6})$'),
    '3363': const AI(
        code: '3363',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (m3), log',
        description: 'Logistic volume, cubic metres',
        fixLength: 6,
        regExpString: r'^3363(\d{6})$'),
    '3364': const AI(
        code: '3364',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (m3), log',
        description: 'Logistic volume, cubic metres',
        fixLength: 6,
        regExpString: r'^3364(\d{6})$'),
    '3365': const AI(
        code: '3365',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'VOLUME (m3), log',
        description: 'Logistic volume, cubic metres',
        fixLength: 6,
        regExpString: r'^3365(\d{6})$'),
    '3370': const AI(
        code: '3370',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'KG PER m2',
        description: 'Kilograms per square metre',
        fixLength: 6,
        regExpString: r'^3370(\d{6})$'),
    '3371': const AI(
        code: '3371',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'KG PER m2',
        description: 'Kilograms per square metre',
        fixLength: 6,
        regExpString: r'^3371(\d{6})$'),
    '3372': const AI(
        code: '3372',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'KG PER m2',
        description: 'Kilograms per square metre',
        fixLength: 6,
        regExpString: r'^3372(\d{6})$'),
    '3373': const AI(
        code: '3373',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'KG PER m2',
        description: 'Kilograms per square metre',
        fixLength: 6,
        regExpString: r'^3373(\d{6})$'),
    '3374': const AI(
        code: '3374',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'KG PER m2',
        description: 'Kilograms per square metre',
        fixLength: 6,
        regExpString: r'^3374(\d{6})$'),
    '3375': const AI(
        code: '3375',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'KG PER m2',
        description: 'Kilograms per square metre',
        fixLength: 6,
        regExpString: r'^3375(\d{6})$'),
    '3400': const AI(
        code: '3400',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (lb)',
        description: 'Logistic weight, pounds',
        fixLength: 6,
        regExpString: r'^3400(\d{6})$'),
    '3401': const AI(
        code: '3401',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (lb)',
        description: 'Logistic weight, pounds',
        fixLength: 6,
        regExpString: r'^3401(\d{6})$'),
    '3402': const AI(
        code: '3402',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (lb)',
        description: 'Logistic weight, pounds',
        fixLength: 6,
        regExpString: r'^3402(\d{6})$'),
    '3403': const AI(
        code: '3403',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (lb)',
        description: 'Logistic weight, pounds',
        fixLength: 6,
        regExpString: r'^3403(\d{6})$'),
    '3404': const AI(
        code: '3404',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (lb)',
        description: 'Logistic weight, pounds',
        fixLength: 6,
        regExpString: r'^3404(\d{6})$'),
    '3405': const AI(
        code: '3405',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'GROSS WEIGHT (lb)',
        description: 'Logistic weight, pounds',
        fixLength: 6,
        regExpString: r'^3405(\d{6})$'),
    '3410': const AI(
        code: '3410',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in), log',
        description: 'Length or first dimension, inches',
        fixLength: 6,
        regExpString: r'^3410(\d{6})$'),
    '3411': const AI(
        code: '3411',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in), log',
        description: 'Length or first dimension, inches',
        fixLength: 6,
        regExpString: r'^3411(\d{6})$'),
    '3412': const AI(
        code: '3412',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in), log',
        description: 'Length or first dimension, inches',
        fixLength: 6,
        regExpString: r'^3412(\d{6})$'),
    '3413': const AI(
        code: '3413',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in), log',
        description: 'Length or first dimension, inches',
        fixLength: 6,
        regExpString: r'^3413(\d{6})$'),
    '3414': const AI(
        code: '3414',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in), log',
        description: 'Length or first dimension, inches',
        fixLength: 6,
        regExpString: r'^3414(\d{6})$'),
    '3415': const AI(
        code: '3415',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (in), log',
        description: 'Length or first dimension, inches',
        fixLength: 6,
        regExpString: r'^3415(\d{6})$'),
    '3420': const AI(
        code: '3420',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft), log',
        description: 'Length or first dimension, feet',
        fixLength: 6,
        regExpString: r'^3420(\d{6})$'),
    '3421': const AI(
        code: '3421',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft), log',
        description: 'Length or first dimension, feet',
        fixLength: 6,
        regExpString: r'^3421(\d{6})$'),
    '3422': const AI(
        code: '3422',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft), log',
        description: 'Length or first dimension, feet',
        fixLength: 6,
        regExpString: r'^3422(\d{6})$'),
    '3423': const AI(
        code: '3423',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft), log',
        description: 'Length or first dimension, feet',
        fixLength: 6,
        regExpString: r'^3423(\d{6})$'),
    '3424': const AI(
        code: '3424',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft), log',
        description: 'Length or first dimension, feet',
        fixLength: 6,
        regExpString: r'^3424(\d{6})$'),
    '3425': const AI(
        code: '3425',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (ft), log',
        description: 'Length or first dimension, feet',
        fixLength: 6,
        regExpString: r'^3425(\d{6})$'),
    '3430': const AI(
        code: '3430',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd), log',
        description: 'Length or first dimension, yards',
        fixLength: 6,
        regExpString: r'^3430(\d{6})$'),
    '3431': const AI(
        code: '3431',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd), log',
        description: 'Length or first dimension, yards',
        fixLength: 6,
        regExpString: r'^3431(\d{6})$'),
    '3432': const AI(
        code: '3432',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd), log',
        description: 'Length or first dimension, yards',
        fixLength: 6,
        regExpString: r'^3432(\d{6})$'),
    '3433': const AI(
        code: '3433',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd), log',
        description: 'Length or first dimension, yards',
        fixLength: 6,
        regExpString: r'^3433(\d{6})$'),
    '3434': const AI(
        code: '3434',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd), log',
        description: 'Length or first dimension, yards',
        fixLength: 6,
        regExpString: r'^3434(\d{6})$'),
    '3435': const AI(
        code: '3435',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'LENGTH (yd), log',
        description: 'Length or first dimension, yards',
        fixLength: 6,
        regExpString: r'^3435(\d{6})$'),
    '3440': const AI(
        code: '3440',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in), log',
        description: 'Width, diameter, or second dimension, inches',
        fixLength: 6,
        regExpString: r'^3440(\d{6})$'),
    '3441': const AI(
        code: '3441',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in), log',
        description: 'Width, diameter, or second dimension, inches',
        fixLength: 6,
        regExpString: r'^3441(\d{6})$'),
    '3442': const AI(
        code: '3442',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in), log',
        description: 'Width, diameter, or second dimension, inches',
        fixLength: 6,
        regExpString: r'^3442(\d{6})$'),
    '3443': const AI(
        code: '3443',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in), log',
        description: 'Width, diameter, or second dimension, inches',
        fixLength: 6,
        regExpString: r'^3443(\d{6})$'),
    '3444': const AI(
        code: '3444',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in), log',
        description: 'Width, diameter, or second dimension, inches',
        fixLength: 6,
        regExpString: r'^3444(\d{6})$'),
    '3445': const AI(
        code: '3445',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (in), log',
        description: 'Width, diameter, or second dimension, inches',
        fixLength: 6,
        regExpString: r'^3445(\d{6})$'),
    '3450': const AI(
        code: '3450',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft), log',
        description: 'Width, diameter, or second dimension, feet',
        fixLength: 6,
        regExpString: r'^3450(\d{6})$'),
    '3451': const AI(
        code: '3451',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft), log',
        description: 'Width, diameter, or second dimension, feet',
        fixLength: 6,
        regExpString: r'^3451(\d{6})$'),
    '3452': const AI(
        code: '3452',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft), log',
        description: 'Width, diameter, or second dimension, feet',
        fixLength: 6,
        regExpString: r'^3452(\d{6})$'),
    '3453': const AI(
        code: '3453',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft), log',
        description: 'Width, diameter, or second dimension, feet',
        fixLength: 6,
        regExpString: r'^3453(\d{6})$'),
    '3454': const AI(
        code: '3454',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft), log',
        description: 'Width, diameter, or second dimension, feet',
        fixLength: 6,
        regExpString: r'^3454(\d{6})$'),
    '3455': const AI(
        code: '3455',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (ft), log',
        description: 'Width, diameter, or second dimension, feet',
        fixLength: 6,
        regExpString: r'^3455(\d{6})$'),
    '3460': const AI(
        code: '3460',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd), log',
        description: 'Width, diameter, or second dimension, yard',
        fixLength: 6,
        regExpString: r'^3460(\d{6})$'),
    '3461': const AI(
        code: '3461',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd), log',
        description: 'Width, diameter, or second dimension, yard',
        fixLength: 6,
        regExpString: r'^3461(\d{6})$'),
    '3462': const AI(
        code: '3462',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd), log',
        description: 'Width, diameter, or second dimension, yard',
        fixLength: 6,
        regExpString: r'^3462(\d{6})$'),
    '3463': const AI(
        code: '3460',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd), log',
        description: 'Width, diameter, or second dimension, yard',
        fixLength: 6,
        regExpString: r'^3463(\d{6})$'),
    '3464': const AI(
        code: '3464',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd), log',
        description: 'Width, diameter, or second dimension, yard',
        fixLength: 6,
        regExpString: r'^3464(\d{6})$'),
    '3465': const AI(
        code: '3465',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'WIDTH (yd), log',
        description: 'Width, diameter, or second dimension, yard',
        fixLength: 6,
        regExpString: r'^3465(\d{6})$'),
    '3470': const AI(
        code: '3470',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in), log',
        description: 'Depth, thickness, height, or third dimension, inches',
        fixLength: 6,
        regExpString: r'^3470(\d{6})$'),
    '3471': const AI(
        code: '3471',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in), log',
        description: 'Depth, thickness, height, or third dimension, inches',
        fixLength: 6,
        regExpString: r'^3471(\d{6})$'),
    '3472': const AI(
        code: '3472',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in), log',
        description: 'Depth, thickness, height, or third dimension, inches',
        fixLength: 6,
        regExpString: r'^3472(\d{6})$'),
    '3473': const AI(
        code: '3473',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in), log',
        description: 'Depth, thickness, height, or third dimension, inches',
        fixLength: 6,
        regExpString: r'^3473(\d{6})$'),
    '3474': const AI(
        code: '3474',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in), log',
        description: 'Depth, thickness, height, or third dimension, inches',
        fixLength: 6,
        regExpString: r'^3474(\d{6})$'),
    '3475': const AI(
        code: '3475',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (in), log',
        description: 'Depth, thickness, height, or third dimension, inches',
        fixLength: 6,
        regExpString: r'^3475(\d{6})$'),
    '3480': const AI(
        code: '3480',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft), log',
        description: 'Depth, thickness, height, or third dimension, feet',
        fixLength: 6,
        regExpString: r'^3480(\d{6})$'),
    '3481': const AI(
        code: '3481',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft), log',
        description: 'Depth, thickness, height, or third dimension, feet',
        fixLength: 6,
        regExpString: r'^3481(\d{6})$'),
    '3482': const AI(
        code: '3482',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft), log',
        description: 'Depth, thickness, height, or third dimension, feet',
        fixLength: 6,
        regExpString: r'^3482(\d{6})$'),
    '3483': const AI(
        code: '3483',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft), log',
        description: 'Depth, thickness, height, or third dimension, feet',
        fixLength: 6,
        regExpString: r'^3483(\d{6})$'),
    '3484': const AI(
        code: '3484',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft), log',
        description: 'Depth, thickness, height, or third dimension, feet',
        fixLength: 6,
        regExpString: r'^3484(\d{6})$'),
    '3485': const AI(
        code: '3485',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (ft), log',
        description: 'Depth, thickness, height, or third dimension, feet',
        fixLength: 6,
        regExpString: r'^3485(\d{6})$'),
    '3490': const AI(
        code: '3490',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd), log',
        description: 'Depth, thickness, height, or third dimension, yards',
        fixLength: 6,
        regExpString: r'^3490(\d{6})$'),
    '3491': const AI(
        code: '3491',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd), log',
        description: 'Depth, thickness, height, or third dimension, yards',
        fixLength: 6,
        regExpString: r'^3491(\d{6})$'),
    '3492': const AI(
        code: '3492',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd), log',
        description: 'Depth, thickness, height, or third dimension, yards',
        fixLength: 6,
        regExpString: r'^3492(\d{6})$'),
    '3493': const AI(
        code: '3493',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd), log',
        description: 'Depth, thickness, height, or third dimension, yards',
        fixLength: 6,
        regExpString: r'^3493(\d{6})$'),
    '3494': const AI(
        code: '3494',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd), log',
        description: 'Depth, thickness, height, or third dimension, yards',
        fixLength: 6,
        regExpString: r'^3494(\d{6})$'),
    '3495': const AI(
        code: '3495',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'HEIGHT (yd), log',
        description: 'Depth, thickness, height, or third dimension, yards',
        fixLength: 6,
        regExpString: r'^3495(\d{6})$'),
    '37': const AI(
        code: '37',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'COUNT',
        description:
            'Count of trade items or trade item pieces contained in a logistic unit',
        fixLength: 8,
        regExpString: r'^37(\d{0,8})$'),
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
    '422': const AI(
        code: '422',
        type: AIFormatType.FIXED_LENGTH,
        dataTitle: 'ORIGIN',
        description: 'Country of origin of a trade item',
        regExpString: r'^422(\d{3})$'),
    '423': const AI(
        code: '423',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_NUMBERS,
        dataTitle: 'COUNTRY - INITIAL PROCESS.',
        description: 'Country of initial processing',
        regExpString: r'^423(\d{3})(\d{0,12})$'),
    '710': const AI(
        code: '710',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'NHRN PZN',
        description:
            'National Healthcare Reimbursement Number (NHRN) - Germany PZN',
        regExpString: '^710($_ALLOW_CHAR{0,20})\$'),
    '711': const AI(
        code: '711',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'NHRN CIP',
        description:
            'National Healthcare Reimbursement Number (NHRN) - France CIP',
        regExpString: '^711($_ALLOW_CHAR{0,20})\$'),
    '712': const AI(
        code: '712',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'NHRN CN',
        description:
            'National Healthcare Reimbursement Number (NHRN) - Spain CN',
        regExpString: '^712($_ALLOW_CHAR{0,20})\$'),
    '713': const AI(
        code: '713',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'NHRN DRN',
        description:
            'National Healthcare Reimbursement Number (NHRN) - Brasil DRN',
        regExpString: '^713($_ALLOW_CHAR{0,20})\$'),
    '714': const AI(
        code: '714',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'NHRN AIM',
        description:
            'National Healthcare Reimbursement Number (NHRN) - Portugal AIM',
        regExpString: '^714($_ALLOW_CHAR{0,20})\$'),
    '715': const AI(
        code: '715',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'NHRN NDC',
        description:
            'National Healthcare Reimbursement Number (NHRN) - United States of America NDC',
        regExpString: '^715($_ALLOW_CHAR{0,20})\$'),
    '7031': const AI(
        code: '7031',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'PROCESSOR # 1',
        description: 'Number of processor with three-digit ISO country code',
        regExpString: '^7031(\\d{3})($_ALLOW_CHAR{1,27})\$'),
    '8005': const AI(
        code: '8005',
        type: AIFormatType.FIXED_LENGTH,
        fixLength: 6,
        dataTitle: 'PRICE PER UNIT',
        description: 'Price per unit of measure',
        regExpString: r'^8005(\d{6})$'),
    '8200': const AI(
        code: '8200',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'PRODUCT URL',
        description: 'Extended Packaging URL',
        regExpString: '^8200($_ALLOW_CHAR{0,70})\$'),
    '90': const AI(
        code: '90',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Information mutually agreed between trading partners',
        regExpString: '^90($_ALLOW_CHAR{0,30})\$'),
    '91': const AI(
        code: '91',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^91($_ALLOW_CHAR{0,90})\$'),
    '92': const AI(
        code: '92',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^92($_ALLOW_CHAR{0,90})\$'),
    '93': const AI(
        code: '93',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^93($_ALLOW_CHAR{0,90})\$'),
    '94': const AI(
        code: '94',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^94($_ALLOW_CHAR{0,90})\$'),
    '95': const AI(
        code: '95',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^95($_ALLOW_CHAR{0,90})\$'),
    '96': const AI(
        code: '96',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^96($_ALLOW_CHAR{0,90})\$'),
    '97': const AI(
        code: '97',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^97($_ALLOW_CHAR{0,90})\$'),
    '98': const AI(
        code: '99',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^98($_ALLOW_CHAR{0,90})\$'),
    '99': const AI(
        code: '99',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'INTERNAL',
        description: 'Company internal information',
        regExpString: '^99($_ALLOW_CHAR{0,90})\$'),
    '8001': const AI(
        code: '8001',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'ROLL PRODUCTS',
        fixLength: 14,
        regExpString: r'^8001(\d{4})(\d{14})$',
        description: 'Roll products – width, length, core diameter, direction, and splices'),
    '8002': const AI(
        code: '8002',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_CHARS,
        dataTitle: 'CMT NO.',
        regExpString: '^8002(\d{4})($_ALLOW_CHAR{0,20})$\$',
        description: 'Electronic serial identifier for cellular mobile telephones'),
    '8003': const AI(
        code: '8003',
        type: AIFormatType.VARIABLE_LENGTH,
        dataTitle: 'GRAI',
        regExpString: r'^8003(\d{4})(\d{14})([\u{0021}-\u{007a}]{0,16})$',
        description: 'Global Returnable Asset Identifier (GRAI)'),
    '8004': const AI(
        code: '8004',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_CHARS,
        dataTitle: 'GIAI',
        regExpString: '^8004(\d{4})($_ALLOW_CHAR{0,30})$\$',
        description: 'Global Individual Asset Identifier (GIAI)'),
    '8007': const AI(
        code: '8007',
        type: AIFormatType.VARIABLE_LENGTH_WITH_ISO_CHARS,
        dataTitle: 'IBAN',
        regExpString: '^8007(\d{4})($_ALLOW_CHAR{0,34})$\$',
        description: 'International Bank Account Number (IBAN)'),
    '8008': const AI(
        code: '8008',
        type: AIFormatType.FIXED_LENGTH_MEASURE,
        dataTitle: 'PROD TIME',
        fixLength: 12,
        regExpString: r'^8008(\d{12})$',
        description: 'Date and time of production (YYMMDDHHMMSS)'),
  };
}
