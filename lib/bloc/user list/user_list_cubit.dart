part of './user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListState()) {
    fetchUserList();
  }

  void fetchUserList() async {
    emit(UserListLoading());
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final userList = querySnapshot.docs
          .where((doc) => doc.id != currentUserUid)
          .map((doc) => doc.data())
          .toList();
      emit(UserListLoaded(userList));
    } on SocketException catch (e) {
      emit(UserListError(e.message));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }
}
