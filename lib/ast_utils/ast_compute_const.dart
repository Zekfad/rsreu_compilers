import '../ast.dart';
import '../scanner.dart';
import '../semantics/semantic_exception.dart';


typedef AstComputed<N extends AstNode, T extends Object?> = ({N node, T? value, DataType type});
// ignore: prefer_void_to_null
typedef AstUncomputed<N extends AstNode> = AstComputed<N, Null>;

/// Modifies AST to compute constant expressions and known operations, such as
/// multiplication by 1 or 0 and so on.
class AstComputeConst extends AstVisitor<AstComputed, String>  implements AstVisitorFull<AstComputed, String> {
  const AstComputeConst();

  AstComputed<Literal, Object?> _computedLiteral(Literal literal) => (
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

  AstComputed<N, T> _accept<N extends AstNode, T extends Object>(N node, [ String? context, ]) =>
    node.accept(this, context)! as AstComputed<N, T>;

  AstUncomputed<N> _uncomputedNode<N extends AstNode>(N node, DataType type, [ String? context, ]) =>
    (node: node, value: null, type: type);

  AstUncomputed<N> _uncomputedTypedNode<N extends TypedNode>(N node, [ String? context, ]) =>
    _uncomputedNode(node, node.resolvedDataType, context);

  @override
  AstUncomputed<Identifier> visitIdentifier(Identifier node, [ String? context, ]) =>
    _uncomputedTypedNode(node, context);

  @override
  AstUncomputed<Type> visitType(Type node, [ String? context, ]) =>
    _uncomputedTypedNode(node, context);

  @override
  AstComputed visitTypeCast(TypeCast node, [ String? context, ]) {
    final _res = _accept(node.expression, context);
    if (_res is AstUncomputed || node.dataType == DataType.unknown)
      return _uncomputedNode(
        node.copyWith(
          expression: _res.node,
        ),
        node.dataType,
        context,
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
  AstComputed visitLiteral(Literal node, [ String? context, ]) =>
    _computedLiteral(node);

  @override
  AstComputed visitUnary(Unary node, [ String? context, ]) {
    final _res = _accept(node.right, context);
    if (_res is AstUncomputed)
      return _uncomputedNode(
        node.copyWith(
          right: _res.node,
        ),
        _res.type,
        context,
      );
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
  AstComputed<AstNode, Object?> visitGrouping(Grouping node, [ String? context, ]) {
    // Since we need groups only to divert operator precedence, we can unwrap
    // group and leave only inner expression.
    final _res = _accept(node.expression, context);
    if (_res is AstUncomputed)
      return _res;
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
  AstComputed<AstNode, Object?> visitBinary(Binary node, [ String? context, ]) {
    final _left = _accept(node.left, context);
    final _right = _accept(node.right, context);

    // Try to pre compute known expressions, e.g. multiplication by zero. 
    if (_right.node case final Literal _rightLiteral) {
      final precomputed = switch ((node.operator.type, _rightLiteral.value)) {
        (TokenType.slash, 0 || 0.0) =>
          throw SemanticException('Division by zero', context ?? '<NO SOURCE>', _rightLiteral),
        (TokenType.asterisk, 0 || 0.0) => _computedLiteral(
          _makeLiteral(
            _rightLiteral.token.offset,
            _rightLiteral.dataType,
            switch (_rightLiteral.dataType) {
              DataType.integer => 0,
              DataType.float => 0.0,
              DataType.unknown => throw StateError('Unexpected unknown type'),
            },
          ),
        ),
        (TokenType.slash || TokenType.asterisk, 1 || 1.0) => _left,
        (TokenType.minus || TokenType.plus, 0 || 0.0) => _left,
        _ => null,
      };
      if (precomputed != null)
        return precomputed;
    }

    if (_left is AstUncomputed) {
      final type = _left.type == _right.type
        ? _left.type
        : DataType.unknown;

      // Check that `_right` is computed
      if (
        _left.node case final Binary _leftBinary when
        _right is! AstUncomputed && type != DataType.unknown
      ) {
        // Check that type of right node is the same as type of left Binary's
        // right node
        // 
        // Binary
        //   Binary
        //     UNCOMPUTED
        //     _leftBinary.right <- left Binary's right node
        //   _right              <- right node
        //
        // If they have the same type AND operation is the same then we can
        // apply operation between `_leftBinary.right` and `_right` and then
        // remove outer Binary.
        if (
          _leftBinary.right.runtimeType == _right.node.runtimeType &&
          _leftBinary.operator.type == node.operator.type
        ) {
          final _newLeft = _accept(_leftBinary.right, context);
          
          if (_newLeft is AstUncomputed)
            return _uncomputedNode(
              node.copyWith(
                left: _left.node,
                right: _right.node,
              ),
              type,
              context,
            );

          assert(
            _newLeft.type != DataType.unknown,
            'Invalid state: res is computed but type is unknown',
          );

          if (_newLeft.type != _right.type)
            throw StateError('Invalid state computed values types differs, despite outer types are the same.');

          final computed = _computeBinary(node, type, _newLeft, _right, context);

          return _uncomputedNode(
            _leftBinary.copyWith(
              right: computed.node,
            ),
            type,
            context,
          );
        }
      }

      return _uncomputedNode(
        node.copyWith(
          left: _left.node,
          right: _right.node,
        ),
        type,
        context,
      );
    }

    if (_right is AstUncomputed) {
      final type = _left.type == _right.type
        ? _left.type
        : DataType.unknown;
      return _uncomputedNode(
        node.copyWith(
          left: _left.node,
          right: _right.node,
        ),
        type,
        context,
      );
    }

    assert(
      _right.type != DataType.unknown && _left.type != DataType.unknown,
      'Invalid state: res is computed but type is unknown',
    );

    if (_left.type != _right.type)
      throw StateError('Computed values types differs. Use type cast infuser first.');

    final type = _left.type;

    return _computeBinary(node, type, _left, _right, context);
  }

  AstComputed<Literal, Object?> _computeBinary(
    Binary node,
    DataType type,
    AstComputed<Expression, Object> _left,
    AstComputed<Expression, Object> _right,
    [ String? context, ]
  ) => _computedLiteral(
    _makeLiteral(
      node.token.offset,
      type,
      switch ((type, node.operator.type)) {
        (DataType.float, TokenType.minus) => (_left.value! as double) - (_right.value! as double),
        (DataType.integer, TokenType.minus) => (_left.value! as int) - (_right.value! as int),
        (DataType.float, TokenType.plus) => (_left.value! as double) + (_right.value! as double),
        (DataType.integer, TokenType.plus) => (_left.value! as int) + (_right.value! as int),
        (DataType.float || DataType.integer, TokenType.slash) when _right.value == 0 =>
          throw SemanticException('Division by zero', context ?? '<NO SOURCE>', _right.node),
        (DataType.float, TokenType.slash) => (_left.value! as double) / (_right.value! as double),
        (DataType.integer, TokenType.slash) => (_left.value! as int) ~/ (_right.value! as int),
        (DataType.float, TokenType.asterisk) => (_left.value! as double) * (_right.value! as double),
        (DataType.integer, TokenType.asterisk) => (_left.value! as int) * (_right.value! as int),

        (final type, final operator) =>
          throw StateError('Unhandled state: $type $operator'),
      },
    ),
  );
}
