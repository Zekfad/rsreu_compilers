enum Type : u8 {
    integer,
    floating_point,
};

union _Val {
    double asFloat;
    s64 asInt;
};

struct Value {
  Type type;
  _Val value;
};

struct Symbol {
    Type type;
    u8 name_length;
    char name[name_length];
    padding[1];
};

struct Header {
    u8 runtime_registers_count;
    u8 immediate_values_count;
    Value immediate_values[immediate_values_count];
    u8 symbols_count;
    Symbol symbols[symbols_count];
    u8 instructions_count;
};

enum OperationType : u8 {
    add,
    sub,
    mul,
    div,
    neg,
    i2f,
};

enum RegisterType : u8 {
    runtime,
    immediate,
    symbol,
};

struct RegisterId {
    u8 id;
};

struct RegisterRef {
    RegisterType type;
    RegisterId id;
};

struct Instruction {
    OperationType operation;
    RegisterId destination;
    u8 arguments_count;
    RegisterRef arguments[arguments_count];
};

struct PortableCode {
    Header header;
    Instruction instructions[header.instructions_count];
};

PortableCode code @ 0x0;
