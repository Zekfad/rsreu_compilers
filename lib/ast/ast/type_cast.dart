part of '../ast.dart';


@MappableClass()
class TypeCast extends Expression with TypeCastMappable implements TypedNode {
  const TypeCast(super.token, this.expression, this.dataType) : assert(
    dataType != DataType.unknown,
    'Invalid TypeCast AST node: data type must be known',
  );

  final Expression expression;
  final DataType dataType;

  @override
  DataType get resolvedDataType => dataType;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitTypeCast(this, context);

  @override
  String toString() => 'TypeCast($dataType, $expression)';
}
