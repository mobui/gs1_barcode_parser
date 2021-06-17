class GS1Exception implements Exception {
  final String message;

  GS1Exception({required this.message});

  @override
  String toString() {
    return message;
  }
}

/// Bad data exception
class GS1DataException extends GS1Exception {
  GS1DataException({required String message}) : super(message: message);
}

/// Parse exception
class GS1ParseException extends GS1Exception {
  GS1ParseException({required String message}) : super(message: message);
}
