import 'package:flutter/material.dart';

class AppState {
  var nickName = ValueNotifier<String>('Yanciman');
  var userStatus = ValueNotifier<String>('Producing works of art in Kannywood');

  void setNick(String nickName) {
    this.nickName = ValueNotifier<String>(nickName);
  }

  String getNick() {
    return nickName.value;
  }

  void setUserStatus(String userStatus) {
    this.userStatus = ValueNotifier<String>(userStatus);
  }

  String getUserStatus() {
    return userStatus.value;
  }
}
