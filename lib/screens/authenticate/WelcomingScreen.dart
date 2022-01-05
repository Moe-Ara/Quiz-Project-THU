// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors, duplicate_ignore, unnecessary_new

import 'dart:ui';
import 'package:crew_brew/services/auth.dart';
import 'package:crew_brew/shared/customWidgets/customAlertBox.dart';
import 'package:crew_brew/shared/customWidgets/customButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crew_brew/shared/customWidgets/customText.dart';
import 'package:crew_brew/shared/customWidgets/customTextField.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crew_brew/shared/colors.dart';

class WelcominScreen extends StatefulWidget {
  WelcominScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WelcominScreen> createState() => _WelcominScreenState();
}

class _WelcominScreenState extends State<WelcominScreen> {
  //couple of objects
  final CustomText _customText = CustomText();

  //couple of controllers
  final TextEditingController _pinController = TextEditingController();

  final TextEditingController _displayNameController = TextEditingController();

// listen to changes on _displaycontroller
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _displayNameController.addListener(_getDisplayName);
  }

// delete listener when we leave the screen
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _displayNameController.dispose();
    super.dispose();
  }

//get the changes from the _displaycontroller
  Future _getDisplayName() async {
    return _displayNameController.text;
  }

  //size of the screen
  final AuthService _auth = AuthService();
  final int offset = 30;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //see signup.dart
      //resizeToAvoidBottomInset: false,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          //* Background
          image: DecorationImage(
              image: AssetImage('assets/images/bgtop.png'), fit: BoxFit.cover),
        ),
        child:
            //*children inside screen
            SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(1.0, 30.0, 1.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                //*Text
                _customText.customText("Welcome to\n The Quizzler !!!",
                    backgroundColor: welcomeh),
                //*Logo/pic on welcoming screen
                eduLogo(),
                SizedBox(
                  height: size.height * 0.01,
                ),
                //*create space between the widget and the sides of the screen
                Container(
                  padding: EdgeInsets.only(
                    left: (0.2 * size.width),
                    right: (0.2 * size.width),
                  ),
                  //*text field to add type in the display name; you can probably use the custom ones, but i will leave that to the frontend team
                  child: CustomTextField().customTextField(
                    _displayNameController,
                    'Display Name',
                    size.width,
                    TextInputType.text,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  padding: EdgeInsets.only(
                    left: (0.2 * size.width),
                    right: (0.2 * size.width),
                  ),
                  //*text field to add type in the pin of the live quizz; you can probably use the custom ones, but i will leave that to the frontend team
                  child: CustomTextField().customTextField(
                      _pinController, 'Pin', size.width, TextInputType.text),
                ),
                SizedBox(height: size.height * 0.02),
                //* Button
                joinButton(context),
                SizedBox(height: size.height * 0.05),
                //*just a widget with the buttons for login or sign up
                //* frontend can improve the quality of this widget by using the custom Widgets; only if they want to
                signInOrUp(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget joinButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: "joinButton",
      extendedPadding: EdgeInsets.fromLTRB(15, 40, 40, 40),
      extendedIconLabelSpacing: 20,
      onPressed: () async {
        //get the entered display name
        String _username = await _getDisplayName();
        // ~ Signin anonymously
        dynamic result = await _auth.signInAnon(() async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return customAlertBox("An Error Has Happened !!!", "");
              });
        }, displayName: _username);
        // ~ If login is not succesful, we provide an error message
        if (result == null) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return customAlertBox(
                    "An Error Has Happened !!!", "Couldn't log in anonymously");
              });
        }
      },
      label: const Text(
        'Join',
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Lobster',
        ),
      ),
      icon: Icon(
        Icons.keyboard_arrow_right_rounded,
        size: 36.0,
      ),
      backgroundColor: buttons,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
    );
  }

//? The following widget is a column with two buttons and a text between them (login button ---Or--- Register)
  Widget signInOrUp(BuildContext cntxt) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText().customText('--- or ---', fontsize: 30),
        SizedBox(
          height: 15,
        ),
        CustomButton(
          label: "Log In",
          backgroundcolor: buttons,
          function: () {
            Navigator.pushNamed(cntxt, '/signin');
          },
          padding: 40,
        ),
        SizedBox(
          height: 10,
        ),
        CustomButton(
          label: "Register",
          backgroundcolor: buttons,
          function: () {
            Navigator.pushNamed(cntxt, '/register');
          },
          padding: 30,
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
              text: 'Check our ',
              style: TextStyle(color: texts, fontFamily: 'Satisfy'),
              children: [
                TextSpan(
                    text: 'Website',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURLApp();
                      },
                    style: TextStyle(color: links))
              ]),
        ),
      ],
    );
  }

//small little log at the top of the wecloming page, use whatever pic you want or even comment it out if you want to
  Widget eduLogo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 100,
      height: 100,
      child: Image.asset(
        'assets/images/eddu.png',
        fit: BoxFit.cover,
      ),
    );
  }

  //?these are to redirect user to a link
  _launchURLApp() async {
    const url = 'https://flutterdevs.com/';
    if (await launch(url, forceSafariVC: true, forceWebView: true)) {
    } else {
      throw 'Could not launch $url';
    }
  }
}
