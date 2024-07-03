import 'package:chat_app/bloc/auth/auth_state.dart';
import 'package:chat_app/bloc/user%20list/user_list_state.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
      BlocProvider<UserListCubit>(create: (_) => UserListCubit()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: FirebaseAuth.instance.currentUser!.uid.isEmpty
          ? const RegisterPage()
          : const HomePage(),
      routes: {
        "/homePage": (context) => const HomePage(),
        "/registerPage": (context) => const RegisterPage(),
        "/loginPage": (context) => const LoginPage(),
      },
    );
  }
}
