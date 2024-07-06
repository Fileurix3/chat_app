import 'package:chat_app/bloc/theme/theme_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isEdit = false;

  TextEditingController newNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      newNameController.text =
          FirebaseAuth.instance.currentUser!.displayName.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        margin: const EdgeInsets.only(
          top: 60,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isEdit == false
                        ? Expanded(
                            child: Text(
                              FirebaseAuth.instance.currentUser!.displayName
                                  .toString(),
                              style: Theme.of(context).textTheme.headlineSmall,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        : Expanded(
                            child: TextField(
                              controller: newNameController,
                              decoration: const InputDecoration(
                                hintText: "Enter new name",
                                counterText: "",
                              ),
                              maxLength: 30,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                    isEdit == false
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isEdit = !isEdit;
                              });
                            },
                            icon: const Icon(Icons.edit),
                          )
                        : Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isEdit = !isEdit;
                                    newNameController.text = FirebaseAuth
                                        .instance.currentUser!.displayName
                                        .toString();
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  FirebaseAuth.instance.currentUser!
                                      .updateDisplayName(
                                          newNameController.text);
                                  setState(() {
                                    isEdit = !isEdit;
                                  });
                                },
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                      text: FirebaseAuth.instance.currentUser!.uid,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "UID copied",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        backgroundColor: Theme.of(context).cardColor,
                      ),
                    );
                  },
                  child: Text(
                    "UID: ${FirebaseAuth.instance.currentUser!.uid}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                      bottom: 4,
                      top: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: state.darkTheme == false
                              ? const Icon(
                                  Icons.nights_stay,
                                  key: ValueKey<int>(1),
                                )
                              : const Icon(
                                  Icons.light_mode,
                                  key: ValueKey<int>(2),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Toggle theme",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
