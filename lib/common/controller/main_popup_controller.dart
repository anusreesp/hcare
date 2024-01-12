import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeFilter = StateProvider<String>((ref) => "Today");
final homeSort = StateProvider<String>((ref) => "Time ascending");
final collectionFilter = StateProvider<String>((ref) => "Today");
final collectionSort = StateProvider<String>((ref) => "Time Ascending");
final historySort = StateProvider<String>((ref) => "Today");