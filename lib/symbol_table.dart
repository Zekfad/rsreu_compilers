import 'dart:collection';

import 'ast/ast.dart';


class SymbolTable with IterableBase<(String, Symbol)> {
  SymbolTable();

  final _symbols = <String, Symbol>{};

  Symbol? lookup(String name) => _symbols[name];

  void add(Symbol symbol) => _symbols[symbol.name] = symbol;

  Symbol addIfAbsent(String name, Symbol Function() ifAbsent) =>
    _symbols.putIfAbsent(name, ifAbsent);
    
  @override
  Iterator<(String, Symbol)> get iterator =>
    _symbols.entries.map((e) => (e.key, e.value)).iterator;
}
