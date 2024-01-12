import 'package:flutter_riverpod/flutter_riverpod.dart';

final collectionStepController = StateProvider.autoDispose<int>((ref) => 0);

// final cancelOrRescheduledProvider = StateProvider.autoDispose<bool>((ref) {
//   return true;
// });

// final isRideStartProvider = StateProvider.autoDispose<bool>((ref) {
//   return true;
// });
// final isRideCompletedProvider = StateProvider.autoDispose<bool>((ref) {
//   return false;
// });
