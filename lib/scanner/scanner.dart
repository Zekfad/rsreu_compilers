import 'dart:async';

import 'lexical_exception.dart';
import 'tokens.dart';


class Scanner {
  Scanner(this.source);

  final String source;

  bool _hasError = false;
  late final _controller = StreamController<Token>(
    onListen: _scanTokens,
  );

  Stream<Token> get tokens => _controller.stream;
  bool get hasError => _hasError;

  void _addToken(TokenType type) =>
    _controller.add(
      Token(
        type  : type,
        lexeme: source.substring(_start, _current),
        offset: _start,
      ),
    );

  void _addLiteral<T extends Object>(TokenType type, T literal) =>
    _controller.add(
      LiteralToken<T>(
        type   : type,
        lexeme : source.substring(_start, _current),
        offset : _start,
        literal: literal,
      ),
    );

  void _addSymbol(TokenType type, String name) =>
    _controller.add(
      SymbolToken(
        type  : type,
        lexeme: source.substring(_start, _current),
        offset: _start,
        name  : name,
      ),
    );

  void _addError(String message, [int? position]) {
    _hasError = true;
    _controller.addError(
      LexicalException(
        message,
        source,
        position ?? _current - 1,
      ),
    );
  }

  int _start = 0;
  int _current = 0;

  /// Whether we're at the end of input.
  bool get _isAtEnd => _current >= source.length;

  /// Get current character and advance pointer single time.
  String _advance() => source[_current++]; 

  /// Peek current character.
  String _peek() {
    if (_isAtEnd)
      return '';
    return source[_current];
  }

  /// Peek 1 character ahead.
  String _peekNext() {
    if (_current + 1 >= source.length)
      return '';
    return source[_current + 1];
  }

  /// Advance if current character matched [expected].
  // ignore: unused_element
  bool _match(String expected) {
    if (_isAtEnd)
      return false;
    if (source[_current] != expected)
      return false;
  
    _current++;
    return true;
  }

  bool _isDigit(String character) {
    final code = character.codeUnits.singleOrNull;
    if (code == null)
      return false;
    return code >= 0x30 && code <= 0x39;
  }

  bool _isAlpha(String character) {
    final code = character.codeUnits.singleOrNull;
    if (code == null)
      return false;
    return (code >= 0x41 && code <= 0x5a) // A-Z
      || (code >= 0x61 && code <= 0x7A) // a-z
      || code == 0x5F; // _
  }

  bool _isAlphaNumeric(String character) =>
    _isAlpha(character) || _isDigit(character);

  // void _scanNumber() {
  //   while (_isDigit(_peek()))
  //     _advance();
    
  //   if (_peek() == '.' && _isDigit(_peekNext())) {
  //     // consume the '.'
  //     _advance();

  //     while (_isDigit(_peek()))
  //       _advance();

  //     return _addLiteral(
  //       TokenType.floatingPoint,
  //       double.parse(source.substring(_start, _current)),
  //     );
  //   }
  //   return _addLiteral(
  //     TokenType.integer,
  //     int.parse(source.substring(_start, _current)),
  //   );
  // }


  void _scanType() {
    while (_peek() != ']' && !_isAtEnd) {
      if (!_isAlpha(_peek())) {
        _addError('Unexpected character in type');
        return;
      }
      _advance();
    }

    if (_isAtEnd) {
      _addError('Unterminated type, expected right square bracket');
      return;
    }

    // Consume the closing "]".
    _advance();
    
    _addSymbol(
      TokenType.type,
      source.substring(_start + 1, _current - 1),
    );
  }

  void _scanIdentifier() {
    while (_isAlphaNumeric(_peek()))
      _advance();
    _addSymbol(
      TokenType.identifier,
      source.substring(_start, _current),
    );
  }

  /// Scans one of the following:
  /// * alpha-numeric identifier (starts with an integer).
  /// * floating point number
  /// * integer
  void _scanNumberOrIdentifier() {
    var identifier = false;

    while (!_isAtEnd) {
      final c = _peek();

      // if contains at least one alpha then it's an identifier
      if (_isAlpha(c)) {
        identifier = true;
        _advance();
        continue;
      }
      
      if (!identifier && c == '.' && _isDigit(_peekNext())) {
        // consume the '.'
        _advance();
        // Because we check only for digits it is possible
        // to match something like "1.1var"
        // But that's out of scope of lexer, we can later
        // determine that such adjacent tokens are invalid.
        while (_isDigit(_peek()))
          _advance();

        return _addLiteral(
          TokenType.floatingPoint,
          double.parse(source.substring(_start, _current)),
        );
      }

      if (_isDigit(c)) {
        _advance();
        continue;
      }

      break;
    }

    if (identifier) {
      _addError('Identifier starts with number', _start);
      return _addSymbol(
        TokenType.identifier,
        source.substring(_start, _current),
      );
    }

    return _addLiteral(
      TokenType.integer,
      int.parse(source.substring(_start, _current)),
    );
  }

  void _scanToken() {
    final c = _advance();
    switch (c) {
      // Ignore whitespace
      case ' ' || '\n' || '\r' || '\t' || ';': _addToken(TokenType.expressionTerminator);

      case '(': _addToken(TokenType.leftBrace);
      case ')': _addToken(TokenType.rightBrace);
      case '[': _scanType();
      case ']': {
        _addError('Unexpected right square bracket');
        break;
      }
      case '+': _addToken(TokenType.plus);
      case '-': _addToken(TokenType.minus);
      case '*': _addToken(TokenType.asterisk);
      case '/': _addToken(TokenType.slash);
      case '=': _addToken(TokenType.equals);

      default: {
        if (_isAlpha(c)) {
          _scanIdentifier();
          break;
        }
        if (_isDigit(c)) {
          // _scanNumber();

          // Number or identifier
          _scanNumberOrIdentifier();
          break;
        }
        _addError('Unexpected character "$c"');
      }
    }
  }

  Future<void> _scanTokens() {
    while (!_isAtEnd) {
      // We are at the beginning of the next lexeme.
      _start = _current;
      _scanToken();
    }

    _start = _current;
    _addToken(TokenType.eof);
    return _controller.close();
  }
}
