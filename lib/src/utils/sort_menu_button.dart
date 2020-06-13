import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:hive/hive.dart';

class BrowserSortMenuButton extends StatelessWidget {
  const BrowserSortMenuButton();

  Widget _popupMenu(BuildContext context) {
    final List<BrowserSortMenuItem> items = <BrowserSortMenuItem>[];

    for (final style in SortStyle.sortStyles) {
      items.add(
        BrowserSortMenuItem(
          name: style.name,
          sortStyle: style,
        ),
      );
    }

    final menuItems = <PopupMenuItem<BrowserSortMenuItem>>[];

    for (final item in items) {
      menuItems.add(PopupMenuItem<BrowserSortMenuItem>(
        value: item,
        child: MenuItem(
          icon: item.sortStyle.id == BrowserPrefs.sortStyle
              ? const Icon(Feather.check)
              : const Icon(Feather.check, color: Colors.transparent),
          name: item.name,
        ),
      ));
    }

    return PopupMenuButton<BrowserSortMenuItem>(
      tooltip: 'Sort',
      itemBuilder: (context) {
        return menuItems;
      },
      onSelected: (selected) {
        BrowserPrefs.sortStyle = selected.sortStyle.id;
      },
      child: const Icon(Icons.sort),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: HiveBox.prefsBox.listenable(),
      builder: (BuildContext context, Box<dynamic> prefsBox, Widget _) {
        return _popupMenu(context);
      },
    );
  }
}

class BrowserSortMenuItem {
  BrowserSortMenuItem({
    this.name,
    this.sortStyle,
  });
  String name;
  SortStyle sortStyle;
}
