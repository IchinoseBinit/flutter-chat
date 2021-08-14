import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/shared_preferences.dart';
import 'package:flutter_chat/utilities/firestore_helper.dart';

class MessageProvider with ChangeNotifier {
  String getChatRoomId(
    String receiverUserName,
  ) {
    final myUserName = MySharedPreferences.sharedPreferences
        .getString(MySharedPreferences.userNameKey)!;
    if (myUserName.compareTo(receiverUserName) > 0) {
      return "$myUserName+$receiverUserName";
    } else if (myUserName.compareTo(receiverUserName) < 0) {
      return "$receiverUserName+$myUserName";
    } else {
      return "$myUserName";
    }
  }

  Future<Stream<QuerySnapshot>> getChatMessage(String chatId) async {
    return await FireStoreHelper().getChatMessages(chatId);
  }
}
