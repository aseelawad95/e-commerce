
import 'package:e_commerce/Screens/Auth/sign_up_screen.dart';
import 'package:e_commerce/Screens/Products/product_screen.dart';
import 'package:e_commerce/Screens/widgets/text_widget.dart';
import 'package:e_commerce/Core/Service/session.dart';
import 'package:e_commerce/Core/Service/user_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserService userService = UserService();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final formKey = GlobalKey<FormState>();
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Image.asset('assets/images/logo.jpeg'),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Your Email',
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Your Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    } else if (value.length < 6) {
                      return 'Password should be at least 6 characters';
                    } else if (value.length > 15) {
                      return "Password should not be greater than 15 characters";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      validateAndSubmit(context);
                      print(
                          'Login Succeeded with : ${email.text} and ${password.text} and ${userName.text}');
                    } else {
                      print('Wrong or Empty Input');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fixedSize: const Size(120, 50)),
                  child: const TextWidget(
                    text: 'Login',
                    color: Colors.white,
                    fontSize: 18,
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Don\'t have an account ? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'SignUp',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpScreen()));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool emailValidator(String str) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(str);
  }

  void validateAndSubmit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      var result =
          await userService.signIn(email.text.trim(), password.text.trim());
      Navigator.of(_keyLoader.currentContext ?? context, rootNavigator: true)
          .pop();
      if (result == 'No user found for that email.') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No user found for this email.'),
        ));
      } else if (result == 'Wrong password provided for that user.') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Wrong password provided for this user.'),
        ));
      } else {
        final UserService service = UserService();
        var userData = await service.getUserData(result);
        await Prefs.init();
        await Prefs.setStringValue("user_email", userData.email ?? "");
        await Prefs.setBool("is_logged_in", true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductScreen(
                      userName: userData.email,
                    )));
      }
    }
  }
}
