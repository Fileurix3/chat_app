// ignore_for_file: use_build_context_synchronously

part of './auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void register(
      BuildContext context, String name, String email, String password) async {
    emit(AuthState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set(
        {
          "name": name,
          "email": credential.user!.email,
          "uid": credential.user!.uid,
        },
        SetOptions(merge: true),
      );
      Navigator.pushNamed(context, "/homePage");
    } on FirebaseAuthException catch (e) {
      emit(RegisterError(e.message));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  void login(BuildContext context, String email, String password) async {
    emit(AuthState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushNamed(context, "/homePage");
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        emit(LoginError("Invalid login information"));
      } else {
        emit(LoginError(e.message));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  void singOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, "/registerPage");
  }

  void clearError() {
    emit(AuthState());
  }
}
