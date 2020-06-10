import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class ThemeEditorScreen extends StatelessWidget {
  Widget _body(BuildContext context) {
    final List<ThemeSet> themes = Preferences().themeSets;

    if (Utils.isEmpty(themes)) {
      return const Center(
        child: Text('No themes found.'),
      );
    }

    return ListView.separated(
      itemCount: themes.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemBuilder: (context, index) {
        return ListRow(
          title: themes[index].name,
          trailing: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () async {
              final bool result = await showConfirmDialog(
                context: context,
                title: 'Delete Theme?',
                message:
                    'Do you want to delete the theme nameed: "${themes[index].name}"',
              );

              if (result == true) {
                ThemeSetManager.deleteTheme(themes[index]);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Editor'),
      ),
      body: _body(context),
    );
  }
}
