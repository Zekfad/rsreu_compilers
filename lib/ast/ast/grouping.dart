part of '../ast.dart';


class Grouping extends Expression {
  const Grouping(super.token, this.expression);

  final Expression expression;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitGrouping(this, context);

  @override
  String toString() => 'Grouping($expression)';
}
