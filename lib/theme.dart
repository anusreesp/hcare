import 'package:flutter/material.dart';

const montserrat = "Montserrat";

class HcTheme {
  static TextTheme darkTextTheme = const TextTheme();

  static ThemeData light() {
    return ThemeData(
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: HcTheme.greenColor),
      brightness: Brightness.light,
      scaffoldBackgroundColor: whiteColor,
      fontFamily: montserrat,
      primaryColor: blueColor,
      textSelectionTheme: TextSelectionThemeData(cursorColor: HcTheme.greenColor,selectionColor: HcTheme.greenColor.withOpacity(0.5),selectionHandleColor: HcTheme.greenColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: blueColor,
        elevation: 0,
        titleTextStyle: mon14White500,
      ),
      inputDecorationTheme:
          const InputDecorationTheme(hintStyle: mon12lightGrey3),
      radioTheme: const RadioThemeData(
        fillColor: MaterialStatePropertyAll(greenColor),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: greenColor,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(color: lightGreen2Color)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white2Color,
      ),
    );
  }

  //White
  static const whiteColor = Color(0xffffffff);
  static const white1Color = Color(0xfff8f8fB);
  static const white2Color = Color(0xFFFCFCFC);

  //blue
  static const blueColor = Color(0xff0074bf);
  static const lightBlue1Color = Color(0xfff2f8fc);
  static const lightBlue2Color = Color(0xFFB7E1FD);
  static const lightBlue3Color = Color(0xFFEBF4FA);

  //light grey
  static const lightGrey1Color = Color.fromARGB(255, 214, 214, 214);
  static const lightGrey4Color = Color(0xFFEFEEF1);
  static const lightGrey2Color = Color(0xFFC2C0C0);
  static const lightGrey3Color = Color(0xff8b7c7c);

  //dark grey
  static const darkGrey1Color = Color(0xFF737070);
  static const darkGrey2Color = Color(0xFF616269);
  static const darkGrey3Color = Color(0xFF707070);

  //black
  static const black1Color = Color(0xff110101);
  static const blackColor = Color(0xff000000);

  //green
  static const brightGreenColor = Color(0xFF2B9927);

  //light green
  static const greenColor = Color(0xff26a57e);
  static const lightGreen1Color = Color(0xFFE3F8F3);
  static const lightGreen2Color = Color(0xFF7FF6D1);

  //Red Color
  static const redColor = Color(0xFFFF6060);
}

//Text style
const TextStyle mon24White600 = TextStyle(
  fontFamily: montserrat,
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: HcTheme.whiteColor,
);

const TextStyle mon18white = TextStyle(
  fontFamily: montserrat,
  fontSize: 18,
  color: HcTheme.whiteColor,
  fontWeight: FontWeight.w500,
);

const TextStyle mon18Black = TextStyle(
  fontFamily: montserrat,
  fontSize: 18,
  color: HcTheme.blackColor,
);

const TextStyle mon18BlackSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: HcTheme.black1Color,
);

const TextStyle mon18BGreen = TextStyle(
  fontFamily: montserrat,
  fontSize: 18,
  color: HcTheme.brightGreenColor,
);

const TextStyle mon16White600 = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HcTheme.whiteColor,
);

const TextStyle mon16White = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  color: HcTheme.whiteColor,
);

const TextStyle mon16Black = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: HcTheme.black1Color,
);

const TextStyle mon16BlackSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HcTheme.black1Color,
);

const TextStyle mon16WhiteSBold = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HcTheme.whiteColor,
);
const TextStyle mon16BGreen = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  color: HcTheme.brightGreenColor,
);
const TextStyle mon16lightGreenSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HcTheme.lightGreen2Color,
);

const TextStyle mon14White = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  color: HcTheme.whiteColor,
);
const TextStyle mon14White500 = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  color: HcTheme.whiteColor,
  fontWeight: FontWeight.w500,
);
const TextStyle mon14WhiteSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: HcTheme.whiteColor,
);

const TextStyle mon14BlackSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: HcTheme.blackColor,
);
const TextStyle mon14Black = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: HcTheme.blackColor,
);

const TextStyle mon14Blue = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: HcTheme.blueColor,
);

const TextStyle mon14Green = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: HcTheme.greenColor,
);

const TextStyle mon14lightGrey3 = TextStyle(
  fontFamily: montserrat,
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: HcTheme.lightGrey3Color,
);

const TextStyle mon14darkGrey1 = TextStyle(
    fontFamily: montserrat,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: HcTheme.darkGrey1Color);

const TextStyle mon12lightGrey3 = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: HcTheme.lightGrey3Color,
);

const TextStyle mon12Green = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  color: HcTheme.greenColor,
);

const TextStyle mon16GreenSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HcTheme.greenColor,
);
const TextStyle mon18darkGreenSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: HcTheme.brightGreenColor,
);
const TextStyle mon16darkGreenSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: HcTheme.brightGreenColor,
);
const TextStyle mon12LightGreen = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  color: HcTheme.lightGreen2Color,
);
const TextStyle mon30GreenBold = TextStyle(
  fontFamily: montserrat,
  fontSize: 25,
  fontWeight: FontWeight.w500,
  color: HcTheme.lightGreen2Color,
);

const TextStyle mon30BlueBold = TextStyle(
  fontFamily: montserrat,
  fontSize: 30,
  fontWeight: FontWeight.w600,
  color: HcTheme.blueColor,
);

const TextStyle mon12Black = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  color: HcTheme.blackColor,
  fontWeight: FontWeight.w500,
);

const TextStyle mon12BlackMedium = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: HcTheme.blackColor,
);

const TextStyle mon12BlackSB = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: HcTheme.blackColor,
);

const TextStyle mon12White600 = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: HcTheme.whiteColor,
);

const TextStyle mon12White = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  color: HcTheme.whiteColor,
);

TextStyle mon12WhiteOpt = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  color: HcTheme.whiteColor.withOpacity(0.52),
);
TextStyle mon12WhiteOpt80 = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  color: HcTheme.whiteColor.withOpacity(0.80),
);

const TextStyle mon12Blue = TextStyle(
  fontFamily: montserrat,
  fontSize: 12,
  color: HcTheme.blueColor,
  fontWeight: FontWeight.w500,
);

const TextStyle mon10Black = TextStyle(
  fontFamily: montserrat,
  fontSize: 10,
  color: HcTheme.blackColor,
);
const TextStyle mon10darkGrey1 = TextStyle(
  fontFamily: montserrat,
  fontSize: 10,
  fontWeight: FontWeight.w500,
  color: HcTheme.darkGrey1Color,
);

const TextStyle mon10Green600 = TextStyle(
  fontFamily: montserrat,
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: HcTheme.greenColor,
);
const TextStyle mon10Green = TextStyle(
  fontFamily: montserrat,
  fontSize: 10,
  fontWeight: FontWeight.w500,
  color: HcTheme.greenColor,
);
const TextStyle mon10Blue600 = TextStyle(
  fontFamily: montserrat,
  fontSize: 10,
  fontWeight: FontWeight.w600,
  color: HcTheme.blueColor,
);
const TextStyle mon36Green = TextStyle(
  fontFamily: montserrat,
  fontSize: 36,
  fontWeight: FontWeight.w600,
  color: HcTheme.greenColor,
);

const TextStyle mon10Red = TextStyle(
  fontFamily: montserrat,
  fontSize: 10,
  color: HcTheme.redColor,
);

// const TextStyle mon = TextStyle(
//   fontFamily: montserrat,
//   fontSize: ,
//   color: ,
// );
// const TextStyle mon = TextStyle(
//   fontFamily: montserrat,
//   fontSize: ,
//   color: ,
// );
// const TextStyle mon = TextStyle(
//   fontFamily: montserrat,
//   fontSize: ,
//   color: ,
// );
