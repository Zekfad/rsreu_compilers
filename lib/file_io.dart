import 'dart:io';


class FileIo {
  FileIo(this.file);

  final File file;
  RandomAccessFile? _file;

  void write(Object data) {
    if (_file == null) {
      if (!tryOpen(FileMode.write))
        throw const FileSystemException('Cannot open file for write');
    }
    _file!.writeStringSync(data.toString());
  }

  void writeln(Object data) {
    if (_file == null) {
      if (!tryOpen(FileMode.write))
        throw const FileSystemException('Cannot open file for write');
    }
    _file!.writeStringSync('$data\n');
  }

  Iterable<String> readLines() {
    if (!file.existsSync())
      throw const FileSystemException('Cannot open file for read');
    return file.readAsLinesSync();
  }

  String readAsString() {
    if (!file.existsSync())
      throw const FileSystemException('Cannot open file for read');
    return file.readAsStringSync();
  }

  void close() {
    if (_file != null) {
      _file!.flushSync();
      _file!.closeSync();
    }
  }

  bool tryOpen(FileMode mode) {
    if (mode == FileMode.read && !file.existsSync())
      return false;
    file.createSync();
    _file = file.openSync(mode: mode);
    return true;
  }
}
