import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripIdProvider = StateProvider<String>((ref) {
  return '';
});

final tripStartProvider = StateProvider<bool>((ref) {
  return false;
});

final tripEndProvider = StateProvider<bool>((ref) {
  return false;
});
