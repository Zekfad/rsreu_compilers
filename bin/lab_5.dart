import 'dart:io';

import 'package:args/args.dart';
import 'package:rsreu_compilers/ast_utils/ast_add_implicit_type_casts.dart';
import 'package:rsreu_compilers/ast_utils/ast_compute_const.dart';
import 'package:rsreu_compilers/ast_utils/ast_postfix_form_generator.dart';
import 'package:rsreu_compilers/ast_utils/ast_printer.dart';
import 'package:rsreu_compilers/ast_utils/ast_printer_minimized.dart';
import 'package:rsreu_compilers/ast_utils/ast_symbol_generator.dart';
import 'package:rsreu_compilers/ast_utils/ast_three_address_code_generator.dart';
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
  final lexerParser = ArgParser(allowTrailingOptions: false)
    ..addSeparator('  lexer: [input] [tokens] [symbols]');
  final syntaxParser = ArgParser(allowTrailingOptions: false)
    ..addSeparator('  syntax tree dumper: [input] [syntax_tree]');
  final semanticParser = ArgParser(allowTrailingOptions: false)
    ..addSeparator('  semantic analyzer: [input] [syntax_tree]');
  final threeAddressCodeGeneratorParser = ArgParser(allowTrailingOptions: false)
    ..addSeparator('  three-address code generator: [input] [portable_code] [symbols]');
  final postfixFormParser = ArgParser(allowTrailingOptions: false)
    ..addSeparator('  postfix form generator: [input] [postfix] [symbols]');
  final argParser = ArgParser(allowTrailingOptions: false)
    ..addCommand('lex', lexerParser)
    ..addCommand('LEX', lexerParser)
    ..addCommand('syn', syntaxParser)
    ..addCommand('SYN', syntaxParser)
    ..addCommand('sem', semanticParser)
    ..addCommand('SEM', semanticParser)
    ..addCommand('gen1', threeAddressCodeGeneratorParser)
    ..addCommand('GEN1', threeAddressCodeGeneratorParser)
    ..addCommand('gen2', postfixFormParser)
    ..addCommand('GEN2', postfixFormParser);

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
            return await lexMode(_input, _token, _symbols);
          } else
            throw const FormatException('Invalid arguments count.');
        case 'syn' || 'SYN':
          if (command.arguments case [
            final _input,
            final _syntaxTree,
          ]) {
            return await synMode(_input, _syntaxTree);
          } else
            throw const FormatException('Invalid arguments count.');
        case 'sem' || 'SEM':
          if (command.arguments case [
            final _input,
            final _syntaxTree,
          ]) {
            return await semMode(_input, _syntaxTree);
          } else
            throw const FormatException('Invalid arguments count.');
        case 'gen1' || 'GEN1':
          if (command.arguments case [
            final _input,
            final _portableCode,
            final _symbols,
          ]) {
            return await gen1Mode(_input, _portableCode, _symbols);
          } else
            throw const FormatException('Invalid arguments count.');
        case 'gen2' || 'GEN2':
          if (command.arguments case [
            final _input,
            final _postfix,
            final _symbols,
          ]) {
            return await gen2Mode(_input, _postfix, _symbols);
          } else
            throw const FormatException('Invalid arguments count.');
        default:
          throw StateError('Invalid command state.');
      }
    else
      throw const FormatException('No arguments.');
  } on FormatException catch (e) {
    print(e);
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

Future<void> lexMode(String _input, String _token, String _symbols) async {
  final inputFile = FileIo(File(_input));
  final tokensFile = FileIo(File(_token));
  final symbolsFile = FileIo(File(_symbols));
  final source = inputFile.readAsString();

  if (!tokensFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open tokens file for write');
  if (!symbolsFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open tokens file for write');
  
  try {
    final scanner = Scanner(source);
    final tokens = await getMainTokens(scanner);
    final parser = Parser(source, tokens);
    final ast = parser.parse();
    if (ast == null)
      throw Exception('Invalid input');
  
    final symbols = ast.accept(AstSymbolGenerator(), source)!;
  
    for (final (id, (_, symbol)) in symbols.indexed) {
      symbolsFile.writeln('<id,$id>\t- ${symbol.name} [${symbol.resolvedDataType}]');
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
  
        TokenType.identifier => 'идентификатор с именем ${(token as SymbolToken).name}',
        TokenType.integer => 'константа целого типа',
        TokenType.floatingPoint => 'константа вещественного типа',
        TokenType.type => 'тип с именем ${(token as SymbolToken).name}',
  
        TokenType.equals => 'операция присвоения',
  
        TokenType.expressionTerminator
          ||TokenType.synthetic
          || TokenType.eof => throw StateError('Impossible state'),
      };
  
      tokensFile.writeln('<${token.lexeme}>\t- $text');
    }
  } finally {
    tokensFile.close();
    symbolsFile.close();
  }
}

Future<void> synMode(String _input, String _syntaxTree) async {
  final inputFile = FileIo(File(_input));
  final syntaxTreeFile = FileIo(File(_syntaxTree));
  final source = inputFile.readAsString();
  
  if (!syntaxTreeFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open output file for write');
  
  try {
    final scanner = Scanner(source);
    final tokens = await getMainTokens(scanner);
    final parser = Parser(source, tokens);
    final ast = parser.parse();
    if (ast == null)
      throw Exception('Invalid input');
  
    final symbols = ast.accept(AstSymbolGenerator(), source)!;
    final printer = AstPrinterMinimized(symbols);
  
    syntaxTreeFile.write(ast.accept(printer)!);
  } finally {
    syntaxTreeFile.close();
  }
}

Future<void> semMode(String _input, String _syntaxTree) async {
  final inputFile = FileIo(File(_input));
  final syntaxTreeFile = FileIo(File(_syntaxTree));
  final source = inputFile.readAsString();
  
  if (!syntaxTreeFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open output file for write');
  
  try {
    final scanner = Scanner(source);
    final tokens = await getMainTokens(scanner);
    final parser = Parser(source, tokens);
    final ast = parser.parse();
    if (ast == null)
      throw Exception('Invalid input');
  
    final symbols = ast.accept(AstSymbolGenerator(), source)!;
    final printer = AstPrinterMinimized(symbols);

    final (astWithImplicitCasts, _) = ast.accept(const AstAddImplicitTypeCasts(), symbols)!;
    final AstComputed(node: astOptimized) = astWithImplicitCasts.accept(const AstComputeConst(), source)!;

    syntaxTreeFile.write(astOptimized.accept(printer)!);
  } finally {
    syntaxTreeFile.close();
  }
}

Future<void> gen1Mode(String _input, String _portableCode, String _symbols) async {
  final inputFile = FileIo(File(_input));
  final portableCodeFile = FileIo(File(_portableCode));
  final symbolsFile = FileIo(File(_symbols));
  final source = inputFile.readAsString();

  if (!portableCodeFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open portable code file for write');
  if (!symbolsFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open symbols file for write');
  
  try {
    final scanner = Scanner(source);
    final tokens = await getMainTokens(scanner);
    final parser = Parser(source, tokens);
    final ast = parser.parse();
    if (ast == null)
      throw Exception('Invalid input');
  
    final symbols = ast.accept(AstSymbolGenerator(), source)!;
  
    for (final (id, (_, symbol)) in symbols.indexed) {
      symbolsFile.writeln('<id,$id>\t- ${symbol.name} [${symbol.resolvedDataType}]');
    }

    final (astWithImplicitCasts, _) = ast.accept(const AstAddImplicitTypeCasts(), symbols)!;
    astWithImplicitCasts.accept(const AstComputeConst(), source)!;
    final AstComputed(node: astOptimized) = astWithImplicitCasts.accept(const AstComputeConst(), source)!;
    final generator = AstThreeAddressCodeGenerator(
      AllocationTable(
        symbols: symbols,
      ),
    );
    final portableCode = astOptimized.accept(generator)!;

    portableCodeFile.write(portableCode.join('\n'));
  } finally {
    portableCodeFile.close();
    symbolsFile.close();
  }
}

Future<void> gen2Mode(String _input, String _postfix, String _symbols) async {
  final inputFile = FileIo(File(_input));
  final postfixFile = FileIo(File(_postfix));
  final symbolsFile = FileIo(File(_symbols));
  final source = inputFile.readAsString();

  if (!postfixFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open postfix file for write');
  if (!symbolsFile.tryOpen(FileMode.write))
    throw const FileSystemException('Cannot open symbols file for write');
  
  try {
    final scanner = Scanner(source);
    final tokens = await getMainTokens(scanner);
    final parser = Parser(source, tokens);
    final ast = parser.parse();
    if (ast == null)
      throw Exception('Invalid input');
  
    final symbols = ast.accept(AstSymbolGenerator(), source)!;
  
    for (final (id, (_, symbol)) in symbols.indexed) {
      symbolsFile.writeln('<id,$id>\t- ${symbol.name} [${symbol.resolvedDataType}]');
    }

    final postfix = ast.accept(AstPostfixFormGenerator())!;
  
    final (astWithImplicitCasts, _) = ast.accept(const AstAddImplicitTypeCasts(), symbols)!;
    astWithImplicitCasts.accept(const AstComputeConst(), source)!;

    postfixFile.write(postfix);

  } finally {
    postfixFile.close();
    symbolsFile.close();
  }
}
