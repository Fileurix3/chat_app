import 'package:chat_app/bloc/user%20list/user_list_state.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "User list",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocBuilder<UserListCubit, UserListState>(
        builder: (context, state) {
          if (state is UserListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserListError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          } else if (state is UserListLoaded) {
            if (state.userList.isEmpty) {
              return Center(
                child: Text(
                  "Nothing found",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: state.userList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverUserName: state.userList[index]["name"],
                            receiverUserUid: state.userList[index]["uid"],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(state.userList[index]["name"]),
                      trailing: const Icon(Icons.arrow_back_ios_new),
                      titleTextStyle: Theme.of(context).textTheme.titleMedium,
                      subtitle: Text(
                        state.userList[index]["uid"],
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
    );
  }
}
