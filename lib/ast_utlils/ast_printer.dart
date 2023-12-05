import '../ast.dart';
import '../scanner.dart';


const _cross = ' ├─';
const _corner = ' └─';
const _vertical = ' │ ';
const _space = '   ';

class AstPrinterContext {
  const AstPrinterContext(this.indent);

  final String indent;

  AstPrinterContext copyWith({ String? indent, }) =>
    AstPrinterContext(
      indent ?? this.indent,
    );
  
  AstPrinterContext addIndent(StringBuffer buffer, bool isLast) {
    buffer
      ..write(indent)
      ..write(isLast ? _corner : _cross);
    return AstPrinterContext(
      indent + (isLast ? _space : _vertical),
    );
  }
}

class AstPrinter extends AstVisitor<StringBuffer, AstPrinterContext> {
  final _buffer = StringBuffer();

  static const _defaultContext = AstPrinterContext(''); 

  StringBuffer? _visitToken(Token token, [ AstPrinterContext? context, ]) =>
    _buffer..writeln('Token: ${token.type.name} ${token.lexeme}');

  StringBuffer? _visitNull(String text, [ AstPrinterContext? context, ]) =>
    _buffer..writeln(text);

  StringBuffer? _tryAccept(Expression? expression, {
    AstPrinterContext? context,
    String? fallbackText,
  }) => expression != null
    ? expression.accept(this, context)
    : (fallbackText != null
      ? _visitNull(fallbackText, context)
      : _buffer
    );

  @override
  StringBuffer? visitIdentifier(Identifier node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('Identifier: ${node.name}');
    _tryAccept(
      fallbackText: 'Type: Untyped',
      context: context.addIndent(_buffer, true),
      node.type,
    );
    return _buffer;
  }

  @override
  StringBuffer? visitType(Type node, [ AstPrinterContext? context, ]) =>
    _buffer..writeln('Type: ${node.dataType}');

  @override
  StringBuffer? visitTypeCast(TypeCast node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('TypeCast');
    node.type.accept(this, context.addIndent(_buffer, true));
    return _buffer;
  }

  @override
  StringBuffer? visitLiteral(Literal node, [ AstPrinterContext? context, ]) =>
    _buffer..writeln('Literal: ${node.value}');

  @override
  StringBuffer? visitUnary(Unary node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('Unary');
    _visitToken(node.operator, context.addIndent(_buffer, false));
    node.right.accept(this, context.addIndent(_buffer, true));
    return _buffer;
  }

  @override
  StringBuffer? visitBinary(Binary node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('Binary');
    node.left.accept(this, context.addIndent(_buffer, false));
    _visitToken(node.operator, context.addIndent(_buffer, false));
    node.right.accept(this, context.addIndent(_buffer, true));
    return _buffer;
  }

  @override
  StringBuffer? visitGrouping(Grouping node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('Grouping');
    node.expression.accept(this, context.addIndent(_buffer, true));
    return _buffer;
  }
}