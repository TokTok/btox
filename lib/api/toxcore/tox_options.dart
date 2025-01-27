final class ToxOptions {
  final bool ipv6Enabled;
  final bool udpEnabled;
  final bool localDiscoveryEnabled;

  const ToxOptions({
    this.ipv6Enabled = true,
    this.udpEnabled = true,
    this.localDiscoveryEnabled = true,
  });
}
