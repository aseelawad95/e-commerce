import 'package:e_commerce/Core/repository/productRepo.dart';
import 'package:e_commerce/Screens/Auth/login_screen.dart';
import 'package:e_commerce/Screens/Products/product_bloc.dart';
import 'package:e_commerce/Screens/Products/product_screen.dart';
import 'package:e_commerce/Core/Service/session.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool? isLoggedIn = Prefs.getBooleanValue("is_logged_in");
  String? userEmail = Prefs.getStringValue("user_email");

  runApp(MyApp(
    initialScreen: (isLoggedIn == true && userEmail != null)
        ? BlocProvider(
      create: (context) => ProductBloc(productRepository: ProductRepository()),
      child: ProductScreen(userName: userEmail),
    )
        : const LoginScreen(),
  ));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}
