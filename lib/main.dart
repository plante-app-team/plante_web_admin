import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: "84481772151-aisj7p71ovque8tbsi8ribpc5iv7bpjd.apps.googleusercontent.com");

    final account = await googleSignIn.signIn();
    if (account == null) {
      print("GoogleAuthorizer: googleSignIn.signIn returned null");
    }

    final authentication = await account.authentication;
    final idToken = authentication.idToken;
    if (idToken == null) {
      print("GoogleAuthorizer: authentication.idToken returned null");
      return null;
    }

    print("Google user: ${account.displayName}, ${account.email}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Yeee haaa!'))// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
