import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/providers/chat_provider.dart';
import 'package:flutter_chat/screens/chat_screen/chat_screen.dart';
import 'package:flutter_chat/shared_preferences.dart';
import 'package:flutter_chat/utilities/firestore_helper.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatefulWidget {
  ChatTile(this.document);

  final DocumentSnapshot document;

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  // Map<String, String> userInfo = {};
  bool? isSendByMe;
  String? senderName;

  getUserInfo() async {
    final myUserName = MySharedPreferences.sharedPreferences
        .getString(MySharedPreferences.userNameKey)!;
    senderName = widget.document.id.contains("+")
        ? widget.document.id.replaceAll(myUserName, "").replaceAll("+", "")
        : widget.document.id;
    isSendByMe = widget.document['sender'] == myUserName;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return isSendByMe == null
        ? ListTile(
            title: Text(senderName!),
            subtitle: Text(
              isSendByMe!
                  ? widget.document['lastMessage'].toString().length > 25
                      ? "You: ${widget.document['lastMessage'].toString().substring(0, 25)} ..."
                      : "You: ${widget.document['lastMessage'].toString()}"
                  : widget.document['lastMessage'].toString().length > 25
                      ? "${widget.document['lastMessage'].toString().substring(0, 25)} ..."
                      : widget.document['lastMessage'].toString(),
            ),
          )
        : ListTile(
            key: ValueKey(widget.document.id),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.document['image']),
            ),

            title: Text(senderName!),
            subtitle: Text(
              isSendByMe!
                  ? widget.document['lastMessage'].toString().length > 25
                      ? "You: ${widget.document['lastMessage'].toString().substring(0, 25)} ..."
                      : "You: ${widget.document['lastMessage'].toString()}"
                  : widget.document['lastMessage'].toString().length > 25
                      ? "${widget.document['lastMessage'].toString().substring(0, 25)} ..."
                      : widget.document['lastMessage'].toString(),
            ),
            onTap: () async {
              await Provider.of<ChatProvider>(context, listen: false)
                  .createChats(context, senderName!);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    imageUrl: widget.document['image']!,
                    username: senderName!,
                  ),
                ),
              );
            },
            // trailing: ,
          );
  }
}
