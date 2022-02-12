import 'package:flutter/material.dart';

class AppState {
  final nickname = ValueNotifier<String>('Yanciman');
  final statusMessage =
      ValueNotifier<String>('Producing works of art in Kannywood');
}
