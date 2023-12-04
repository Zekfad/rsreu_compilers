import 'ast.dart';
import 'ast_visitor.dart';


abstract class AstVisitorSingleResult<R, C> extends AstVisitor<R, C> {
  const AstVisitorSingleResult(this.result);

  final R result;

  @override
  R visitIdentifier(Identifier node, [ C? context, ]) {
    super.visitIdentifier(node, context);
    return result;
  }

  @override
  R visitLiteral(Literal node, [ C? context, ]) {
    super.visitLiteral(node, context);
    return result;
  }

  @override
  R visitUnary(Unary node, [ C? context, ]) {
    super.visitUnary(node, context);
    return result;
  }

  @override
  R visitBinary(Binary node, [ C? context, ]) {
    super.visitBinary(node, context);
    return result;
  }

  @override
  R visitGrouping(Grouping node, [ C? context, ]) {
    super.visitGrouping(node, context);
    return result;
  }
}
