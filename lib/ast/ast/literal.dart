part of '../ast.dart';


class Literal<T extends Object?> extends Expression implements TypedNode {
  const Literal(super.token, this.value, this.dataType) : assert(
    dataType != DataType.unknown,
    'Invalid Literal AST node: data type must be known',
  );

  final T value;
  final DataType dataType;

  @override
  DataType get resolvedDataType => dataType;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitLiteral(this, context);

  @override
  String toString() => 'Literal<$T>($value)';
}
