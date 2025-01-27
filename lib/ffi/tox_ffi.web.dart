import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tox_ffi.web.g.dart';

final class ToxFfi {
  const ToxFfi();
}

@riverpod
ToxFfi toxFfi(Ref ref) {
  return const ToxFfi();
}
