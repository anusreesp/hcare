import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/tab_controller.dart';

class SortbyRowLeadingComponent extends ConsumerWidget {
  const SortbyRowLeadingComponent({super.key, required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(myRidesScreenTabController);
    return Text(
      items[index],
      style: mon16White600,
    );
  }
}
