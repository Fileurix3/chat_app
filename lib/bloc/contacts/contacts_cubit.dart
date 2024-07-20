part of 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsState()) {
    fetchContacts();
  }

  void fetchContacts() async {
    emit(ContactsLoading());
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserUid)
          .collection("contacts")
          .get();
      final userList = querySnapshot.docs.map((doc) => doc.data()).toList();
      emit(ContactsLoaded(userList));
    } on SocketException catch (e) {
      emit(ContactsError(e.message));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  void addNewContact(String contactUid, String? contactName) async {
    emit(ContactsLoading());
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(contactUid)
          .get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("contacts")
            .doc(contactUid)
            .set({
          "contactName": contactName ?? userData!["name"],
          "contactUid": contactUid,
        });
        fetchContacts();
      } else {
        emit(ContactsError("User wich this uid doesn't exist"));
      }
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  void deleteContact(String uid) async {
    emit(ContactsLoading());
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("contacts")
          .doc(uid)
          .delete();
      fetchContacts();
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }
}
