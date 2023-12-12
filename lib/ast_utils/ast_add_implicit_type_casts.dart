import '../ast.dart';
import '../scanner.dart';
import '../symbol_table.dart';


/// Modifies AST to add type casts and updates all variables to known types from
/// the symbol table.
class AstAddImplicitTypeCasts extends AstVisitor<(AstNode, DataType), SymbolTable> implements AstVisitorFull<(AstNode, DataType), SymbolTable> {
  const AstAddImplicitTypeCasts();

  (T, DataType) _accept<T extends AstNode>(T node, [ SymbolTable? context, ]) =>
    node.accept(this, context)! as (T, DataType);

  (T, DataType) _visitTypedNode<T extends TypedNode>(T node, [ SymbolTable? context, ]) =>
    (node, node.resolvedDataType);

  @override
  (Identifier, DataType) visitIdentifier(Identifier node, [ SymbolTable? context, ]) {
    final type = switch (context?.lookup(node.name)?.resolvedDataType ?? node.resolvedDataType) {
      DataType.unknown => DataType.integer,
      final type => type,
    };
    final (typeNode, _) = _accept(node.type, context);
    return (
      Identifier(
        node.token,
        node.name,
        Type(
          typeNode.token,
          type,
        ),
      ),
      type,
    );
  }

  @override
  (Type, DataType) visitType(Type node, [ SymbolTable? context, ]) =>
    _visitTypedNode(node, context);

  @override
  (TypeCast, DataType) visitTypeCast(TypeCast node, [ SymbolTable? context, ]) =>
    _visitTypedNode(node, context);

  @override
  (Literal, DataType) visitLiteral(Literal node, [ SymbolTable? context, ]) =>
    _visitTypedNode(node, context);

  @override
  (Unary, DataType) visitUnary(Unary node, [ SymbolTable? context, ]) {
    final (_node, dataType) = _accept(node.right, context);
    return (
      Unary(
        node.token,
        node.operator,
        _node,
      ),
     dataType,
    );
  }

  TypeCast _castExpression(Expression expression, DataType type) =>
    TypeCast(
      Token.synthetic(
        lexeme: '<Synthetic TypeCast>',
        offset: expression.token.offset,
      ),
      expression,
      type,
    );

  @override
  (Binary, DataType) visitBinary(Binary node, [ SymbolTable? context, ]) {
    final (leftNode, leftType) = _accept(node.left, context);
    final (rightNode, rightType) = _accept(node.right, context);

    final ((left, right), type) =  switch ((leftType, rightType)) {
      (DataType.integer, DataType.float) => (
        (_castExpression(leftNode, DataType.float), rightNode),
        DataType.float,
      ),
      (DataType.float, DataType.integer) => (
        (leftNode, _castExpression(rightNode, DataType.float)),
        DataType.float,
      ),
      (DataType.integer, DataType.integer) => (
        (leftNode, rightNode),
        DataType.integer,
      ),
      (DataType.float, DataType.float) => (
        (leftNode, rightNode),
        DataType.float
      ),
      (DataType.unknown, _) ||  (_, DataType.unknown) => (
        (leftNode, rightNode),
        DataType.unknown
      ),
    };

    return (
      Binary(
        node.token,
        left,
        node.operator,
        right,
      ),
      type,
    );
  }

  @override
  (Grouping, DataType) visitGrouping(Grouping node, [ SymbolTable? context, ]) {
    final (_node, dataType) = _accept(node..expression, context);
    return (
      Grouping(node.token, _node),
      dataType,
    );
  }
}
