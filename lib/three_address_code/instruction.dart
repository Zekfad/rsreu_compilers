import '../three_address_code.dart';


class Instruction {
  const Instruction(this.operation, this.destination, this.arguments);
  final Operation operation;
  final RuntimeRegister destination;
  final List<Register> arguments;

  @override
  String toString() => '$operation\t$destination\t${arguments.join('\t')}';
}
