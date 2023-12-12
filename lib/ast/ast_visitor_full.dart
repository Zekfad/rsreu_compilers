import 'ast.dart';
import 'ast_visitor.dart';


abstract interface class AstVisitorFull<R, C> implements AstVisitor<R, C> {
  @override
  R visitIdentifier(Identifier node, [ C? context, ]);
  @override
  R visitType(Type node, [ C? context, ]);
  @override
  R visitTypeCast(TypeCast node, [ C? context, ]);
  @override
  R visitLiteral(Literal node, [ C? context, ]);
  @override
  R visitUnary(Unary node, [ C? context, ]);
  @override
  R visitBinary(Binary node, [ C? context, ]);
  @override
  R visitGrouping(Grouping node, [ C? context, ]);
}
