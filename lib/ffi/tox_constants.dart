export 'tox_constants.native.dart'
    if (dart.library.html) 'tox_constants.web.dart'
    if (dart.library.js) 'tox_constants.web.dart';
