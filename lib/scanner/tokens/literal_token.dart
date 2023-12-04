import 'token.dart';


class LiteralToken<T extends Object> extends Token {
  const LiteralToken({
    required super.type,
    required super.lexeme,
    required super.offset,
    required this.literal,
  });

  final T? literal;
}
