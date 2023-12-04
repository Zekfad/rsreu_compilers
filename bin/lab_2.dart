import 'dart:io';

import 'package:rsreu_compilers/scanner.dart';


Future<void> main(List<String> arguments) async {
  if (arguments.length < 3)
    throw ArgumentError('Not enough arguments.');
  if (arguments.length > 3)
    throw ArgumentError('Too many arguments.');

  final [ inputFile, tokensFile, symbolsFile ] = arguments
    .map(File.new)
    .toList();

  if (!inputFile.existsSync())
    throw Exception('Input file is missing.');

  final tokensSink = tokensFile.openWrite(mode: FileMode.writeOnly);
  final symbolsSink = symbolsFile.openWrite(mode: FileMode.writeOnly);

  final input = inputFile.readAsStringSync();
  final scanner = Scanner(input);

  final tokens = scanner.tokens.handleError(
    // ignore: avoid_types_on_closure_parameters
    (Object exception) => print(
      'Exception: $exception',
    ),
    test: (e) => e is LexicalException,
  );

  final identifiers = <String>[];
  await for (final token in tokens) {
    if (token.type == TokenType.expressionTerminator)
      continue;
    if (token.type == TokenType.eof)
      break;

    final text = switch (token.type) {
      TokenType.plus => 'операция сложения',
      TokenType.minus => 'операция вычитания',
      TokenType.asterisk => 'операция умножения',
      TokenType.slash => 'операция деления',
      TokenType.leftBrace => 'открывающая скобка',
      TokenType.rightBrace => 'закрывающая скобка',

      TokenType.identifier => 'идентификатор с именем ${token.lexeme}',
      TokenType.integer => 'константа целого типа',
      TokenType.floatingPoint => 'константа вещественного типа',
      TokenType.equals => 'операция присвоения',

      TokenType.expressionTerminator || TokenType.eof => throw StateError('Impossible state'),
    };

    if (token.type == TokenType.identifier) {
      var id = identifiers.indexOf(token.lexeme);
      if (id < 0) {
        identifiers.add(token.lexeme);
        id = identifiers.length;
        symbolsSink.writeln('$id - ${token.lexeme}');
      } else
        id++;

      tokensSink.writeln('<id,$id>\t- $text');
    } else
      tokensSink.writeln('<${token.lexeme}>\t- $text');
  }

  await tokensSink.flush();
  await tokensSink.close();

  await symbolsSink.flush();
  await symbolsSink.close();
}
