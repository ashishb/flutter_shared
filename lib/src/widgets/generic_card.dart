import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/widgets/primary_title.dart';

const double kBorderRadius = 12;
const double kSmallBorderRadius = 6;

class GenericCard extends StatelessWidget {
  const GenericCard({
    @required this.children,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.minHeight = 100,
    this.title,
    this.showChevron = false,
    this.small = false,
    this.action,
  });

  final List<Widget> children;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final double minHeight;
  final String title;
  final bool showChevron;
  final bool small;
  final Widget action;

  Widget _titleBar(BuildContext context) {
    if (Utils.isEmpty(title)) {
      return NothingWidget();
    }

    return PrimaryTitle(title: title);
  }

  List<PopupMenuEntry<String>> _addMenuSeparators(
      List<PopupMenuEntry<String>> menuItems) {
    final List<PopupMenuEntry<String>> result = [];

    if (Utils.isNotEmpty(menuItems)) {
      menuItems.asMap().forEach((index, value) {
        if (index % 2 != 0) {
          result.add(const PopupMenuDivider());
        }

        result.add(value);
      });
    }

    return result;
  }

  Widget _popupMenu() {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        List<PopupMenuEntry<String>> menuItems = [];

        if (onEdit != null) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'edit',
              enabled: onEdit != null,
              child: const MenuItem(
                icon: Icon(Icons.edit),
                name: 'Edit',
              ),
            ),
          );
        }

        if (onDelete != null) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'delete',
              enabled: onDelete != null,
              child: const MenuItem(
                icon: Icon(Icons.delete),
                name: 'Delete',
              ),
            ),
          );
        }

        menuItems = _addMenuSeparators(menuItems);

        return menuItems;
      },
      onSelected: (selected) async {
        switch (selected) {
          case 'edit':
            if (onEdit != null) {
              onEdit();
            }
            break;
          case 'delete':
            if (onDelete != null) {
              onDelete();
            }
            break;
        }
      },
      child: const Icon(
        Icons.more_vert,
        size: 19,
        color: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseCard(
          small: small,
          minHeight: minHeight,
          onTap: onTap,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_titleBar(context), ...children],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: onDelete != null || onEdit != null,
          child: Positioned(
            right: 8,
            top: 12,
            child: _popupMenu(),
          ),
        ),
        Visibility(
          visible: action != null,
          child: Positioned(
            right: 8,
            top: 12,
            child: action,
          ),
        ),
        Visibility(
          visible: showChevron,
          child: const Positioned(
            right: 6,
            bottom: 10,
            child: Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================================

class CardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 12);
  }
}

// ==========================================================

class AddCard extends StatelessWidget {
  const AddCard({
    @required this.onTap,
    this.minHeight = 80,
    this.small = false,
  });

  final VoidCallback onTap;
  final double minHeight;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Theme.of(context).cardTheme.color.withOpacity(.1);

    double strokeWidth = 4;
    List<double> dashPattern = [12, 10];
    double iconSize = 38;

    if (small) {
      strokeWidth = 3;
      dashPattern = [8, 8];
      iconSize = 24;
    }

    return Padding(
      padding: EdgeInsets.all(strokeWidth / 2),
      child: DottedBorder(
        dashPattern: dashPattern,
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        radius: Radius.circular(small ? kSmallBorderRadius : kBorderRadius),
        color: cardColor,
        child: BaseCard(
          fill: false,
          small: small,
          minHeight: minHeight,
          onTap: () {
            onTap();
          },
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              Icons.add_circle_outline,
              color: cardColor,
              size: iconSize,
            ),
          )),
        ),
      ),
    );
  }
}

// ==========================================================

class BaseCard extends StatelessWidget {
  const BaseCard({
    @required this.child,
    @required this.onTap,
    this.minHeight = 100,
    this.fill = true,
    this.small = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final double minHeight;
  final bool fill;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Card(
      // null will use the default color
      color: fill ? null : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(small ? kSmallBorderRadius : kBorderRadius),
      ),
      margin: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
