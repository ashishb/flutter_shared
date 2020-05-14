import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_shared/src/chat/chat_models.dart';
import 'package:flutter_shared/src/chat/chat_screen_contents.dart';
import 'package:flutter_shared/src/firebase/firestore.dart';
import 'package:flutter_shared/src/widgets/loading_widget.dart';

class ChatAdminScreenContents extends StatefulWidget {
  const ChatAdminScreenContents();

  @override
  _ChatAdminScreenContentsState createState() =>
      _ChatAdminScreenContentsState();
}

class _ChatAdminScreenContentsState extends State<ChatAdminScreenContents> {
  final Stream<List<ChatMessage>> stream = ChatMessageUtils.stream(
    where: [WhereQuery('', 'admin')],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Admin')),
      body: StreamBuilder<dynamic>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snap) {
          bool hasData = false;

          if (snap.hasError) {
            print('snap.hasError');
            print(snap);
          }

          if (snap.hasData && !snap.hasError) {
            hasData = true;
          }

          if (hasData) {
            final List<ChatMessage> resources = snap.data as List<ChatMessage>;

            return ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final ChatMessage chat = resources[index];

                final String title =
                    'From: ${chat.user.uid} message: ${chat.text.substring(0, math.min(10, chat.text.length))}';

                return ListTile(
                  title: Text(title),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => ChatScreenContents(
                          toUid: chat.user.uid,
                          stream: ChatMessageUtils.stream(
                            where: [
                              WhereQuery(chat.user.uid, 'admin'),
                              WhereQuery('admin', chat.user.uid),
                            ],
                          ),
                          isAdmin: true,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      final deleteStream = ChatMessageUtils.stream(
                        where: [
                          WhereQuery(chat.user.uid, 'admin'),
                          WhereQuery('admin', chat.user.uid),
                        ],
                      );

                      ChatMessageUtils.deleteMessagesFromStream(deleteStream);
                    },
                  ),
                );
              },
            );
          }
          return LoadingWidget();
        },
      ),
    );
  }
}
