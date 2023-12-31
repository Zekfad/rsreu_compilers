part of '../ast.dart';


@MappableClass()
class Binary extends Expression with BinaryMappable {
  const Binary(super.token, this.left, this.operator, this.right);

  final Expression left;
  final Token operator;
  final Expression right;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitBinary(this, context);

  @override
  String toString() => 'Binary($operator, $left, $right)';
}
