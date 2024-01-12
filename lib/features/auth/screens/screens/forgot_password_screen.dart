// import 'package:drmohans_homecare_flutter/features/dashboard/dashboard.dart';
// import 'package:drmohans_homecare_flutter/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// import '../../../../common/widgets/grey_container.dart';
// import '../../../../common/widgets/main_background.dart';
// import '../../../../common/widgets/main_green_button.dart';
//
// class ForgotPasswordScreen extends StatelessWidget {
//   static const route = 'forgot-password';
//   const ForgotPasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: MainBackgroundComponent(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           stops: const [0.48, 0.48],
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: size.height * 0.055,
//                 width: size.width,
//               ),
//               Image.asset('assets/icons/png/diala_main_icon.png',
//                   height: size.height * 0.11),
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               const Text("Welcome to",
//                   style: mon24White600, textAlign: TextAlign.start),
//               const Text("Dr.Mohan's Homecare App",
//                   style: mon24White600, textAlign: TextAlign.start),
//               SizedBox(
//                 height: size.height * 0.048,
//               ),
//               GreyCard(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                 borderRadius: 4,
//                 child: SizedBox(
//                   width: size.width,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 18,
//                       ),
//                       Row(
//                         children: [
//                           InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: SvgPicture.asset(
//                                   'assets/icons/svg/back_icon.svg')),
//                           const SizedBox(
//                             width: 12,
//                           ),
//                           const Text(
//                             "Forgot password",
//                             style: mon18Black,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       const Text(
//                         "Enter the OTP send to gauravjoshi@gmail.,com",
//                         style: mon12lightGrey3,
//                       ),
//                       const SizedBox(
//                         height: 21,
//                       ),
//                       SizedBox(
//                         width: size.width * 0.53,
//                         child: PinCodeTextField(
//                           appContext: context,
//                           length: 4,
//                           pinTheme: PinTheme(
//                             borderRadius: BorderRadius.circular(4),
//                             shape: PinCodeFieldShape.box,
//                             activeColor: HcTheme.greenColor,
//                             inactiveColor: HcTheme.lightGrey2Color,
//                             selectedColor: HcTheme.greenColor,
//                             fieldHeight: 47,
//                             fieldWidth: 47,
//                             selectedFillColor: HcTheme.greenColor,
//                             activeFillColor: HcTheme.greenColor,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 12,
//                       ),
//                       const Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text("Didn't recieve OTP?", style: mon10Black),
//                               InkWell(
//                                   child: Text("Resend", style: mon10Green600)),
//                             ],
//                           ),
//                           Text(
//                             "00:29",
//                             style: mon10Black,
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: size.height * 0.13,
//                       ),
//                       MainGreenButton(
//                           title: "LOGIN",
//                           onPressed: () {
//                             Navigator.pushNamed(context, Dashboard.route);
//                           }),
//                       const SizedBox(
//                         height: 8,
//                       )
//                     ],
//                   ),
//                   // height: size.height * 0.45,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
