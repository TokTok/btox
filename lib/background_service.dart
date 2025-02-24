import 'dart:async';
import 'dart:ui';

import 'package:btox/logger.dart';
import 'package:btox/platform/any_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

const _logger = Logger(['BackgroundService']);

Future<void> initializeService() async {
  if (!AnyPlatform.instance.isMobile) {
    startBackgroundService();
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: _onStart,
      onBackground: _onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: _onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );
}

Future<void> startBackgroundService() async {
  if (!AnyPlatform.instance.isMobile) {
    return _BackgroundService.instance.start();
  }

  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  if (!AnyPlatform.instance.isMobile) {
    _BackgroundService.instance.stop();
    return;
  }

  final service = FlutterBackgroundService();
  service.invoke('stop');
}

@pragma('vm:entry-point')
Future<bool> _onIosBackground(ServiceInstance service) async {
  _logger.d('Processing iOS background fetch');

  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void _onStart(ServiceInstance service) async {
  _logger.d('Starting background service');

  service.on('stop').listen((event) {
    _BackgroundService.instance.stop();
    service.stopSelf();
    _logger.d('Background process is now stopped');
  });

  await _BackgroundService.instance.start();
}

final class _BackgroundService {
  static final _BackgroundService instance = _BackgroundService._();
  bool _isRunning = false;

  _BackgroundService._();

  Future<void> start() async {
    if (_isRunning) {
      return;
    }

    _isRunning = true;
    while (_isRunning) {
      _logger.d(
          'Background service is successfully running ${DateTime.now().minute}');
      await Future.delayed(const Duration(minutes: 1));
    }
  }

  void stop() {
    _isRunning = false;
  }
}
