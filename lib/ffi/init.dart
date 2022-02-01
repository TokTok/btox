import 'dart:ffi';
import 'dart:io';

Future<void> initFfi() async {}

DynamicLibrary loadToxcore() {
  return Platform.isAndroid
      ? DynamicLibrary.open('libtoxcore.so')
      : DynamicLibrary.process();
}
