import 'package:chat_app/bloc/contacts/contacts_state.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController contactUidController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();

  String? error;

  void addNewContact() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new contact"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: contactNameController,
                  decoration: const InputDecoration(
                    labelText: "contactName",
                    counterText: "",
                  ),
                  maxLength: 30,
                  style: Theme.of(context).textTheme.labelMedium,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: contactUidController,
                  decoration: const InputDecoration(labelText: "contactUid"),
                  style: Theme.of(context).textTheme.labelMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field must not be empty";
                    } else if (error != null) {
                      return error;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String? contactName = contactNameController.text.isEmpty
                      ? null
                      : contactNameController.text;
                  context.read<ContactsCubit>().addNewContact(
                        contactUidController.text,
                        contactName,
                      );
                  contactNameController.clear();
                  contactUidController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Center(
                child: Text("Add"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("User list"),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactsError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          } else if (state is ContactsLoaded) {
            if (state.contacts.isEmpty) {
              return Center(
                child: Text(
                  "Nothing found\nAdd new contact",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          icon: Icons.delete,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          onPressed: (context) {
                            context.read<ContactsCubit>().deleteContact(
                                state.contacts[index]["contactUid"]);
                          },
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          icon: Icons.delete,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          onPressed: (context) {
                            context.read<ContactsCubit>().deleteContact(
                                state.contacts[index]["contactUid"]);
                          },
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              receiverUserName: state.contacts[index]
                                  ["contactName"],
                              receiverUserUid: state.contacts[index]
                                  ["contactUid"],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          state.contacts[index]["contactName"],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: const Icon(Icons.arrow_back_ios_new),
                        subtitle: Text(
                          state.contacts[index]["contactUid"],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
          return Center(
            child: Text(
              "Unknown error",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewContact();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
