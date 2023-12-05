part of '../ast.dart';


class Literal<T extends Object> extends Expression {
  const Literal(super.token, this.value);

  final T value;
  
  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitLiteral(this, context);

  @override
  String toString() => 'Literal<$T>($value)';
}
