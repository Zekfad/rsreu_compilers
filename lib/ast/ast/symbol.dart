part of '../ast.dart';


sealed class Symbol extends Expression {
  const Symbol(super.token, this.name, [
    this.type = Type.unknown,
  ]);
 
  final String name;
  final Type type;

  @override
  String toString() => 'Symbol($name, $type)';
}
