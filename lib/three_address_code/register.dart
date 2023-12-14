import '../ast.dart';


sealed class Register {
  const Register(this.name);

  final String name;

  @override
  String toString() => '<Register:$name>';
}

final class RuntimeRegister extends Register {
  const RuntimeRegister(super.name);

  @override
  String toString() => '<r:$name>';
}

final class Immediate<T extends Object?> extends Register {
  const Immediate(this.value) : super('<IMMEDIATE>');

  final T value;

  @override
  String toString() => '<i:$value>';
}

final class SymbolRegister extends Register {
  SymbolRegister(this.symbol) : super(symbol.name);

  final SymbolNode symbol;

  @override
  String toString() => '<s:$name>';
}
