#include <stdint.h>

#pragma pack(push, 1)
enum Type : uint8_t {
  integer,
  floating_point,
};

struct Value {
  Type type;
  union {
    double asFloat;
    int64_t asInt;
  } value;
};

struct Symbol {
  Type type;
  uint8_t length;
  char * name;
};

struct Header {
  uint8_t runtime_registers_count;
  uint8_t immediate_values_count;
  Value * immediate_values;
  uint8_t symbols_count;
  Symbol * symbols;
  uint8_t instructions_count;
};

enum OperationType : uint8_t {
  op_add,
  op_sub,
  op_mul,
  op_div,
  op_neg,
  op_i2f,
};

enum RegisterType : uint8_t {
  runtime,
  immediate,
  symbol,
};

struct RegisterId {
  uint8_t id;
};

struct RegisterRef {
  RegisterType type;
  RegisterId id;
};

struct Instruction {
  OperationType operation;
  RegisterId destination;
  uint8_t arguments_count;
  RegisterRef * arguments;
};

struct PortableCode {
  Header header;
  Instruction * instructions;
};

struct RuntimeRegister {
  Value data;
};
#pragma pack(pop)
