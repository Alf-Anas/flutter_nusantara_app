import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

const users = {
  'user01': '12345',
  'user02': 'abcde',
};

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
        tag: 'hero',
        child: Image.asset('images/logo.png', width: 200, height: 200));

    const appName = Center(
      child: Text(
        'Nusantara App',
        style: TextStyle(
            fontFamily: 'Oxygen',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white70),
      ),
    );

    final username = TextField(
      keyboardType: TextInputType.name,
      autofocus: false,
      onChanged: (String value) {
        setState(() {
          _username = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Username => user01',
        labelText: 'Username',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextField(
      autofocus: false,
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _password = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Password => 12345',
        labelText: 'Password',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48),
        child: ElevatedButton(
          child: const Center(
              child: Text('Log In',
                  style: TextStyle(color: Colors.white, fontSize: 16))),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            if (!users.containsKey(_username)) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Username tidak terdaftar!'),
                    );
                  });
            } else if (users[_username] != _password) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Username dan Password tidak sesuai!'),
                    );
                  });
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const HomePage();
              }));
            }
          },
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 1],
            colors: [Colors.red, Colors.white],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(minWidth: 150, maxWidth: 600),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Card(
              elevation: 0,
              color: Colors.white12,
              margin: const EdgeInsets.all(20.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    logo,
                    const SizedBox(height: 4.0),
                    appName,
                    const SizedBox(height: 48.0),
                    username,
                    const SizedBox(height: 8.0),
                    password,
                    const SizedBox(height: 24.0),
                    loginButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
