import '../ast.dart';
import '../symbol_table.dart';
import 'ast_printer_context.dart';


class AstPrinterMinimized extends AstVisitor<StringBuffer, AstPrinterContext> implements AstVisitorFull<StringBuffer, AstPrinterContext> {
  AstPrinterMinimized(this.symbolTable);

  final SymbolTable symbolTable;
  final _buffer = StringBuffer();

  static const _defaultContext = AstPrinterContext(''); 

  @override
  StringBuffer visitIdentifier(Identifier node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('<id, ${symbolTable.indexOf(node.name)!}, ${symbolTable.lookup(node.name)!.resolvedDataType.name}>');
    return _buffer;
  }

  @override
  StringBuffer visitType(Type node, [ AstPrinterContext? context, ]) {
    throw StateError('Invalid usage');
  }

  @override
  StringBuffer visitTypeCast(TypeCast node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    if (node.dataType != DataType.float)
      throw UnimplementedError('Unimplemented cast to ${node.dataType}');
    if (node.expression case TypedNode(resolvedDataType: != DataType.integer && final from))
      throw UnimplementedError('Unimplemented cast from $from to ${node.dataType}');
    _buffer.writeln('Int2Float');
    node.expression.accept(this, context.addIndent(_buffer, true));
    return _buffer;
  }

  @override
  StringBuffer visitLiteral(Literal node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('<${node.value}>');
    return _buffer;
  }

  @override
  StringBuffer visitUnary(Unary node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('<${node.operator}>');
    node.right.accept(this, context.addIndent(_buffer, true));
    return _buffer;
  }

  @override
  StringBuffer visitBinary(Binary node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    _buffer.writeln('<${node.operator.lexeme}>');
    node.left.accept(this, context.addIndent(_buffer, false));
    node.right.accept(this, context.addIndent(_buffer, true));
    return _buffer;
  }

  @override
  StringBuffer visitGrouping(Grouping node, [ AstPrinterContext? context, ]) {
    context ??= _defaultContext;
    node.expression.accept(this, context);
    return _buffer;
  }
}
