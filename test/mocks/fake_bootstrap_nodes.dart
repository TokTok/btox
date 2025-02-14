import 'package:btox/models/bootstrap_nodes.dart';
import 'package:btox/models/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

BootstrapNodeList fakeBootstrapNodesProvider(Ref ref) {
  return BootstrapNodeList(
    lastRefresh: 0,
    lastScan: 0,
    nodes: [
      BootstrapNode(
        ipv4: '127.0.0.1',
        ipv6: '',
        maintainer: 'The Tox Project',
        location: 'Global',
        statusUdp: true,
        statusTcp: true,
        version: '0.2.20',
        motd: 'Welcome to the Tox bootstrap node!',
        lastPing: 0,
        port: 33445,
        publicKey: PublicKey.fromJson(
            'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'),
        tcpPorts: [33446],
      ),
    ],
  );
}
