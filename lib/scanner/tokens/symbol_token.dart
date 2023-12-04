import 'token.dart';


class SymbolToken extends Token {
  const SymbolToken({
    required super.type,
    required super.lexeme,
    required super.offset,
    required this.name,
  });

  final String name;
}
