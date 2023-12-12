part of '../ast.dart';

sealed class SymbolNode extends Expression implements TypedNode {
  const SymbolNode(super.token, this.name, [
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
