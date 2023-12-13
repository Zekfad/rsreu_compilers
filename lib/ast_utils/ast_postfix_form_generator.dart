import '../ast.dart';

class AstPostfixFormGenerator extends AstVisitorSingleResult<StringBuffer, void> {
  AstPostfixFormGenerator() : super(StringBuffer());

  @override
  StringBuffer visitIdentifier(Identifier node, [void context]) {
    super.visitIdentifier(node, context);
    result.write(node.name);
    return result;
  }

  @override
  StringBuffer visitLiteral(Literal<Object?> node, [void context]) {
    super.visitLiteral(node, context);
    result.write(node.value);
    return result;
  }

  @override
  StringBuffer visitUnary(Unary node, [void context]) {
    result.write(node.operator.lexeme);
    return super.visitUnary(node, context);
  }

  @override
  StringBuffer visitBinary(Binary node, [void context]) {
    super.visitBinary(node, context);
    result.write(node.operator.lexeme);
    return result;
  }
}
