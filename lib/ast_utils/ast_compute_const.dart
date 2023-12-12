import '../ast.dart';
import '../scanner.dart';


typedef AstComputed<N extends AstNode, T extends Object?> = ({N node, T? value, DataType type});
// ignore: prefer_void_to_null
typedef AstUncomputed<N extends AstNode> = AstComputed<N, Null>;

/// Modifies AST to add type casts and updates all variables to known types from
/// the symbol table.
class AstComputeConst extends AstVisitor<AstComputed, void>  implements AstVisitorFull<AstComputed, void> {
  const AstComputeConst();

  AstComputed<N, T> _accept<N extends AstNode, T extends Object>(N node, [ void context, ]) =>
    node.accept(this, context)! as AstComputed<N, T>;

  AstUncomputed<N> _uncomputedNode<N extends AstNode>(N node, DataType type, [ void context, ]) =>
    (node: node, value: null, type: type);

  AstUncomputed<N> _uncomputedTypedNode<N extends TypedNode>(N node, [ void context, ]) =>
    _uncomputedNode(node, node.resolvedDataType, context);

  @override
  AstUncomputed<Identifier> visitIdentifier(Identifier node, [ void context, ]) =>
    _uncomputedTypedNode(node, context);

  @override
  AstUncomputed<Type> visitType(Type node, [ void context, ]) =>
    _uncomputedTypedNode(node, context);

  AstComputed _computedLiteral(Literal literal) => (
    node: literal,
    value: literal.value,
    type: literal.dataType,
  );

  Literal _makeLiteral(int offset, DataType type, Object? value) {
    final _token = Token.synthetic(offset: offset);
    return switch (type) {
      DataType.float => Literal<double>(_token, value! as double, DataType.float),
      DataType.integer => Literal<int>(_token, value! as int, DataType.integer),
      DataType.unknown => throw StateError('Unexpected unknown type'),
    };
  }

  @override
  AstComputed visitTypeCast(TypeCast node, [ void context, ]) {
    final _res = _accept(node.expression);
    if (_res is AstUncomputed || node.dataType == DataType.unknown)
      return (
        node: TypeCast(
          node.token,
          _res.node,
          node.dataType,
        ),
        value: null,
        type: node.dataType,
      );
    assert(
      _res.type != DataType.unknown,
      'Invalid state: res is computed but type is unknown',
    );

    final _token = Token.synthetic(offset: node.token.offset);
    final literal = switch (node.dataType) {
      DataType.float => Literal<double>(
        _token,
        switch (_res.type) {
          DataType.integer => (_res.value! as int).toDouble(),
          DataType.float => _res.value! as double,
          DataType.unknown => throw StateError('Impossible state'),
        },
        DataType.float,
      ),
      DataType.integer => Literal<int>(
        _token,
        switch (_res.type) {
          DataType.integer => _res.value! as int,
          DataType.float => (_res.value! as double).toInt(),
          DataType.unknown => throw StateError('Impossible state'),
        },
        DataType.integer,
      ),
      DataType.unknown => throw StateError('Impossible state'),
    };
    return _computedLiteral(literal);
  }

  @override
  AstComputed visitLiteral(Literal node, [ void context, ]) =>
    _computedLiteral(node);

  @override
  AstComputed visitUnary(Unary node, [ void context, ]) {
    final _res = _accept(node.right);
    if (_res is AstUncomputed)
      return _uncomputedNode(node, _res.type, context);
    assert(
      _res.type != DataType.unknown,
      'Invalid state: res is computed but type is unknown',
    );

    return _computedLiteral(
      _makeLiteral(
        node.token.offset,
        _res.type,
        switch ((_res.type, node.operator.type)) {
          (DataType.float, TokenType.minus) => -(_res.value! as double),
          (DataType.integer, TokenType.minus) => -(_res.value! as int),
          (final type, final operator) =>
            throw StateError('Unhandled state: $type $operator'),
        },
      ),
    );
  }



  @override
  AstComputed<AstNode, Object?> visitGrouping(Grouping node, [ void context, ]) {
    final _res = _accept(node.expression);
    if (_res is AstUncomputed)
      return _uncomputedNode(node, _res.type, context);
    assert(
      _res.type != DataType.unknown,
      'Invalid state: res is computed but type is unknown',
    );
    return _computedLiteral(
      _makeLiteral(
        node.token.offset,
        _res.type,
        switch (_res.type) {
          DataType.float => _res.value! as double,
          DataType.integer => _res.value! as int,
          final type =>
            throw StateError('Unhandled state: $type'),
        },
      ),
    );
  }

  @override
  AstComputed<AstNode, Object?> visitBinary(Binary node, [ void context, ]) {
    final _left = _accept(node.left, context);
    final _right = _accept(node.right, context);

    if (_left is AstUncomputed || _right is AstUncomputed) {
      final type = _left.type == _right.type
        ? _left.type
        : _right.type;
      return _uncomputedNode(node, type, context);
    }
    assert(
      _right.type != DataType.unknown && _left.type != DataType.unknown,
      'Invalid state: res is computed but type is unknown',
    );

    if (_left.type != _right.type)
      throw StateError('Computed values types differs. Use type cast infuser first.');

    final type = _left.type;

    return _computedLiteral(
      _makeLiteral(
        node.token.offset,
        type,
        switch ((type, node.operator.type)) {
          (DataType.float, TokenType.minus) => (_left.value! as double) - (_right.value! as double),
          (DataType.integer, TokenType.minus) => (_left.value! as int) - (_right.value! as int),
          (DataType.float, TokenType.plus) => (_left.value! as double) + (_right.value! as double),
          (DataType.integer, TokenType.plus) => (_left.value! as int) + (_right.value! as int),
          (DataType.float, TokenType.slash) => (_left.value! as double) / (_right.value! as double),
          (DataType.integer, TokenType.slash) => (_left.value! as int) / (_right.value! as int),
          (DataType.float, TokenType.asterisk) => (_left.value! as double) * (_right.value! as double),
          (DataType.integer, TokenType.asterisk) => (_left.value! as int) * (_right.value! as int),

          (final type, final operator) =>
            throw StateError('Unhandled state: $type $operator'),
        },
      ),
    );
  }
}
