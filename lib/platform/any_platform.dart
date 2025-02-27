export 'unsupported_platform.dart'
    if (dart.library.io) 'io_platform.dart'
    if (dart.library.js_interop) 'js_interop_platform.dart';
