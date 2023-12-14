import '../ast.dart';
import '../scanner/tokens/token_type.dart';
import '../symbol_table.dart';
import '../three_address_code.dart';


class AllocationTable {
  AllocationTable({
    required this.symbols,
  }) {
    for (final (_, symbol) in symbols) {
      final register = SymbolRegister(symbol);
      addRegister(register);
      setNodeResult(symbol, register);
    }
  }

  final SymbolTable symbols;
  final List<Register> registers = [];
  final _cachedImmediate = <Object?, Immediate>{};

  final _registersInUse = Expando<bool>();
  final _nodeResultRegisters = Expando<Register>();
  var _lastRumtimeRegisterId = 0;

  bool isRegisterLocked(Register register) => _registersInUse[register] ?? false;
  void lockRegister(Register register) => _registersInUse[register] = true;
  void unlockRegister(Register register) => _registersInUse[register] = null;

  void addRegister(Register register) {
    if (register is! RuntimeRegister)
      lockRegister(register);
    registers.add(register);
  }

  Register getFreeRegister() {
    for (final register in registers) {
      if (!isRegisterLocked(register))
        return register;
    }
    final register = RuntimeRegister('r${_lastRumtimeRegisterId++}');
    registers.add(register);
    return register;
  }

  Register getNodeResult(AstNode node) => _nodeResultRegisters[node]!;
  void setNodeResult(AstNode node, Register register) => _nodeResultRegisters[node] = register;

  Immediate<T> getImmediate<T extends Object?>(T value) {
    if (_cachedImmediate[value] case final existing?)
      return existing as Immediate<T>;

    final immediate = switch (value) {
      final double value => Immediate(value),
      final int value => Immediate(value),
      final value => throw StateError('Unexpected immediate value: $value'),
    } as Immediate<T>;
    addRegister(immediate);
    _cachedImmediate[value] = immediate;
    return immediate;
  }

  SymbolRegister getSymbol(SymbolNode symbol) {
    if (_nodeResultRegisters[symbol] case final existing?)
      return existing as SymbolRegister;
    // Todo(zekfad): handle case when register is exists, but its just node is
    // not linked against it.
    final _symbol = symbols.addIfAbsent(symbol.name, () => symbol);
    final register = SymbolRegister(_symbol);
    addRegister(register);
    setNodeResult(symbol, register);
    setNodeResult(_symbol, register);
    return register;
  }
}

class AstThreeAddressCodeGenerator extends AstVisitorSingleResult<List<Instruction>, void> implements AstVisitorFull<List<Instruction>, void> {
  AstThreeAddressCodeGenerator(this.allocationTable) : super([]);

  final AllocationTable allocationTable;

  Register _allocRegister() => allocationTable.getFreeRegister();

  @override
  List<Instruction> visitBinary(Binary node, [ void context, ]) {
    node.left.accept(this, context);
    final leftResult = allocationTable.getNodeResult(node.left);

    final destination = leftResult is! RuntimeRegister
      ? _allocRegister()
      : leftResult;

    // Lock destination, so it wont be overridden when computing right node
    allocationTable.lockRegister(destination);

    node.right.accept(this, context);
    final resultRight = allocationTable.getNodeResult(node.right);

    allocationTable.unlockRegister(destination);

    final operation = switch(node.operator.type) {
      TokenType.plus => Operation.addition,
      TokenType.minus => Operation.subtraction,
      TokenType.asterisk => Operation.multiplication,
      TokenType.slash => Operation.division,
      final type => throw StateError('Invalid operation type $type'),
    };

    result.add(
      Instruction(
        operation,
        destination,
        [ leftResult, resultRight, ],
      ),
    );

    allocationTable.setNodeResult(node, destination);
    return result;
  }

  @override
  List<Instruction> visitUnary(Unary node, [void context]) {
    super.visitUnary(node, context);
    final resultRight = allocationTable.getNodeResult(node.right);
    final destination = resultRight is! RuntimeRegister
      ? _allocRegister()
      : resultRight;
    final operation = switch(node.operator.type) {
      TokenType.minus => Operation.negate,
      final type => throw StateError('Invalid operation type $type'),
    };
    result.add(
      Instruction(
        operation,
        destination,
        [ resultRight, ],
      ),
    );

    allocationTable.setNodeResult(node, destination);
    return result;
  }

  @override
  List<Instruction> visitTypeCast(TypeCast node, [ void context, ]) {
    super.visitTypeCast(node, context);
    final resultExpression = allocationTable.getNodeResult(node.expression);
    final destination = resultExpression is! RuntimeRegister
      ? _allocRegister()
      : resultExpression;
    result.add(
      Instruction(
        Operation.castIntegerToFloat,
        destination,
        [ resultExpression, ],
      ),
    );

    allocationTable.setNodeResult(node, destination);
    return result;
  }

  @override
  List<Instruction> visitIdentifier(Identifier node, [void context]) {
    allocationTable.setNodeResult(node, allocationTable.getSymbol(node));
    return result;
  }

  @override
  List<Instruction> visitLiteral(Literal<Object?> node, [ void context, ]) {
    allocationTable.setNodeResult(node, allocationTable.getImmediate(node.value));
    return result;
  }

  @override
  List<Instruction> visitType(Type node, [ void context, ]) {
    throw StateError('Type node should never be visited.');
  }

  @override
  List<Instruction> visitGrouping(Grouping node, [ void context, ]) {
    super.visitGrouping(node, context);
    allocationTable.setNodeResult(
      node,
      allocationTable.getNodeResult(node.expression),
    );
    return result;
  }
}
