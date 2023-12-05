import '../ast.dart';


class SemanticException extends FormatException {
  SemanticException(String message, String source, this.node)
    : super(message, source, node.token.offset);

  final AstNode node;

  @override
  String toString() =>
    'SemanticException${super.toString().substring(15)}';
}
