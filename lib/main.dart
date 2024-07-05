import 'package:chat_app/bloc/auth/auth_state.dart';
import 'package:chat_app/bloc/chat/chat_state.dart';
import 'package:chat_app/bloc/theme/theme_state.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
      BlocProvider<UserListCubit>(create: (_) => UserListCubit()),
      BlocProvider<ChatCubit>(create: (_) => ChatCubit()),
    ],
    child: MyApp(
      sharedPreferences: prefs,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          theme: state.darkTheme ? darkTheme : lightTheme,
          home: FirebaseAuth.instance.currentUser == null
              ? const RegisterPage()
              : const HomePage(),
          routes: {
            "/homePage": (context) => const HomePage(),
            "/registerPage": (context) => const RegisterPage(),
            "/loginPage": (context) => const LoginPage(),
          },
        );
      },
    );
  }
}
