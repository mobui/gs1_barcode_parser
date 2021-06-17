enum CodeType {
  DATAMATRIX,
  GS1_128,
  EAN,
  QR_CODE,
  UNDEFINED,
}

class Code {
  /// Code type
  final CodeType type;

  /// Code title
  final String codeTitle;

  /// FNC1 (Prefix) for code
  final String fnc1;

  const Code({
    required this.type,
    required this.codeTitle,
    required this.fnc1,
  });

  @override
  bool operator ==(Object other) => other is Code && other.type == type;

  @override
  int get hashCode => type.index;

  /// Undefined code with empty prefix
  static final UNDEFINED_CODE = const Code(
    type: CodeType.UNDEFINED,
    codeTitle: 'Undefined',
    fnc1: '',
  );

  /// Codes
  static final Map<CodeType, Code> CODES = {
    CodeType.DATAMATRIX: const Code(
      type: CodeType.DATAMATRIX,
      codeTitle: 'GS1 DataMatrix',
      fnc1: ']d2',
    ),
    CodeType.EAN: const Code(
      type: CodeType.EAN,
      codeTitle: 'GS1 DataBar/EAN',
      fnc1: ']e0',
    ),
    CodeType.GS1_128: const Code(
      type: CodeType.GS1_128,
      codeTitle: 'GS1-128',
      fnc1: ']C1',
    ),
    CodeType.QR_CODE: const Code(
      type: CodeType.QR_CODE,
      codeTitle: 'GS1 QR Code',
      fnc1: ']Q3',
    )
  };
}
