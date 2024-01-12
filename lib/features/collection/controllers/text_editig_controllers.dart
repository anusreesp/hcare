import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textControllerProvider =
    Provider<TextControllers>((ref) => TextControllers());

class TextControllers extends ChangeNotifier {
  TextEditingController sysController = TextEditingController();
  TextEditingController diaController = TextEditingController();
  TextEditingController wController = TextEditingController();
  TextEditingController hController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController commmentController = TextEditingController();

  void clear() {
    sysController.clear();
    diaController.clear();
    wController.clear();
    hController.clear();
    phoneController.clear();
  }

  @override
  void dispose() {
    sysController.dispose();
    diaController.dispose();
    wController.dispose();
    hController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
