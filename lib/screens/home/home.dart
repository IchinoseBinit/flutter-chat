import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/providers/chat_provider.dart';
import 'package:flutter_chat/providers/message_provider.dart';
import 'package:flutter_chat/screens/chat_screen/chat_screen.dart';
import 'package:flutter_chat/screens/home/components/build_drawer.dart';
import 'package:flutter_chat/screens/home/components/chat_tile.dart';
import 'package:flutter_chat/shared_preferences.dart';
import 'package:flutter_chat/utilities/firestore_helper.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot<Object?>>? userStream, chatsStream;
  bool _isSearching = false;
  final searchEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatRoomStream().then((value) {
      setState(() {
        chatsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(
              _isSearching ? Icons.search_off_outlined : Icons.search_outlined,
            ),
          ),
        ],
      ),
      drawer: BuildDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: _isSearching
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autofocus: true,
                            controller: searchEditingController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(
                                20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ),
                              ),
                              hintText: "Search a user",
                              suffixIcon: Icon(Icons.search_outlined),
                            ),
                            onChanged: (value) async {
                              if (value.trim().length > 3) {
                                userStream = await FireStoreHelper()
                                    .getUserbyUsername(value);
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getSearchedUserList(),
                  ],
                )
              : chatsList(),
        ),
      ),
    );
  }

  Future getChatRoomStream() async {
    return await Provider.of<ChatProvider>(context, listen: false)
        .getChatSnapshot();
  }

  Widget chatsList() {
    final myUserName = MySharedPreferences.sharedPreferences
        .getString(MySharedPreferences.userNameKey)!;
    return StreamBuilder<QuerySnapshot>(
        stream: chatsStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Some error occurred"),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data.docs[index];

                return ChatTile(document);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget getSearchedUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Some error occurred"),
          );
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final document = snapshot.data.docs[index];
              return showSearchedUser(document, context);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  ListTile showSearchedUser(document, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          document['image'],
        ),
      ),
      title: Text(
        document['name'],
      ),
      onTap: () async {
        await Provider.of<ChatProvider>(context, listen: false)
            .createChats(context, document['username']);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              imageUrl: document['image'],
              username: document['username'],
            ),
          ),
        );
      },
    );
  }
}
