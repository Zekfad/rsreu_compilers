part of '../../ast.dart';


class Identifier extends SymbolNode {
  const Identifier(super.token, super.name, [ super.type, ]);

  @override
  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]) =>
    visitor.visitIdentifier(this, context);

  @override
  String toString() => 'Identifier($name)';
}
