import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class BuildDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: ClipRRect(
                    child: Image.network(user.photoURL!),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.025,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName!),
                    Text(user.email!),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              await Provider.of<AuthenticateProvider>(context, listen: false)
                  .logout();
            },
          ),
        ],
      ),
    );
  }
}
