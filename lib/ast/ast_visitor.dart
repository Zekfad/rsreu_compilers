import 'ast.dart';


abstract class AstVisitor<R, C> {
  const AstVisitor();

  R? visitIdentifier(Identifier node, [ C? context, ]) {}
  R? visitType(Type node, [ C? context, ]) {}
  R? visitTypeCast(TypeCast node, [ C? context, ]) {
    node.expression.accept(this, context);
  }
  R? visitLiteral(Literal node, [ C? context, ]) {}
  R? visitUnary(Unary node, [ C? context, ]) {
    node.right.accept(this, context);
  }
  R? visitBinary(Binary node, [ C? context, ]) {
    node.left.accept(this, context);
    node.right.accept(this, context);
  }
  R? visitGrouping(Grouping node, [ C? context, ]) {
    node.expression.accept(this, context);
  }
}
