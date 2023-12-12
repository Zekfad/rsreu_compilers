part of '../ast.dart';


sealed class Symbol extends Expression implements TypedNode {
  const Symbol(super.token, this.name, [
    this.type = Type.unknown,
  ]);
 
  final String name;
  final Type type;

  @override
  DataType get resolvedDataType => type.dataType == DataType.unknown
    ? DataType.integer
    : type.dataType;

  @override
  String toString() => 'Symbol($name, $type)';
}
