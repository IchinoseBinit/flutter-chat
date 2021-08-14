import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/components/default_button.dart';
import 'package:flutter_chat/providers/authentication_provider.dart';
import 'package:flutter_chat/screens/home/home.dart';
import 'package:flutter_chat/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AuthenticateScreen extends StatelessWidget {
  static const routeName = '/loginScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Some error has occurred"),
          );
        } else {
          return getSignedOutWidget(context);
        }
      },
    ));
  }

  Widget getSignedOutWidget(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50.0,
                child: Icon(
                  Icons.chat_outlined,
                  size: 48.0,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Lets Chat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.1,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "One click away to chat!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.01,
              ),
              Center(
                child: DefaultButton(
                  text: 'Sign in with Google',
                  icon: FontAwesomeIcons.google,
                  press: () async {
                    final provider = Provider.of<AuthenticateProvider>(context,
                        listen: false);

                    await provider.authenticateWithGoogle();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
