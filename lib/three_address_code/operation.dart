enum Operation {
  addition('add'),
  subtraction('sub'),
  multiplication('mul'),
  division('div'),
  negate('neg'),
  castIntegerToFloat('i2f'),
  ;

  const Operation(this.lexeme);
  final String lexeme;

  @override
  String toString() => lexeme;
}
