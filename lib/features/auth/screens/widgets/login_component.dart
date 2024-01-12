// import 'package:drmohans_homecare_flutter/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../common/widgets/grey_container.dart';
// import '../../../../common/widgets/main_green_button.dart';
// import '../../../../common/widgets/main_textfield.dart';
//
// class LoginComponent extends StatelessWidget {
//   const LoginComponent({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: size.height * 0.055,
//           width: size.width,
//         ),
//         Image.asset('assets/icons/png/diala_main_icon.png',
//             height: size.height * 0.11),
//         SizedBox(
//           height: size.height * 0.02,
//         ),
//         const Text("Welcome to",
//             style: mon24White600, textAlign: TextAlign.start),
//         const Text("Dr.Mohan's Homecare App",
//             style: mon24White600, textAlign: TextAlign.start),
//         SizedBox(
//           height: size.height * 0.048,
//         ),
//         GreyCard(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           borderRadius: 4,
//           child: SizedBox(
//             width: size.width,
//             child: Column(
//               children: [
//                 const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Please login to your account",
//                       style: mon18Black,
//                     )),
//                 SizedBox(
//                   height: size.height * 0.03,
//                 ),
//                 const MainTextField(
//                   hintText: 'Email address',
//                 ),
//                 SizedBox(
//                   height: size.height * 0.02,
//                 ),
//                 const MainTextField(
//                   hintText: 'Password',
//                 ),
//                 SizedBox(
//                   height: size.height * 0.017,
//                 ),
//                 Consumer(builder: (context, WidgetRef ref, _) {
//                   return InkWell(
//                     onTap: () {},
//                     child: Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           "Forgot password?",
//                           style: mon12Green.merge(const TextStyle(
//                               decoration: TextDecoration.underline,
//                               decorationColor: HcTheme.greenColor,
//                               decorationThickness: 2)),
//                         )),
//                   );
//                 }),
//                 SizedBox(
//                   height: size.height * 0.088,
//                 ),
//                 MainGreenButton(
//                   onPressed: () {},
//                   title: "LOGIN",
//                 ),
//                 SizedBox(
//                   height: size.height * 0.042,
//                 ),
//               ],
//             ),
//             // height: size.height * 0.45,
//           ),
//         ),
//       ],
//     );
//   }
// }
