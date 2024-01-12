import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> showPassword = ValueNotifier(true);
class MainTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  const MainTextField({
    Key? key,
    this.hintText,
    this.controller, this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showPassword,
      builder: (context,val,_) {
        return TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter $hintText";
            } else {
              return null;
            }
          },
          controller: controller,
          cursorColor: HcTheme.greenColor,
          obscureText:isPassword ? val : false,
          decoration: InputDecoration(
            suffixIcon:isPassword ? IconButton(
              icon: Icon(val ? Icons.visibility_outlined : Icons.visibility_off_outlined,color: HcTheme.lightGrey3Color),
              onPressed: (){
                showPassword.value = !val;
              },
            ) : null,
            hintText: hintText,
            hintStyle: mon12lightGrey3,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: HcTheme.lightGrey2Color, width: 1.5)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: HcTheme.greenColor, width: 2)),
          ),
        );
      }
    );
  }
}

class LargeTextField extends StatelessWidget {
  final String? hintText;
  final void Function(String) onChanged;
  const LargeTextField({
    super.key,
    this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      onChanged: onChanged,
      maxLines: 3,
      cursorColor: HcTheme.greenColor,
      decoration: const InputDecoration(
        hintStyle: mon12lightGrey3,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HcTheme.lightGrey2Color, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HcTheme.greenColor, width: 2)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $hintText";
        } else {
          return null;
        }
      },
    );
  }
}
