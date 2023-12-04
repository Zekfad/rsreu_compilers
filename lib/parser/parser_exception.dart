import '../scanner.dart';


class ParserException extends FormatException {
  ParserException(String message, String source, this.token)
    : super(message, source, token.offset);

  final Token token;

  @override
  String toString() =>
    'ParserException${super.toString().substring(15)}';
}
