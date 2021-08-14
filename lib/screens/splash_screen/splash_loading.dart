// import 'package:e_commerce_app/providers/Customer.dart';
// import 'package:e_commerce_app/providers/HomePage.dart';
// import 'package:e_commerce_app/screens/home/home_screen.dart';
// import 'package:e_commerce_app/screens/splash/splash_screen.dart';
// import 'package:e_commerce_app/shared_preferences.dart';
// import 'package:e_commerce_app/utilities/log_out.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/authenticate_screen/authenticate_screen.dart';
import 'package:flutter_chat/size_config.dart';

class SplashLoadingScreen extends StatefulWidget {
  static const routeName = '/splashLoading';

  @override
  _SplashLoadingScreenState createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  getFirstWidget() {
    return AuthenticateScreen.routeName;
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
    ).then(
      (_) => Navigator.of(context).pushReplacementNamed(
        getFirstWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).cardTheme.color,
        ),
        Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                          color: Colors.orange,
                          fontSize: 32,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
