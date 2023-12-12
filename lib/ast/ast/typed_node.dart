part of '../ast.dart';

abstract interface class TypedNode implements AstNode {
  DataType get resolvedDataType;
}
