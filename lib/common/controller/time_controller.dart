import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTimeProvider = StateProvider.autoDispose<TimeOfDay>((ref) {
  return TimeOfDay.now();
});

final currentCollectionTimeProvider =
    StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});

final collectionTimeProvider = StateProvider<String>((ref) {
  return '';
});

final changedCollectionTimeProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});
final finalCollectionTimeProvider = StateProvider.autoDispose<DateTime?>((ref) {
  return null;
});
