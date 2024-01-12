import 'package:drmohans_homecare_flutter/features/my_rides/controllers/tab_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabComponent extends ConsumerWidget {
  const TabComponent({super.key, required this.tabLabelList});
  final List<String> tabLabelList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        tabLabelList.length,
        (index) => TabItem(
          label: tabLabelList[index],
          onTap: () {
            ref.read(myRidesScreenTabController.notifier).state = index;
          },
          index: index,
        ),
      ),
    );
  }
}

class TabItem extends ConsumerWidget {
  const TabItem({
    super.key,
    required this.label,
    required this.onTap,
    required this.index,
  });
  final String label;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(myRidesScreenTabController);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          border: selected == index
              ? const Border(
                  bottom: BorderSide(width: 2, color: HcTheme.whiteColor))
              : null,
        ),
        child: selected == index
            ? Text(
                label,
                style: mon14White,
              )
            : Text(
                label.split("(")[0],
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(162, 255, 255, 255)),
              ),
      ),
    );
  }
}
