import 'package:chat_app/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: displayNameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.account_circle_rounded,
                                size: 28,
                              ),
                              labelText: "display name",
                              counterText: "",
                            ),
                            style: Theme.of(context).textTheme.labelMedium,
                            maxLength: 30,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field must not be empty";
                              } else if (value.length < 3) {
                                return "Name must not be less than 3";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                size: 28,
                              ),
                              labelText: "email",
                            ),
                            style: Theme.of(context).textTheme.labelMedium,
                            onChanged: (value) {
                              context.read<AuthCubit>().clearError();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Filed must not be empty";
                              } else if (state is RegisterError) {
                                return state.message;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: passwordController,
                            obscureText: isObscureText,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                size: 28,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscureText = !isObscureText;
                                  });
                                },
                                icon: isObscureText
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                              labelText: "password",
                            ),
                            style: Theme.of(context).textTheme.labelMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Filed must not be empty";
                              } else if (value.length < 6) {
                                return "Password must not be less then 6";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().register(
                                context,
                                displayNameController.text,
                                emailController.text,
                                passwordController.text,
                              );
                        }
                      },
                      child: const Text("Register"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/loginPage");
                          },
                          child: const Text("Login"),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
