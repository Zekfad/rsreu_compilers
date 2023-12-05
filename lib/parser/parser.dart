import '../ast.dart';
import '../scanner.dart';
import 'parser_exception.dart';


class Parser {
  Parser(this.source, this.tokens);

  final String source;
  final List<Token> tokens;

  bool _hasError = false;
  bool get hasError => _hasError;

  ParserException _error(String message, Token token) {
    _hasError = true;
    return ParserException(message, source, token);
  }

  int _current = 0;

  bool get _isAtEnd => _peek().type == TokenType.eof;

  Token _peek() => tokens[_current];
  Token _previous() => tokens[_current -1];

  Token _advance() {
    if (!_isAtEnd)
      _current++;
    return _previous();
  }

  bool _check(TokenType type) {
    if (_isAtEnd)
      return false;
    return _peek().type == type;
  }

  bool _match(List<TokenType> types) {
    for (final type in types) {
      if (_check(type)) {
        _advance();
        return true;
      }
    }

    return false;
  }

  Expression _expression() => _term();

  Expression _leftAssociativeSeries(
    Expression Function() expressionParser,
    List<TokenType> operatorTypes,
  ) {
    var expression = expressionParser();

    while (_match(operatorTypes)) {
      final operator = _previous();
      final right = expressionParser();
      expression = Binary(expression.token, expression, operator, right);
    }

    return expression;
  }

  Expression _term() => _leftAssociativeSeries(
    _factor,
    const [ TokenType.plus, TokenType.minus, ],
  );

  Expression _factor() => _leftAssociativeSeries(
    _unary,
    const [ TokenType.slash, TokenType.asterisk, ],
  );

   Expression _unary() {
    if (_match(const [ TokenType.minus, ])) {
      final operator = _previous();
      final right = _unary();
      return Unary(operator, operator, right);
    }

    return _primary();
  }

  Type _type() {
    final token = _previous();
    final type = switch(token) {
      SymbolToken(name: 'F' || 'f') => DataType.float,
      SymbolToken(name: 'I' || 'i') => DataType.integer,
      _ => throw ParserException('Invalid type', source, token),
    };
    return Type(token, type);
  }

  Expression _primary() {
    if (_match(const [ TokenType.integer, TokenType.floatingPoint, ])) {
      return switch (_previous()) {
        LiteralToken<int>(:final literal?) && final token => Literal(token, literal),
        LiteralToken<double>(:final literal?) && final token => Literal(token, literal),
        final actual =>
          throw StateError('Invalid state, expected literal, got: $actual'),
      };
    }

    if (_match(const [ TokenType.identifier, ])) {
      final identifierToken = _previous();
      final type = _match(const [ TokenType.type, ])
        ? _type()
        : Type.unknown;
      return Identifier(identifierToken, identifierToken.lexeme, type);
    }

    if (_match(const [ TokenType.leftBrace, ])) {
      final expression = _expression();
      _consume(TokenType.rightBrace, 'Expect ")" after expression.');
      return Grouping(expression.token, expression);
    }

    throw _error('Expect expression.', _peek());
  }

  Token _consume(TokenType type, String message) {
    if (_check(type))
      return _advance();

    throw _error(message, _peek());
  }

  Expression? parse() {
    try {
      return _expression();
    // ignore: unused_catch_clause
    } on ParserException catch (exception) {
      print(exception);
      return null;
    }
  }

  // private void synchronize() {
  //   advance();

  //   while (!isAtEnd()) {
  //     if (previous().type == SEMICOLON) return;

  //     switch (peek().type) {
  //       case CLASS:
  //       case FUN:
  //       case VAR:
  //       case FOR:
  //       case IF:
  //       case WHILE:
  //       case PRINT:
  //       case RETURN:
  //         return;
  //     }

  //     advance();
  //   }
  // }
}
