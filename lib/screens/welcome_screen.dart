import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'registration_screen.dart';
import 'login_screen.dart';
import 'components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeId = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.forward();
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.decelerate,
      ),

      /// OR SIMPLY using controller
      /// Tween class + CurvedAnimation class is powerful
    );
    controller.addListener(() {
      setState(() {});

      /// In order to trigger refresh the screen
      /// If directly using the value of controller/animation
      /// (controller.value) (animation.value)
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'flash_image',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.of(context).pushNamed(LoginScreen.routeId);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).pushNamed(RegistrationScreen.routeId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
