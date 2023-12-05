import 'dart:io';

import 'package:args/args.dart';
import 'package:rsreu_compilers/ast_utlils/ast_printer.dart';
import 'package:rsreu_compilers/ast_utlils/ast_symbol_generator.dart';
import 'package:rsreu_compilers/file_io.dart';
import 'package:rsreu_compilers/parser.dart';
import 'package:rsreu_compilers/scanner.dart';


void printUsage(ArgParser argParser) {
  print('Usage: ${Platform.executable} [command] [arguments]');
  print(argParser.usage);
  for (final MapEntry(key: command, value: parser) in argParser.commands.entries)
    print('Command $command:\n${parser.usage}');
}

Future<List<Token>> getMainTokens(Scanner scanner) async =>
  scanner.tokens.handleError(
    // ignore: avoid_types_on_closure_parameters
    (Object exception) => print(
      'Exception: $exception',
    ),
    test: (e) => e is LexicalException,
  )
    .where((token) => token.type != TokenType.expressionTerminator)
    .toList();

Future<void> main(List<String> arguments) async {  
  final syntaxParser = ArgParser(allowTrailingOptions: false)
    ..addSeparator('  syntax tree dumper: [input] [output]');
  final lexerParser = ArgParser(allowTrailingOptions: false)
    ..addSeparator('  lexer: [input] [tokens] [symbols]');
  final argParser = ArgParser(allowTrailingOptions: false)
    ..addCommand('syn', syntaxParser)
    ..addCommand('SYN', syntaxParser)
    ..addCommand('lex', lexerParser)
    ..addCommand('LEX', lexerParser);

  try {
    final result = argParser.parse(arguments);
    final command = result.command;
    if (command != null)
      switch (command.name) {
        case 'lex' || 'LEX':
          if (command.arguments case [
            final _input,
            final _token,
            final _symbols,
          ]) {
            final inputFile = FileIo(File(_input));
            final tokensFile = FileIo(File(_token));
            final symbolsFile = FileIo(File(_symbols));
            final input = inputFile.readAsString();
            if (!tokensFile.tryOpen(FileMode.write))
              throw const FileSystemException('Cannot open tokens file for write');
            if (!symbolsFile.tryOpen(FileMode.write))
              throw const FileSystemException('Cannot open tokens file for write');

            try {
              final scanner = Scanner(input);
              final tokens = await getMainTokens(scanner);
              final parser = Parser(input, tokens);
              final ast = parser.parse();
              if (ast == null)
                throw Exception('Invalid input');

              final symbols = ast.accept(AstSymbolGenerator())!;

              for (final (id, (_, symbol)) in symbols.indexed) {
                symbolsFile.writeln('<id,$id>\t- ${symbol.name}');
              }

              for (final token in tokens) {
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
                  TokenType.leftSquareBracket => 'открывающая квадратная скобка',
                  TokenType.rightSquareBracket => 'закрывающая квадратная скобка',

                  TokenType.identifier => 'идентификатор с именем ${token.lexeme}',
                  TokenType.integer => 'константа целого типа',
                  TokenType.floatingPoint => 'константа вещественного типа',
                  TokenType.type => 'тип с именем ${token.lexeme}',

                  TokenType.equals => 'операция присвоения',

                  TokenType.expressionTerminator
                    ||TokenType.synthetic
                    || TokenType.eof => throw StateError('Impossible state'),
                };

                tokensFile.writeln('<${token.lexeme}>\t- $text');
              }
              return;
            } finally {
              tokensFile.close();
              symbolsFile.close();
            }
          } else
            throw const FormatException('Invalid arguments count.');
        case 'syn' || 'SYN':
          if (command.arguments case [
            final _input,
            final _output,
          ]) {
            final inputFile = FileIo(File(_input));
            final outputFile = FileIo(File(_output));
            final input = inputFile.readAsString();

            if (!outputFile.tryOpen(FileMode.write))
              throw const FileSystemException('Cannot open output file for write');

            try {
              final scanner = Scanner(input);
              final tokens = await getMainTokens(scanner);
              final parser = Parser(input, tokens);
              final ast = parser.parse();
              if (ast == null)
                throw Exception('Invalid input');

              final printer = AstPrinter();

              outputFile.write(ast.accept(printer)!);
            } finally {
              outputFile.close();
            }
            return;
          } else
            throw const FormatException('Invalid arguments count.');
        default:
          throw StateError('Invalid command state.');
      }
    else
      throw const FormatException('No arguments.');
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(argParser);
    exit(1);
  } on FileSystemException catch (e) {
    print(e.message);
    print('');
    printUsage(argParser);
    exit(2);
  }
}
