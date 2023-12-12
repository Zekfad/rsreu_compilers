part of '../ast.dart';


@MappableClass()
class Unary extends Expression with UnaryMappable {
  const Unary(super.token, this.operator, this.right);

  final Token operator;
  final Expression right;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitUnary(this, context);

  @override
  String toString() => 'Unary($operator, $right)';
}
