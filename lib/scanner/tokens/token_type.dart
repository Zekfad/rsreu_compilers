enum TokenType {
  // Single-character tokens.
  plus,
  minus,
  asterisk,
  slash,
  leftBrace,
  rightBrace,
  equals,

  // One or two character tokens.

  // Literals
  identifier,
  integer,
  floatingPoint,
  type,

  // Keywords

  // Special
  /// Invisible characters (spaces) or semicolon.
  synthetic,
  expressionTerminator,
  eof,
}
