import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

const double arrowIconSize = 26;

class JsonViewerWidget extends StatefulWidget {
  const JsonViewerWidget(this.jsonObj, {this.notRoot});

  final Map<String, dynamic> jsonObj;
  final bool notRoot;

  @override
  JsonViewerWidgetState createState() => JsonViewerWidgetState();
}

class JsonViewerWidgetState extends State<JsonViewerWidget> {
  Map<String, bool> openFlag = {};

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot ?? false) {
      return Container(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  Widget _ex(bool ex, MapEntry entry) {
    if (ex) {
      return (openFlag[entry.key] ?? false)
          ? const Icon(
              Icons.arrow_drop_down,
              size: arrowIconSize,
            )
          : const Icon(
              Icons.arrow_right,
              size: arrowIconSize,
            );
    } else {
      return const Icon(
        Icons.arrow_right,
        color: Colors.transparent,
        size: arrowIconSize,
      );
    }
  }

  Widget _exAndInk(bool ex, bool ink, MapEntry entry) {
    if (ex && ink) {
      return InkWell(
        onTap: () {
          setState(() {
            openFlag[entry.key as String] = !(openFlag[entry.key] ?? false);
          });
        },
        child: Text(
          entry.key as String,
          style: TextStyle(
            color: Utils.isDarkMode(context) ? Colors.white : Colors.black,
          ),
        ),
      );
    } else {
      return Text(
        entry.key as String,
        style: TextStyle(
          color: entry.value == null
              ? Colors.grey
              : Utils.isDarkMode(context)
                  ? Colors.white
                  : Colors.black,
        ),
      );
    }
  }

  List<Widget> _getList() {
    final List<Widget> list = [];

    if (widget.jsonObj != null) {
      for (final entry in widget.jsonObj.entries) {
        final bool ex = isExtensible(entry.value);
        final bool ink = isInkWell(entry.value);
        list.add(
          Row(
            children: <Widget>[
              _ex(ex, entry),
              _exAndInk(ex, ink, entry),
              const Text(
                ':',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 3),
              getValueWidget(entry)
            ],
          ),
        );
        list.add(const SizedBox(height: 4));
        if (openFlag[entry.key] ?? false) {
          list.add(getContentWidget(entry.value));
        }
      }
    }
    return list;
  }

  static Widget getContentWidget(dynamic content) {
    if (content is List) {
      return JsonArrayViewerWidget(content, notRoot: true);
    } else {
      return JsonViewerWidget(Map<String, dynamic>.from(content as Map),
          notRoot: true);
    }
  }

  static bool isInkWell(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    } else if (content is DateTime) {
      return false;
    } else if (content is List) {
      return true;
    }
    return true;
  }

  Widget getValueWidget(MapEntry entry) {
    if (entry.value == null) {
      return const Expanded(
          child: Text(
        'undefined',
        style: TextStyle(color: Colors.grey),
      ));
    } else if (entry.value is int) {
      return Expanded(
          child: Text(
        entry.value.toString(),
        style: const TextStyle(color: Colors.teal),
      ));
    } else if (entry.value is String) {
      return Expanded(
          child: Text(
        '"${entry.value}"',
        style: const TextStyle(color: Colors.redAccent),
      ));
    } else if (entry.value is bool) {
      return Expanded(
          child: Text(
        entry.value.toString(),
        style: const TextStyle(color: Colors.purple),
      ));
    } else if (entry.value is DateTime) {
      return Expanded(
          child: Text(
        entry.value.toString(),
        style: const TextStyle(color: Colors.teal),
      ));
    } else if (entry.value is double) {
      return Expanded(
        child: Text(
          entry.value.toString(),
          style: const TextStyle(color: Colors.teal),
        ),
      );
    } else if (entry.value is List) {
      if ((entry.value as List).isEmpty) {
        return const Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              openFlag[entry.key as String] = !(openFlag[entry.key] ?? false);
            });
          },
          child: Text(
            'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        setState(() {
          openFlag[entry.key as String] = !(openFlag[entry.key] ?? false);
        });
      },
      child: const Text(
        'Object',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  static bool isExtensible(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is DateTime) {
      return false;
    } else if (content is double) {
      return false;
    }
    return true;
  }

  static String getTypeName(dynamic content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    } else if (content is DateTime) {
      return 'DateTime';
    }
    return 'Object';
  }
}

class JsonArrayViewerWidget extends StatefulWidget {
  const JsonArrayViewerWidget(this.jsonArray, {this.notRoot});

  final List<dynamic> jsonArray;

  final bool notRoot;

  @override
  _JsonArrayViewerWidgetState createState() => _JsonArrayViewerWidgetState();
}

class _JsonArrayViewerWidgetState extends State<JsonArrayViewerWidget> {
  List<bool> openFlag;

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot ?? false) {
      return Container(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getList()));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  @override
  void initState() {
    super.initState();
    openFlag = List(widget.jsonArray.length);
  }

  Widget _ex(bool ex, int i) {
    if (ex) {
      return (openFlag[i] ?? false)
          ? const Icon(
              Icons.arrow_drop_down,
              size: arrowIconSize,
            )
          : const Icon(
              Icons.arrow_right,
              size: arrowIconSize,
            );
    } else {
      return const Icon(
        Icons.arrow_right,
        color: Colors.transparent,
        size: arrowIconSize,
      );
    }
  }

  Widget _exAndInk(bool ex, bool ink, int i, dynamic content) {
    if (ex && ink) {
      return getInkWell(i);
    }
    return Text(
      '[$i]',
      style: TextStyle(
        color: content == null ? Colors.grey : Colors.purple[900],
      ),
    );
  }

  List<Widget> _getList() {
    final List<Widget> list = [];
    int i = 0;
    for (final content in widget.jsonArray) {
      final bool ex = JsonViewerWidgetState.isExtensible(content);
      final bool ink = JsonViewerWidgetState.isInkWell(content);
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ex(ex, i),
            _exAndInk(ex, ink, i, content),
            const Text(
              ':',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(width: 3),
            getValueWidget(content, i)
          ],
        ),
      );
      list.add(const SizedBox(height: 4));
      if (openFlag[i] ?? false) {
        list.add(JsonViewerWidgetState.getContentWidget(content));
      }
      i++;
    }
    return list;
  }

  InkWell getInkWell(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          openFlag[index] = !(openFlag[index] ?? false);
        });
      },
      child: Text('[$index]', style: TextStyle(color: Colors.purple[900])),
    );
  }

  Widget getValueWidget(dynamic content, int index) {
    if (content == null) {
      return const Expanded(
          child: Text(
        'undefined',
        style: TextStyle(color: Colors.grey),
      ));
    } else if (content is int) {
      return Expanded(
          child: Text(
        content.toString(),
        style: const TextStyle(color: Colors.teal),
      ));
    } else if (content is String) {
      return Expanded(
          child: Text(
        '"$content"',
        style: const TextStyle(color: Colors.redAccent),
      ));
    } else if (content is bool) {
      return Expanded(
          child: Text(
        content.toString(),
        style: const TextStyle(color: Colors.purple),
      ));
    } else if (content is double) {
      return Expanded(
          child: Text(
        content.toString(),
        style: const TextStyle(color: Colors.teal),
      ));
    } else if (content is List) {
      if (content.isEmpty) {
        return const Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              openFlag[index] = !(openFlag[index] ?? false);
            });
          },
          child: Text(
            'Array<${JsonViewerWidgetState.getTypeName(content)}>[${content.length}]',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        setState(() {
          openFlag[index] = !(openFlag[index] ?? false);
        });
      },
      child: const Text(
        'Object',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
