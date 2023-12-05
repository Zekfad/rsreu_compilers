import 'token_type.dart';


class Token {
  const Token({
    required this.type,
    required this.lexeme,
    required this.offset,
  });

  const Token.synthetic({
    this.lexeme = '<synthetic>',
    this.offset = 0,
  }) : type = TokenType.synthetic;

  final TokenType type;
  final String lexeme;
  final int offset;

  @override
  String toString() =>
    'Token($type:$offset): $lexeme';
}
