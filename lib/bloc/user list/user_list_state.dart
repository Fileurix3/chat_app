import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "./user_list_cubit.dart";

class UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  List<Map<String, dynamic>> userList;

  UserListLoaded(this.userList);
}

class UserListError extends UserListState {
  final String message;

  UserListError(this.message);
}
