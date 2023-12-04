import '../ast.dart';
import '../symbol_table.dart';


class AstSymbolGenerator extends AstVisitorSingleResult<SymbolTable, void> {
  AstSymbolGenerator() : super(SymbolTable());

  @override
  SymbolTable visitIdentifier(Identifier node, [ void context, ]) {
    result.addIfAbsent(node.name, () => node);
    return super.visitIdentifier(node, context);
  }
}
