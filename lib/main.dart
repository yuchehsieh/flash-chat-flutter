import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.black54),
//        ),
//      ),
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.routeId,
      routes: {
        WelcomeScreen.routeId: (ctx) => WelcomeScreen(),
        LoginScreen.routeId: (ctx) => LoginScreen(),
        RegistrationScreen.routeId: (ctx) => RegistrationScreen(),
        ChatScreen.routeId: (ctx) => ChatScreen(),
      },
    );
  }
}
