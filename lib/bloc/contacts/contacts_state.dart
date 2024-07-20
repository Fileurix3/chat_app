import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part "contacts_cubit.dart";

class ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  List<Map<String, dynamic>> contacts;

  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String message;

  ContactsError(this.message);
}
