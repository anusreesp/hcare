import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPopupMenuButton extends ConsumerWidget {
  final void Function(String) onPopupSelected;
  final List<String> items;
  final SvgPicture icon;
  final String label;
  final Color iconColor;
  final TextStyle labelTextStyle;
  final bool noInitial;
  final StateProvider<String> provider;
  const MainPopupMenuButton(
      {super.key,
      required this.onPopupSelected,
      required this.items,
      required this.icon,
      required this.label,
      this.noInitial = false,
      this.iconColor = HcTheme.whiteColor,
      this.labelTextStyle = mon14White,
      required this.provider});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final selected = ref.watch(provider);
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        onPopupSelected(value);
        ref.read(provider.notifier).state = value;
      },
      itemBuilder: (BuildContext context) {
        return buildPopupItemsList(selected);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 4,
          ),
          Text(
            label,
            style: labelTextStyle,
          )
        ],
      ),
    );
  }

  List<PopupMenuEntry<String>> buildPopupItemsList(String selected) {
    List<PopupMenuEntry<String>> menuItems = [];
    for (var value in items) {
      final item = PopupMenuItem(
        value: value,
        child: PopUpMenuItemComponent(
          itemTitle: value,
          selected: selected,
        ),
      );
      menuItems.add(item);
    }
    return menuItems;
  }
}

class PopUpMenuItemComponent extends StatelessWidget {
  const PopUpMenuItemComponent(
      {super.key, required this.itemTitle, required this.selected});
  final String itemTitle;
  final String selected;
  @override
  Widget build(BuildContext context) {
    bool isSelected = selected == itemTitle;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.radio_button_checked,
          color: isSelected ? HcTheme.greenColor : HcTheme.lightGrey1Color,
        ),
        Text(itemTitle),
      ],
    );
  }
}
