// ignore_for_file: use_build_context_synchronously

part of './auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void register(
      BuildContext context, String name, String email, String password) async {
    emit(AuthState());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
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
