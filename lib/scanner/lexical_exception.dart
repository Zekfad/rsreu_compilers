class LexicalException extends FormatException {
  LexicalException(
    super.message,
    String super.source,
    super.offset,
  );

  // Todo(zekfad): this can be optimized to store line instead of computing it
  @override
  String toString() =>
    'LexicalException${super.toString().substring(15)}';
}
