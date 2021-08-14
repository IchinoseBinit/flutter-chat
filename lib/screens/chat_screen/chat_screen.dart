import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/providers/message_provider.dart';
import 'package:flutter_chat/shared_preferences.dart';
import 'package:flutter_chat/utilities/ffi_helper.dart';
import 'package:flutter_chat/utilities/firestore_helper.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  late final String imageUrl;
  late final String username;

  ChatScreen({required this.imageUrl, required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageId = "";
  Stream<QuerySnapshot<Object?>>? messageStream;
  final messageController = TextEditingController();
  String myUserName = MySharedPreferences.sharedPreferences
      .getString(MySharedPreferences.userNameKey)!;
  String chatRoomId = "";

  addMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      final message = messageController.text.trim();
      // final message = FFIHelper().encryptString(rawMessage);
      // Yaha call garera encrypt garna sakinxa but aile error dinxa
      // utako file lai extern use garera string return garna chei sakina
      final dateTime = DateTime.now();

      Map<String, dynamic> messageInfo = {
        'message': message,
        'sender': myUserName,
        'time': dateTime,
      };

      if (messageId.isEmpty) {
        messageId = dateTime.toString();
      }

      if (chatRoomId.isEmpty) {
        chatRoomId = Provider.of<MessageProvider>(context, listen: false)
            .getChatRoomId(widget.username);
      }

      await FireStoreHelper()
          .sendMessage(chatRoomId, messageId, messageInfo)
          .then(
        (value) async {
          Map<String, dynamic> lastMessage = {
            'lastMessage': message,
            'sender': myUserName,
            'time': dateTime,
            'image': widget.imageUrl,
          };
          await FireStoreHelper().updateLastMessager(chatRoomId, lastMessage);
        },
      );

      messageController.text = "";
      messageId = "";
    }
  }

  getMessages() async {
    chatRoomId = Provider.of<MessageProvider>(context, listen: false)
        .getChatRoomId(widget.username);
    messageStream = await Provider.of<MessageProvider>(context, listen: false)
        .getChatMessage(chatRoomId);
    setState(() {});
  }

  @override
  initState() {
    getMessages();
    super.initState();
  }

  Widget buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("some error occurred");
        } else if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.08,
              top: 10,
            ),
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              final document = snapshot.data.docs[index];
              final myUserName = MySharedPreferences.sharedPreferences
                  .getString(MySharedPreferences.userNameKey)!;
              return buildMessageTile(
                document["message"].toString(),
                myUserName == document["sender"].toString(),
              );
            },
          );
        } else {
          return Text("something is wrong");
        }
      },
    );
  }

  Widget buildMessageTile(String message, bool isSendByMe) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment:
            isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: isSendByMe
                ? BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  )
                : BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              CircleAvatar(
                child: ClipRRect(
                  child: Image.network(
                    widget.imageUrl,
                  ),
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.username,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            buildMessagesList(),
            Container(
              alignment: Alignment.bottomCenter,
              // color: Colors.white,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black45,
                    width: 0.5,
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.black87),
                          contentPadding: EdgeInsets.all(4),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await addMessage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.send),
                      ),
                    )
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
