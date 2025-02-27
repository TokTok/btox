abstract class PlatformApi {
  const PlatformApi();

  bool get isAndroid;
  bool get isDesktop => isMacOS || isWindows || isLinux;
  bool get isFuchsia;
  bool get isIOS;
  bool get isLinux;
  bool get isMacOS;
  bool get isMobile => isAndroid || isIOS;
  bool get isWeb;
  bool get isWindows;
}
