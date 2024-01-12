import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationReachedProvider = StateProvider<bool>((ref) {
  return false;
});

final pickupInitialedProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final itemCountProvider = StateProvider<int>((ref) {
  return 0;
});
