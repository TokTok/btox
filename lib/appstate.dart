import 'package:flutter/material.dart';

class AppState {
  final nickNameValNotifier = ValueNotifier<String>('Yanciman');
  final userStatusValNotifier =
      ValueNotifier<String>('Producing works of art in Kannywood');

  set nickName(String value) {
    nickNameValNotifier.value = value;
  }

  String get nickName => nickNameValNotifier.value;

  set userStatus(String value) {
    userStatusValNotifier.value = value;
  }

  String get userStatus => userStatusValNotifier.value;
}
