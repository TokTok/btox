import 'dart:io';

import 'package:btox/platform/platform_api.dart';

final class AnyPlatform extends PlatformApi {
  static const AnyPlatform instance = AnyPlatform._();

  const AnyPlatform._();

  @override
  bool get isAndroid => Platform.isAndroid;
  @override
  bool get isFuchsia => Platform.isFuchsia;
  @override
  bool get isIOS => Platform.isIOS;
  @override
  bool get isLinux => Platform.isLinux;
  @override
  bool get isMacOS => Platform.isMacOS;
  @override
  bool get isWeb => false;
  @override
  bool get isWindows => Platform.isWindows;
}
