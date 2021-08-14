import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/providers/message_provider.dart';
import 'package:flutter_chat/shared_preferences.dart';
import 'package:flutter_chat/utilities/firestore_helper.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  Future<void> createChats(BuildContext context, String username) async {
    final chatId = Provider.of<MessageProvider>(context, listen: false)
        .getChatRoomId(username);
    final myUserName = MySharedPreferences.sharedPreferences
        .getString(MySharedPreferences.userNameKey)!;
    Map<String, dynamic> chatsInfo = {
      "users": [myUserName, username]
    };
    await FireStoreHelper().createChats(chatId, chatsInfo);
  }

  Future<Stream<QuerySnapshot>> getChatSnapshot() async {
    final username = MySharedPreferences.sharedPreferences
        .getString(MySharedPreferences.userNameKey)!;
    return await FireStoreHelper().getChats(username);
  }
}
