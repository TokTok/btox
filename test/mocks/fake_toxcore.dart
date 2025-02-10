// Fake implementation of the Tox class for testing purposes.
import 'package:btox/api/toxcore/tox.dart' as api;
import 'package:btox/api/toxcore/tox_events.dart';

final class FakeToxcore extends api.Tox {
  @override
  String name = 'Yanciman';

  @override
  String statusMessage = 'Producing works of art in Kannywood';

  @override
  String get address {
    return '52602D8D81573725A77F602A53CD1CD8C2156595E8C3310EAC3552E99B7FB50D897BC532A375';
  }

  @override
  bool get isAlive => true;

  @override
  int get iterationInterval => 20;

  @override
  void addTcpRelay(String host, int port, String publicKey) {}

  @override
  void bootstrap(String host, int port, String publicKey) {}

  @override
  List<Event> iterate() {
    return [];
  }

  @override
  void kill() {}
}
