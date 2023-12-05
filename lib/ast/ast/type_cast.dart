part of '../ast.dart';


class TypeCast extends Expression {
  const TypeCast(super.token, this.type);
 
  final Type type;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitTypeCast(this, context);

  @override
  String toString() => 'TypeCast($type)';
}
