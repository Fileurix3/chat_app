import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './auth_cubit.dart';

class AuthState {}

class RegisterError extends AuthState {
  final String? message;

  RegisterError(this.message);
}

class LoginError extends AuthState {
  final String? message;

  LoginError(this.message);
}
