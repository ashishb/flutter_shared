import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class BrowserStatusBar extends StatelessWidget {
  const BrowserStatusBar({
    @required this.status,
    @required this.callback,
    this.web = false,
  });

  final String status;
  final void Function(String action) callback;
  final bool web;

  @override
  Widget build(BuildContext context) {
    if (web) {
      return Container(
        width: double.infinity,
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context)
              .primaryColor, // Utils.darken(Theme.of(context).primaryColor, .10),
        ),
        // color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Text(
                  status ?? '',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .scaffoldBackgroundColor, // Utils.darken(Theme.of(context).primaryColor, .10),
        boxShadow: [
          BoxShadow(
            color: Utils.isDarkMode(context)
                ? const Color(0x50000000)
                : const Color(0x60000000),
            blurRadius: 4,
            // offset: Offset(0, 0),
          )
        ],
      ),
      // color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                status ?? '',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned.fill(
            left: null,
            right: 14,
            child: InkWell(
              onTap: () {
                callback('');
              },
              child: const Icon(Icons.more_horiz),
            ),
          ),
        ],
      ),
    );
  }
}
