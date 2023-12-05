part of '../ast.dart';


class Unary extends Expression {
  const Unary(super.token, this.operator, this.right);

  final Token operator;
  final Expression right;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitUnary(this, context);

  @override
  String toString() => 'Unary($operator, $right)';
}
