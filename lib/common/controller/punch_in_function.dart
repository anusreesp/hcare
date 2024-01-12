import 'package:drmohans_homecare_flutter/common/widgets/bottom_sheet.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/screens/photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void punchIn(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return PunchInScreen(
        onPressed: () async {
          ImagePicker picker = ImagePicker();
          XFile? image = await picker.pickImage(
            source: ImageSource.camera,
          );
          if (image != null) {
            if (!context.mounted) {
              return;
            }

            Navigator.of(ctx).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PhotoScreen(image: image),
            ));
          }
        },
      );
    },
  );
}