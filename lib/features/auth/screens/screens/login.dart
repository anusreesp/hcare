import 'package:drmohans_homecare_flutter/features/auth/controller/login_controller.dart';
import 'package:drmohans_homecare_flutter/features/auth/screens/screens/forgot_password_screen.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/grey_container.dart';
import '../../../../common/widgets/main_background.dart';
import '../../../../common/widgets/main_green_button.dart';
import '../../../../common/widgets/main_textfield.dart';
import '../../../../theme.dart';

class LoginScreen extends StatelessWidget {
  static const route = '/login-screen';
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: MainBackgroundComponent(
          stops: const [0.48, 0.48],
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            key: _loginForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.055,
                  width: size.width,
                ),
                Image.asset('assets/icons/png/diala_main_icon.png',
                    height: size.height * 0.11),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text("Welcome to",
                    style: mon24White600, textAlign: TextAlign.start),
                const Text("Dr.Mohan's Homecare App",
                    style: mon24White600, textAlign: TextAlign.start),
                SizedBox(
                  height: size.height * 0.048,
                ),
                GreyCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  borderRadius: 4,
                  child: SizedBox(
                    width: size.width,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Please login to your account",
                              style: mon18BlackSB,
                            )),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        MainTextField(
                          controller: _username,
                          hintText: 'Username',
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        MainTextField(
                          controller: _password,
                          hintText: 'Password',
                          isPassword: true,
                        ),
                        SizedBox(
                          height: size.height * 0.017,
                        ),
                        // Consumer(builder: (context, WidgetRef ref, _) {
                        //   return InkWell(
                        //     onTap: () {
                        //       Navigator.pushNamed(
                        //           context, ForgotPasswordScreen.route);
                        //     },
                        //     child: Align(
                        //         alignment: Alignment.centerRight,
                        //         child: Text(
                        //           "Forgot password?",
                        //           style: mon12Green.merge(const TextStyle(
                        //               decoration: TextDecoration.underline,
                        //               decorationColor: HcTheme.greenColor,
                        //               decorationThickness: 2)),
                        //         )),
                        //   );
                        // }),
                        SizedBox(
                          height: size.height * 0.088,
                        ),
                        Consumer(builder: (context, ref, _) {
                          ref.listen(loginProvider, (previous, next) {
                            if (next is LoginErrorState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Username or password is invalid."),
                                duration: Duration(seconds: 3),
                                backgroundColor: HcTheme.redColor,
                              ));
                            }
                          });
                          final loginData = ref.watch(loginProvider);
                          if (loginData is LoginLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return MainGreenButton(
                              onPressed: () async {
                                if (_loginForm.currentState?.validate() ??
                                    false) {
                                  final token = await FirebaseMessaging.instance.getToken();
                                  await ref.read(loginProvider.notifier).login(
                                      _username.text, _password.text, context).then((value)async{
                                    await ref.read(dashboardServiceProvider).saveDeviceId(token!);
                                  });
                                }
                                // Navigator.pushNamed(context, Dashboard.route);
                              },
                              title: "LOGIN",
                            );
                          }
                        }),
                        SizedBox(
                          height: size.height * 0.042,
                        ),
                      ],
                    ),
                    // height: size.height * 0.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
