import 'package:crew_brew/models/quiz/Quiz.dart';
import 'package:crew_brew/models/user/AppUser.dart';
import 'package:crew_brew/navigationBar/NavBar.dart';
import 'package:crew_brew/screens/quizes/quiz_list.dart';
import 'package:crew_brew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:crew_brew/services/database.dart';
import 'package:provider/provider.dart';

// ! Information about the class:
// ~ This class represents myQuizes Page
// ! Use of the class:
// ~ It shows quizes that belong to current user. They can be shared ( blue ) or not shared ( brown )

// ! TODOS:
// TODO Improve loading as done in welcome and sign_in with boolean loading variable
// TODO Do the scheck if Quiz data was succesfully fetched from the DB

class MyQuizes extends StatelessWidget {
  MyQuizes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ! Provider.of<AppUser?>(context):
    // ~ Here we listen to the stream, defined in services/auth.dart and provided by main.dart, which informs us about login state of the user
    // ~ We need user instance to have acess to DatabaseService instance
    final user = Provider.of<AppUser?>(context);

    // ! If user is logged in, display the myQuizes page
    if (user != null) {
      // ! StreamProvider<Quiz>
      // ~ Here we define StreamProvider based on the stream defined in services/database.dart
      // ~ Listens to a Stream and exposes its content to child and descendants.
      // ~ If the data is changed in the DB, it is immediately reflected in the myQzuies screen and any screens below in widget tree
      return StreamProvider<List<Quiz>?>.value(
        initialData: null,
        // ! value
        // ~ Here we define to which stream we will listen to
        value: DatabaseService(uid: user.uid).myQuizes,
        child: Scaffold(
          // ! NavBar():
          // ~ Here we provide NavBar for property drawer. This is our navigation bar defined in navigationBar/navBar.dart
          drawer: NavBar(),
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            title: Text('Quiz App'),
            backgroundColor: Colors.brown[400],
            elevation: 0.0,
          ),
          // ! This is the body of our app, which consists of the background and Quizes of current user
          body: Container(
              // ! BoxDecoration:
              // ~ A widget that lets you draw arbitrary graphics.
              // ~ We use it to display the backround image of the body
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/home_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              // ! QuizList:
              // ~ This is where List is generated
              // ~ Stream List<Quiz> is provided to this child
              child: QuizList()),
        ),
      );
      // ! If user is not logged in or data is still fetching from DB, return Loading screen
    } else {
      return Loading();
    }
  }
}
