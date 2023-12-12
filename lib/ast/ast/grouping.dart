part of '../ast.dart';


@MappableClass()
class Grouping extends Expression with GroupingMappable {
  const Grouping(super.token, this.expression);

  final Expression expression;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitGrouping(this, context);

  @override
  String toString() => 'Grouping($expression)';
}
