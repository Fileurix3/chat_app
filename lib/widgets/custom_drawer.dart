import 'package:chat_app/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        margin: const EdgeInsets.only(
          top: 50,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "weweffeqweqqweqweqwer",
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: AnimatedSwitcher(
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
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 50),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(
                  right: 10,
                  bottom: 4,
                  top: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings),
                    const SizedBox(width: 10),
                    Text(
                      "Setting",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
