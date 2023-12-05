import '../ast.dart';
import '../semantics/semantic_exception.dart';
import '../symbol_table.dart';


class AstSymbolGenerator extends AstVisitorSingleResult<SymbolTable, String> {
  AstSymbolGenerator() : super(SymbolTable());

  @override
  SymbolTable visitIdentifier(Identifier node, [ String? context, ]) {
    final symbol = result.addIfAbsent(node.name, () => node);
    if (symbol.type != node.type && node.type.dataType != DataType.unknown)
      throw SemanticException('Identifier type redefinition', context ?? '<NO SOURCE>', node);
    return super.visitIdentifier(node, context);
  }
}
