enum CodeType {
  DATAMATRIX,
  GS1_128,
  EAN,
  QR_CODE,
  UNDEFINED,
}

class Code {
  final CodeType type;
  final String codeTitle;
  final String fnc1;

  const Code({
    this.type,
    this.codeTitle,
    this.fnc1,
  });

  static final UNDEFINED_CODE = const Code(
    type: CodeType.UNDEFINED,
    codeTitle: 'Undefined',
    fnc1: '',
  );

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
