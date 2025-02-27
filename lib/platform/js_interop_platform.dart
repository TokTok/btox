import 'package:btox/platform/platform_api.dart';

final class AnyPlatform extends PlatformApi {
  static const AnyPlatform instance = AnyPlatform._();

  const AnyPlatform._();

  @override
  bool get isAndroid => false;
  @override
  bool get isFuchsia => false;
  @override
  bool get isIOS => false;
  @override
  bool get isLinux => false;
  @override
  bool get isMacOS => false;
  @override
  bool get isWeb => true;
  @override
  bool get isWindows => false;
}
