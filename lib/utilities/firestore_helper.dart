import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  addUser(String userId, Map<String, String> userInfo) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfo);
  }

  Future<Stream<QuerySnapshot>> getUserbyUsername(String username) async {
    print("aayo request");
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future getUserInfo(String username) async {
    final querySnapshot = await getUserbyUsername(username);
    Map<String, String> userInfo = {};
    await querySnapshot.first.then(
      (value) {
        userInfo['image'] = value.docs[0]['image'];
        userInfo['name'] = value.docs[0]['name'];
        userInfo['name'] = value.docs[0]['name'];
      },
    );
    return userInfo;
  }

  Future sendMessage(
    String chatId,
    String messageId,
    Map<String, dynamic> messageInfo,
  ) async {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("chat")
        .doc(messageId)
        .set(messageInfo);
  }

  Future updateLastMessager(
    String chatId,
    Map<String, dynamic> lastMessage,
  ) async {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .update(lastMessage);
  }

  Future createChats(String chatId, Map<String, dynamic> chatsInfo) async {
    final documentReference =
        FirebaseFirestore.instance.collection("chats").doc(chatId);
    final snapshot = await documentReference.get();

    if (snapshot.exists) {
      return true;
    } else {
      await documentReference.set(chatsInfo);
      return false;
    }
  }

  Future<Stream<QuerySnapshot>> getChatMessages(String chatId) async {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("chat")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChats(String myUserName) async {
    return FirebaseFirestore.instance
        .collection("chats")
        .orderBy("time", descending: true)
        .where("users", arrayContains: myUserName)
        .snapshots();
  }
}
