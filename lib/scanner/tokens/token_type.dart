enum TokenType {
  // Single-character tokens.
  plus,
  minus,
  asterisk,
  slash,
  leftBrace,
  rightBrace,

  // One or two character tokens.

  // Literals
  identifier,
  integer,
  floatingPoint,

  // Keywords

  // Special
  /// Invisible characters (spaces) or semicolon.
  expressionTerminator,
  eof,
}
