import 'package:flutter/material.dart';

class AppState {
  final nickName = ValueNotifier<String>('Yanciman');
  final userStatus =
      ValueNotifier<String>('Producing works of art in Kannywood');
}
