import 'package:btox/platform/platform_api.dart';

final class AnyPlatform extends PlatformApi {
  static const AnyPlatform instance = AnyPlatform._();

  const AnyPlatform._();

  @override
  bool get isAndroid => throw UnimplementedError('Unsupported platform');
  @override
  bool get isFuchsia => throw UnimplementedError('Unsupported platform');
  @override
  bool get isIOS => throw UnimplementedError('Unsupported platform');
  @override
  bool get isLinux => throw UnimplementedError('Unsupported platform');
  @override
  bool get isMacOS => throw UnimplementedError('Unsupported platform');
  @override
  bool get isWeb => throw UnimplementedError('Unsupported platform');
  @override
  bool get isWindows => throw UnimplementedError('Unsupported platform');
}
