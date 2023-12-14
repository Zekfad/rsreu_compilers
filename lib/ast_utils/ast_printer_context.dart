const _cross = ' ├─';
const _corner = ' └─';
const _vertical = ' │ ';
const _space = '   ';

class AstPrinterContext {
  const AstPrinterContext(this.indent);

  final String indent;

  AstPrinterContext addIndent(StringBuffer buffer, bool isLast) {
    buffer
      ..write(indent)
      ..write(isLast ? _corner : _cross);
    return AstPrinterContext(
      indent + (isLast ? _space : _vertical),
    );
  }
}
