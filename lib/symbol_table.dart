import 'dart:collection';

import 'ast/ast.dart';


class SymbolTable with IterableBase<(String, SymbolNode)> {
  SymbolTable();

  final _symbols = <String, SymbolNode>{};

  SymbolNode? lookup(String name) => _symbols[name];

  void add(SymbolNode symbol) => _symbols[symbol.name] = symbol;

  SymbolNode addIfAbsent(String name, SymbolNode Function() ifAbsent) =>
    _symbols.putIfAbsent(name, ifAbsent);
    
  @override
  Iterator<(String, SymbolNode)> get iterator =>
    _symbols.entries.map((e) => (e.key, e.value)).iterator;
}
