// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ast.dart';

class LiteralMapper extends ClassMapperBase<Literal> {
  LiteralMapper._();

  static LiteralMapper? _instance;
  static LiteralMapper ensureInitialized() {
    if (_instance == null) {
      MapperBase.addType<Object>();
      MapperContainer.globals.use(_instance = LiteralMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Literal';
  @override
  Function get typeFactory => <T extends Object?>(f) => f<Literal<T>>();

  static Token _$token(Literal v) => v.token;
  static const Field<Literal, Token> _f$token = Field('token', _$token);
  static Object? _$value(Literal v) => v.value;
  static dynamic _arg$value<T extends Object?>(f) => f<T>();
  static const Field<Literal, Object?> _f$value =
      Field('value', _$value, arg: _arg$value);
  static DataType _$dataType(Literal v) => v.dataType;
  static const Field<Literal, DataType> _f$dataType =
      Field('dataType', _$dataType);

  @override
  final Map<Symbol, Field<Literal, dynamic>> fields = const {
    #token: _f$token,
    #value: _f$value,
    #dataType: _f$dataType,
  };

  static Literal<T> _instantiate<T extends Object?>(DecodingData data) {
    return Literal(
        data.dec(_f$token), data.dec(_f$value), data.dec(_f$dataType));
  }

  @override
  final Function instantiate = _instantiate;

  static Literal<T> fromMap<T extends Object?>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Literal<T>>(map);
  }

  static Literal<T> fromJson<T extends Object?>(String json) {
    return ensureInitialized().decodeJson<Literal<T>>(json);
  }
}

mixin LiteralMappable<T extends Object?> {
  String toJson() {
    return LiteralMapper.ensureInitialized()
        .encodeJson<Literal<T>>(this as Literal<T>);
  }

  Map<String, dynamic> toMap() {
    return LiteralMapper.ensureInitialized()
        .encodeMap<Literal<T>>(this as Literal<T>);
  }

  LiteralCopyWith<Literal<T>, Literal<T>, Literal<T>, T> get copyWith =>
      _LiteralCopyWithImpl(this as Literal<T>, $identity, $identity);
  @override
  String toString() {
    return LiteralMapper.ensureInitialized().stringifyValue(this as Literal<T>);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            LiteralMapper.ensureInitialized()
                .isValueEqual(this as Literal<T>, other));
  }

  @override
  int get hashCode {
    return LiteralMapper.ensureInitialized().hashValue(this as Literal<T>);
  }
}

extension LiteralValueCopy<$R, $Out, T extends Object?>
    on ObjectCopyWith<$R, Literal<T>, $Out> {
  LiteralCopyWith<$R, Literal<T>, $Out, T> get $asLiteral =>
      $base.as((v, t, t2) => _LiteralCopyWithImpl(v, t, t2));
}

abstract class LiteralCopyWith<$R, $In extends Literal<T>, $Out,
    T extends Object?> implements ClassCopyWith<$R, $In, $Out> {
  $R call({Token? token, T? value, DataType? dataType});
  LiteralCopyWith<$R2, $In, $Out2, T> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LiteralCopyWithImpl<$R, $Out, T extends Object?>
    extends ClassCopyWithBase<$R, Literal<T>, $Out>
    implements LiteralCopyWith<$R, Literal<T>, $Out, T> {
  _LiteralCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Literal> $mapper =
      LiteralMapper.ensureInitialized();
  @override
  $R call({Token? token, T? value, DataType? dataType}) =>
      $apply(FieldCopyWithData({
        if (token != null) #token: token,
        if (value != null) #value: value,
        if (dataType != null) #dataType: dataType
      }));
  @override
  Literal<T> $make(CopyWithData data) => Literal(
      data.get(#token, or: $value.token),
      data.get(#value, or: $value.value),
      data.get(#dataType, or: $value.dataType));

  @override
  LiteralCopyWith<$R2, Literal<T>, $Out2, T> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LiteralCopyWithImpl($value, $cast, t);
}

class UnaryMapper extends ClassMapperBase<Unary> {
  UnaryMapper._();

  static UnaryMapper? _instance;
  static UnaryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UnaryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Unary';

  static Token _$token(Unary v) => v.token;
  static const Field<Unary, Token> _f$token = Field('token', _$token);
  static Token _$operator(Unary v) => v.operator;
  static const Field<Unary, Token> _f$operator = Field('operator', _$operator);
  static Expression _$right(Unary v) => v.right;
  static const Field<Unary, Expression> _f$right = Field('right', _$right);

  @override
  final Map<Symbol, Field<Unary, dynamic>> fields = const {
    #token: _f$token,
    #operator: _f$operator,
    #right: _f$right,
  };

  static Unary _instantiate(DecodingData data) {
    return Unary(data.dec(_f$token), data.dec(_f$operator), data.dec(_f$right));
  }

  @override
  final Function instantiate = _instantiate;

  static Unary fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Unary>(map);
  }

  static Unary fromJson(String json) {
    return ensureInitialized().decodeJson<Unary>(json);
  }
}

mixin UnaryMappable {
  String toJson() {
    return UnaryMapper.ensureInitialized().encodeJson<Unary>(this as Unary);
  }

  Map<String, dynamic> toMap() {
    return UnaryMapper.ensureInitialized().encodeMap<Unary>(this as Unary);
  }

  UnaryCopyWith<Unary, Unary, Unary> get copyWith =>
      _UnaryCopyWithImpl(this as Unary, $identity, $identity);
  @override
  String toString() {
    return UnaryMapper.ensureInitialized().stringifyValue(this as Unary);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            UnaryMapper.ensureInitialized().isValueEqual(this as Unary, other));
  }

  @override
  int get hashCode {
    return UnaryMapper.ensureInitialized().hashValue(this as Unary);
  }
}

extension UnaryValueCopy<$R, $Out> on ObjectCopyWith<$R, Unary, $Out> {
  UnaryCopyWith<$R, Unary, $Out> get $asUnary =>
      $base.as((v, t, t2) => _UnaryCopyWithImpl(v, t, t2));
}

abstract class UnaryCopyWith<$R, $In extends Unary, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Token? token, Token? operator, Expression? right});
  UnaryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UnaryCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Unary, $Out>
    implements UnaryCopyWith<$R, Unary, $Out> {
  _UnaryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Unary> $mapper = UnaryMapper.ensureInitialized();
  @override
  $R call({Token? token, Token? operator, Expression? right}) =>
      $apply(FieldCopyWithData({
        if (token != null) #token: token,
        if (operator != null) #operator: operator,
        if (right != null) #right: right
      }));
  @override
  Unary $make(CopyWithData data) => Unary(
      data.get(#token, or: $value.token),
      data.get(#operator, or: $value.operator),
      data.get(#right, or: $value.right));

  @override
  UnaryCopyWith<$R2, Unary, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UnaryCopyWithImpl($value, $cast, t);
}

class BinaryMapper extends ClassMapperBase<Binary> {
  BinaryMapper._();

  static BinaryMapper? _instance;
  static BinaryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BinaryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Binary';

  static Token _$token(Binary v) => v.token;
  static const Field<Binary, Token> _f$token = Field('token', _$token);
  static Expression _$left(Binary v) => v.left;
  static const Field<Binary, Expression> _f$left = Field('left', _$left);
  static Token _$operator(Binary v) => v.operator;
  static const Field<Binary, Token> _f$operator = Field('operator', _$operator);
  static Expression _$right(Binary v) => v.right;
  static const Field<Binary, Expression> _f$right = Field('right', _$right);

  @override
  final Map<Symbol, Field<Binary, dynamic>> fields = const {
    #token: _f$token,
    #left: _f$left,
    #operator: _f$operator,
    #right: _f$right,
  };

  static Binary _instantiate(DecodingData data) {
    return Binary(data.dec(_f$token), data.dec(_f$left), data.dec(_f$operator),
        data.dec(_f$right));
  }

  @override
  final Function instantiate = _instantiate;

  static Binary fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Binary>(map);
  }

  static Binary fromJson(String json) {
    return ensureInitialized().decodeJson<Binary>(json);
  }
}

mixin BinaryMappable {
  String toJson() {
    return BinaryMapper.ensureInitialized().encodeJson<Binary>(this as Binary);
  }

  Map<String, dynamic> toMap() {
    return BinaryMapper.ensureInitialized().encodeMap<Binary>(this as Binary);
  }

  BinaryCopyWith<Binary, Binary, Binary> get copyWith =>
      _BinaryCopyWithImpl(this as Binary, $identity, $identity);
  @override
  String toString() {
    return BinaryMapper.ensureInitialized().stringifyValue(this as Binary);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            BinaryMapper.ensureInitialized()
                .isValueEqual(this as Binary, other));
  }

  @override
  int get hashCode {
    return BinaryMapper.ensureInitialized().hashValue(this as Binary);
  }
}

extension BinaryValueCopy<$R, $Out> on ObjectCopyWith<$R, Binary, $Out> {
  BinaryCopyWith<$R, Binary, $Out> get $asBinary =>
      $base.as((v, t, t2) => _BinaryCopyWithImpl(v, t, t2));
}

abstract class BinaryCopyWith<$R, $In extends Binary, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Token? token, Expression? left, Token? operator, Expression? right});
  BinaryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BinaryCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Binary, $Out>
    implements BinaryCopyWith<$R, Binary, $Out> {
  _BinaryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Binary> $mapper = BinaryMapper.ensureInitialized();
  @override
  $R call(
          {Token? token,
          Expression? left,
          Token? operator,
          Expression? right}) =>
      $apply(FieldCopyWithData({
        if (token != null) #token: token,
        if (left != null) #left: left,
        if (operator != null) #operator: operator,
        if (right != null) #right: right
      }));
  @override
  Binary $make(CopyWithData data) => Binary(
      data.get(#token, or: $value.token),
      data.get(#left, or: $value.left),
      data.get(#operator, or: $value.operator),
      data.get(#right, or: $value.right));

  @override
  BinaryCopyWith<$R2, Binary, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BinaryCopyWithImpl($value, $cast, t);
}

class GroupingMapper extends ClassMapperBase<Grouping> {
  GroupingMapper._();

  static GroupingMapper? _instance;
  static GroupingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Grouping';

  static Token _$token(Grouping v) => v.token;
  static const Field<Grouping, Token> _f$token = Field('token', _$token);
  static Expression _$expression(Grouping v) => v.expression;
  static const Field<Grouping, Expression> _f$expression =
      Field('expression', _$expression);

  @override
  final Map<Symbol, Field<Grouping, dynamic>> fields = const {
    #token: _f$token,
    #expression: _f$expression,
  };

  static Grouping _instantiate(DecodingData data) {
    return Grouping(data.dec(_f$token), data.dec(_f$expression));
  }

  @override
  final Function instantiate = _instantiate;

  static Grouping fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Grouping>(map);
  }

  static Grouping fromJson(String json) {
    return ensureInitialized().decodeJson<Grouping>(json);
  }
}

mixin GroupingMappable {
  String toJson() {
    return GroupingMapper.ensureInitialized()
        .encodeJson<Grouping>(this as Grouping);
  }

  Map<String, dynamic> toMap() {
    return GroupingMapper.ensureInitialized()
        .encodeMap<Grouping>(this as Grouping);
  }

  GroupingCopyWith<Grouping, Grouping, Grouping> get copyWith =>
      _GroupingCopyWithImpl(this as Grouping, $identity, $identity);
  @override
  String toString() {
    return GroupingMapper.ensureInitialized().stringifyValue(this as Grouping);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            GroupingMapper.ensureInitialized()
                .isValueEqual(this as Grouping, other));
  }

  @override
  int get hashCode {
    return GroupingMapper.ensureInitialized().hashValue(this as Grouping);
  }
}

extension GroupingValueCopy<$R, $Out> on ObjectCopyWith<$R, Grouping, $Out> {
  GroupingCopyWith<$R, Grouping, $Out> get $asGrouping =>
      $base.as((v, t, t2) => _GroupingCopyWithImpl(v, t, t2));
}

abstract class GroupingCopyWith<$R, $In extends Grouping, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Token? token, Expression? expression});
  GroupingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GroupingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Grouping, $Out>
    implements GroupingCopyWith<$R, Grouping, $Out> {
  _GroupingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Grouping> $mapper =
      GroupingMapper.ensureInitialized();
  @override
  $R call({Token? token, Expression? expression}) => $apply(FieldCopyWithData({
        if (token != null) #token: token,
        if (expression != null) #expression: expression
      }));
  @override
  Grouping $make(CopyWithData data) => Grouping(
      data.get(#token, or: $value.token),
      data.get(#expression, or: $value.expression));

  @override
  GroupingCopyWith<$R2, Grouping, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _GroupingCopyWithImpl($value, $cast, t);
}

class TypeMapper extends ClassMapperBase<Type> {
  TypeMapper._();

  static TypeMapper? _instance;
  static TypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TypeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Type';

  static Token _$token(Type v) => v.token;
  static const Field<Type, Token> _f$token = Field('token', _$token);
  static DataType _$dataType(Type v) => v.dataType;
  static const Field<Type, DataType> _f$dataType =
      Field('dataType', _$dataType);

  @override
  final Map<Symbol, Field<Type, dynamic>> fields = const {
    #token: _f$token,
    #dataType: _f$dataType,
  };

  static Type _instantiate(DecodingData data) {
    return Type(data.dec(_f$token), data.dec(_f$dataType));
  }

  @override
  final Function instantiate = _instantiate;

  static Type fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Type>(map);
  }

  static Type fromJson(String json) {
    return ensureInitialized().decodeJson<Type>(json);
  }
}

mixin TypeMappable {
  String toJson() {
    return TypeMapper.ensureInitialized().encodeJson<Type>(this as Type);
  }

  Map<String, dynamic> toMap() {
    return TypeMapper.ensureInitialized().encodeMap<Type>(this as Type);
  }

  TypeCopyWith<Type, Type, Type> get copyWith =>
      _TypeCopyWithImpl(this as Type, $identity, $identity);
  @override
  String toString() {
    return TypeMapper.ensureInitialized().stringifyValue(this as Type);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            TypeMapper.ensureInitialized().isValueEqual(this as Type, other));
  }

  @override
  int get hashCode {
    return TypeMapper.ensureInitialized().hashValue(this as Type);
  }
}

extension TypeValueCopy<$R, $Out> on ObjectCopyWith<$R, Type, $Out> {
  TypeCopyWith<$R, Type, $Out> get $asType =>
      $base.as((v, t, t2) => _TypeCopyWithImpl(v, t, t2));
}

abstract class TypeCopyWith<$R, $In extends Type, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Token? token, DataType? dataType});
  TypeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TypeCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Type, $Out>
    implements TypeCopyWith<$R, Type, $Out> {
  _TypeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Type> $mapper = TypeMapper.ensureInitialized();
  @override
  $R call({Token? token, DataType? dataType}) => $apply(FieldCopyWithData({
        if (token != null) #token: token,
        if (dataType != null) #dataType: dataType
      }));
  @override
  Type $make(CopyWithData data) => Type(data.get(#token, or: $value.token),
      data.get(#dataType, or: $value.dataType));

  @override
  TypeCopyWith<$R2, Type, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TypeCopyWithImpl($value, $cast, t);
}

class TypeCastMapper extends ClassMapperBase<TypeCast> {
  TypeCastMapper._();

  static TypeCastMapper? _instance;
  static TypeCastMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TypeCastMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TypeCast';

  static Token _$token(TypeCast v) => v.token;
  static const Field<TypeCast, Token> _f$token = Field('token', _$token);
  static Expression _$expression(TypeCast v) => v.expression;
  static const Field<TypeCast, Expression> _f$expression =
      Field('expression', _$expression);
  static DataType _$dataType(TypeCast v) => v.dataType;
  static const Field<TypeCast, DataType> _f$dataType =
      Field('dataType', _$dataType);

  @override
  final Map<Symbol, Field<TypeCast, dynamic>> fields = const {
    #token: _f$token,
    #expression: _f$expression,
    #dataType: _f$dataType,
  };

  static TypeCast _instantiate(DecodingData data) {
    return TypeCast(
        data.dec(_f$token), data.dec(_f$expression), data.dec(_f$dataType));
  }

  @override
  final Function instantiate = _instantiate;

  static TypeCast fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TypeCast>(map);
  }

  static TypeCast fromJson(String json) {
    return ensureInitialized().decodeJson<TypeCast>(json);
  }
}

mixin TypeCastMappable {
  String toJson() {
    return TypeCastMapper.ensureInitialized()
        .encodeJson<TypeCast>(this as TypeCast);
  }

  Map<String, dynamic> toMap() {
    return TypeCastMapper.ensureInitialized()
        .encodeMap<TypeCast>(this as TypeCast);
  }

  TypeCastCopyWith<TypeCast, TypeCast, TypeCast> get copyWith =>
      _TypeCastCopyWithImpl(this as TypeCast, $identity, $identity);
  @override
  String toString() {
    return TypeCastMapper.ensureInitialized().stringifyValue(this as TypeCast);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            TypeCastMapper.ensureInitialized()
                .isValueEqual(this as TypeCast, other));
  }

  @override
  int get hashCode {
    return TypeCastMapper.ensureInitialized().hashValue(this as TypeCast);
  }
}

extension TypeCastValueCopy<$R, $Out> on ObjectCopyWith<$R, TypeCast, $Out> {
  TypeCastCopyWith<$R, TypeCast, $Out> get $asTypeCast =>
      $base.as((v, t, t2) => _TypeCastCopyWithImpl(v, t, t2));
}

abstract class TypeCastCopyWith<$R, $In extends TypeCast, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Token? token, Expression? expression, DataType? dataType});
  TypeCastCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TypeCastCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TypeCast, $Out>
    implements TypeCastCopyWith<$R, TypeCast, $Out> {
  _TypeCastCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TypeCast> $mapper =
      TypeCastMapper.ensureInitialized();
  @override
  $R call({Token? token, Expression? expression, DataType? dataType}) =>
      $apply(FieldCopyWithData({
        if (token != null) #token: token,
        if (expression != null) #expression: expression,
        if (dataType != null) #dataType: dataType
      }));
  @override
  TypeCast $make(CopyWithData data) => TypeCast(
      data.get(#token, or: $value.token),
      data.get(#expression, or: $value.expression),
      data.get(#dataType, or: $value.dataType));

  @override
  TypeCastCopyWith<$R2, TypeCast, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _TypeCastCopyWithImpl($value, $cast, t);
}
