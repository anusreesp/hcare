import 'package:flutter/cupertino.dart';

import '../../theme.dart';

class MainBackgroundComponent extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final List<double>? stops;
  final double? height;
  const MainBackgroundComponent(
      {Key? key, required this.child, this.padding, this.stops, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
          color: HcTheme.blueColor,
          gradient: LinearGradient(
            colors: const [HcTheme.blueColor, HcTheme.whiteColor],
            stops: stops,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: child,
    );
  }
}
