import 'package:bitespot/extensions/theme_extension.dart';
import 'package:bitespot/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/constants.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: AppBar(
        title: const Text("Theme"),
        backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
        child: ListView.separated(
          itemCount: ThemeMode.values.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: SizeConstants.s8);
          },
          itemBuilder: (context, index) {
            return Row(
              children: [
                Checkbox.adaptive(
                  value:
                      ThemeMode.values[index] ==
                      context.watch<MainProvider>().theme,
                  onChanged: (value) async {
                    context.read<MainProvider>().changeTheme(
                      ThemeMode.values[index],
                    );
                  },
                ),
                const SizedBox(width: SizeConstants.s8),
                Text(ThemeMode.values[index].localizedText(context)),
              ],
            );
          },
        ),
      ),
    );
  }
}
