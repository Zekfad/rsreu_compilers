#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "data.hpp"
#include <functional>

bool readPortableCode(FILE * file, PortableCode * code) {
  Header & header = code->header;

  if (!fread(&header.runtime_registers_count, sizeof(uint8_t), 1, file))
    return false;

  if (!fread(&header.immediate_values_count, sizeof(uint8_t), 1, file))
    return false;
  header.immediate_values = (Value *)malloc(header.immediate_values_count * sizeof(Value));
  if (!fread(header.immediate_values, sizeof(Value), header.immediate_values_count, file))
    return false;

  if (!fread(&header.symbols_count, sizeof(uint8_t), 1, file))
    return false;
  header.symbols = (Symbol *)malloc(header.symbols_count * sizeof(Symbol));
  for (uint8_t i = 0; i < header.symbols_count; i++) {
    Symbol & symbol = header.symbols[i];
    if (!fread(&symbol.type, sizeof(Type), 1, file))
      return false;
    if (!fread(&symbol.length, sizeof(uint8_t), 1, file))
      return false;
    symbol.name = (char *)malloc(sizeof(char) * symbol.length + 1);
    if (!fread(symbol.name, sizeof(char), symbol.length + 1, file))
      return false;
  }

  if (!fread(&header.instructions_count, sizeof(uint8_t), 1, file))
    return false;

  Instruction * & instructions = code->instructions = (Instruction *)malloc(
    header.instructions_count * sizeof(Instruction)
  );

  for (uint8_t i = 0; i < header.instructions_count; i++) {
    Instruction & instruction = instructions[i];
    if (!fread(&instruction.operation, sizeof(OperationType), 1, file))
      return false;
    if (!fread(&instruction.destination.id, sizeof(uint8_t), 1, file))
      return false;
    if (!fread(&instruction.arguments_count, sizeof(uint8_t), 1, file))
      return false;
    instruction.arguments = (RegisterRef *)malloc(sizeof(RegisterRef));

    for (uint8_t j = 0; j < instruction.arguments_count; j++) {
      RegisterRef & argument = instruction.arguments[j];
      if (!fread(&argument.type, sizeof(RegisterType), 1, file))
        return false;
      if (!fread(&argument.id.id, sizeof(uint8_t), 1, file))
        return false;
    }
  }
  return true;
}


int main(int argc, char * argv[]) {
  if (argc < 2) {
    fputs("Input file required.\n", stderr);
    return 1;
  }

  char * filename = argv[1];

  FILE * file = nullptr;
  fopen_s(&file, filename, "rb");
  if (file == nullptr) {
    fputs("Invalid input, failed to open file.\n", stderr);
    return 2;
  }

  PortableCode code {};

  bool r = readPortableCode(file, &code);
  printf("Loaded %" PRIu8 " instruction(s).\n", code.header.instructions_count);

  RuntimeRegister * runtimeRegisters = (RuntimeRegister *)calloc((size_t)code.header.runtime_registers_count, sizeof(RuntimeRegister));
  printf("Allocated %" PRIu8 " runtime register(s).\n", code.header.runtime_registers_count);

  RuntimeRegister * symbols = (RuntimeRegister *)calloc((size_t )code.header.symbols_count, sizeof(RuntimeRegister));
  char const * type_names[] {
    "Integer",
    "Float",
  };
  printf("Allocated %" PRIu8 " symbol(s).\n", code.header.symbols_count);

  for (uint8_t i; i < code.header.symbols_count; i++) {
    auto & symbol = code.header.symbols[i];
    printf("Type value for symbol %s (%s): ", symbol.name, type_names[symbol.type]);
    symbols[i].data.type = symbol.type;
    int res = 0;
    if (symbol.type == Type::integer) {
      res = scanf_s("%" SCNd64, &symbols[i].data.value.asInt);
    } else if (symbol.type == Type::floating_point) {
      res = scanf_s("%lf", &symbols[i].data.value.asFloat);
    }
    if (res <= 0) {
      printf("Invalid input.\n");
      return 3;
    }
  }

  std::function<Value * (RegisterRef *ref)> resolveValue = [code, runtimeRegisters, symbols](RegisterRef * ref) {
    if (ref == nullptr)
      return (Value *)nullptr;
    switch (ref->type) {
      case runtime:
        return &(runtimeRegisters[ref->id.id].data);
      case immediate:
        return &(code.header.immediate_values[ref->id.id]);
      case symbol:
        return &(symbols[ref->id.id].data);
    }
  };

  RuntimeRegister * dst = nullptr;
  for (uint8_t i; i < code.header.instructions_count; i++) {
    auto & instruction = code.instructions[i];

    dst = &runtimeRegisters[instruction.destination.id];

    RegisterRef * l_ref = instruction.arguments;
    RegisterRef * r_ref = instruction.arguments_count > 1
      ? instruction.arguments + 1
      : nullptr;

    Value * l_val = resolveValue(l_ref);
    Value * r_val = resolveValue(r_ref);

    // We always copy type of result to dst register
    dst->data.type = l_val->type;
    switch (l_val->type) {
      case integer: {
        switch (instruction.operation) {
          case OperationType::op_add:
            dst->data.value.asInt = l_val->value.asInt + r_val->value.asInt;
            break;
          case OperationType::op_sub:
            dst->data.value.asInt = l_val->value.asInt - r_val->value.asInt;
            break;
          case OperationType::op_mul:
            dst->data.value.asInt = l_val->value.asInt * r_val->value.asInt;
            break;
          case OperationType::op_div:
            dst->data.value.asInt = l_val->value.asInt / r_val->value.asInt;
            break;
          case OperationType::op_neg:
            dst->data.value.asInt = -l_val->value.asInt;
            break;
          case OperationType::op_i2f:
            dst->data.type = Type::floating_point;
            dst->data.value.asFloat = static_cast<double>(l_val->value.asInt);
            break;
        };
        break;
      }
      case floating_point: {
        switch (instruction.operation) {
          case OperationType::op_add:
            dst->data.value.asFloat = l_val->value.asFloat + r_val->value.asFloat;
            break;
          case OperationType::op_sub:
            dst->data.value.asFloat = l_val->value.asFloat - r_val->value.asFloat;
            break;
          case OperationType::op_mul:
            dst->data.value.asFloat = l_val->value.asFloat * r_val->value.asFloat;
            break;
          case OperationType::op_div:
            dst->data.value.asFloat = l_val->value.asFloat / r_val->value.asFloat;
            break;
          case OperationType::op_neg:
            dst->data.value.asFloat = -l_val->value.asFloat;
            break;
          case OperationType::op_i2f:
            dst->data.type = Type::floating_point;
            break;
        };
        break;
      }
    }
  }
  if (dst == nullptr) {
    printf("Result is missing, possible empty instructions block\n");
    return 4;
  }
  printf("Result = ");
  switch (dst->data.type) {
    case integer:
      printf("%" PRId64, dst->data.value.asInt);
    case floating_point:
      printf("%f", dst->data.value.asFloat);
  }
  printf("\n");
  return 0;
}
