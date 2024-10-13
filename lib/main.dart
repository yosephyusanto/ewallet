import 'package:ewallet/firebase_options.dart';
import 'package:ewallet/pages/home_page.dart';
import 'package:ewallet/pages/login_page.dart';
import 'package:ewallet/pages/signup_page.dart';
import 'package:ewallet/pages/splash_screen.dart';
import 'package:ewallet/providers/auth_provider.dart';
import 'package:ewallet/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPaintSizeEnabled = false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash-screen',
      routes: {
        'login-screen' : (context) => const LoginPage(),
        'register-screen': (context) => const SignupPage(),
        'home-screen': (context) => const HomePage(),
      },
    );
  }
}
