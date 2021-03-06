import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class SearchField extends StatefulWidget {
  const SearchField(this.onChange);

  final void Function(String) onChange;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController _searchControllerConns;
  final NoKeyboardEditableTextFocusNode _focusNode =
      NoKeyboardEditableTextFocusNode();

  @override
  void initState() {
    super.initState();

    _searchControllerConns = TextEditingController();

    _setup();
  }

  @override
  void dispose() {
    _searchControllerConns.dispose();

    super.dispose();
  }

  void _setup() {
    _searchControllerConns.addListener(() {
      if (_searchControllerConns.text.isEmpty) {
        widget.onChange('');
      } else {
        widget.onChange(_searchControllerConns.text.toLowerCase());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      onTap: () {
        if (!_focusNode.enable) {
          _focusNode.enable = true;

          setState(() {});
        }
      },
      controller: _searchControllerConns,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 2,
            color: Utils.isDarkMode(context) ? Colors.white24 : Colors.black12,
          ),
        ),
        labelText: 'Search',
        suffixIcon: IconButton(
          icon: Utils.isNotEmpty(_searchControllerConns.text)
              ? const Icon(Icons.close)
              : const Icon(Icons.search),
          onPressed: () {
            _searchControllerConns.text = '';
          },
        ),
      ),
    );
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  bool enable = false;

  @override
  bool get hasFocus {
    if (enable) {
      return super.hasFocus;
    }
    return false;
  }

  @override
  bool consumeKeyboardToken() {
    if (enable) {
      return super.consumeKeyboardToken();
    }

    return false;
  }
}
