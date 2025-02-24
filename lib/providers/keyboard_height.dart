import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_height_plugin/keyboard_height_plugin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keyboard_height.g.dart';

@riverpod
Stream<double> keyboardHeight(Ref ref) {
  if (!Platform.isAndroid && !Platform.isIOS) {
    return Stream.empty();
  }
  final _ = KeyboardHeightPlugin();
  return const EventChannel('keyboardHeightEventChannel')
      .receiveBroadcastStream()
      .map((event) => event as double);
}
