part of '../ast.dart';


sealed class AstNode {
  const AstNode(this.token);

  final Token token;

  R? accept<R, C>(AstVisitor<R, C> visitor, [ C? context, ]);

  @override
  String toString() => 'AstNode($token)';
}
