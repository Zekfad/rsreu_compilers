import '../scanner/tokens.dart';
import 'ast_visitor.dart';


sealed class Expression {
  const Expression();

  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]);
}

sealed class Symbol extends Expression {
  const Symbol(this.name);
 
  final String name;

  @override
  String toString() => 'Symbol($name)';
}

class Identifier extends Symbol {
  const Identifier(super.name);

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitIdentifier(this, context);

  @override
  String toString() => 'Identifier($name)';
}

class Literal<T extends Object> extends Expression {
  const Literal(this.value);

  final T value;
  
  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitLiteral(this, context);

  @override
  String toString() => 'Literal<$T>($value)';
}

class Unary extends Expression {
  const Unary(this.operator, this.right);

  final Token operator;
  final Expression right;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitUnary(this, context);

  @override
  String toString() => 'Unary($operator, $right)';
}

class Binary extends Expression {
  const Binary(this.left, this.operator, this.right);

  final Expression left;
  final Token operator;
  final Expression right;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitBinary(this, context);

  @override
  String toString() => 'Binary($operator, $left, $right)';
}

class Grouping extends Expression {
  const Grouping(this.expression);

  final Expression expression;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitGrouping(this, context);

  @override
  String toString() => 'Grouping($expression)';
}
