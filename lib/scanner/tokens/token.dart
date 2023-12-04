import 'token_type.dart';


class Token {
  const Token({
    required this.type,
    required this.lexeme,
    required this.offset,
  });

  final TokenType type;
  final String lexeme;
  final int offset;

  @override
  String toString() =>
    'Token($type:$offset): $lexeme';
}
