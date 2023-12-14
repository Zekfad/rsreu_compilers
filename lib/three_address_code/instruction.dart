import 'package:rsreu_compilers/three_address_code/operation.dart';
import 'package:rsreu_compilers/three_address_code/register.dart';

class Instruction {
  const Instruction(this.operation, this.destination, this.arguments);
  final Operation operation;
  final Register destination;
  final List<Register> arguments;

  @override
  String toString() => '$operation\t$destination\t${arguments.join('\t')}';
}
