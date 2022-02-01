import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'tox.dart';
import 'ffi/proxy.dart';

const nodeHost = 'tox.herokuapp.com';
const nodePort = 443;
const nodePublicKey =
    '348B3819804E258CF76FB0AC2758D169B5904AC0504BAEEFFC360B46B2A12649';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFfi();

  var tox = ToxWrapper.create(udpEnabled: false, localDiscoveryEnabled: false);
  tox.bootstrap("127.0.0.1", 33445, nodePublicKey);
  tox.addTcpRelay(nodeHost, nodePort, nodePublicKey);
  Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
    var before = tox.selfConnectionStatus;
    tox.iterate();
    var after = tox.selfConnectionStatus;

    if (before != after) {
      print('Connection status changed from $before to $after');
    }
  });

  runApp(const App());
}
