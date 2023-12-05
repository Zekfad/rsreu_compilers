part of '../ast.dart';


@immutable
class Type extends Expression {
  const Type(super.token, this.dataType);

  const Type._unknown() : dataType = DataType.unknown,
    super(const Token.synthetic());

  static const unknown = Type._unknown();

  final DataType dataType;

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitType(this, context);

  @override
  String toString() => 'Type($dataType)';

  @override
  bool operator ==(Object other) =>
    identical(other, this) || (
      other is Type &&
      other.runtimeType == runtimeType &&
      other.dataType == dataType
    );

  @override
  int get hashCode => dataType.hashCode;
}
