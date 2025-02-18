import 'package:crew_brew/models/quiz/Quiz.dart';
import 'package:crew_brew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../models/user/AppUser.dart';
import '../../../shared/loading.dart';
import '../quiztile_resource/dialog.dart';
import '../quiztile_resource/image_funktion.dart';

/// ! Information about the class:
/// ~ This class represents ONE entry in the List
/// ! Use of the class:
/// ~ It's used as a template for ListView entry in screens/quizes/quiz_list.dart

/// ! TODOS:
/// all done

class QuizTile extends StatefulWidget {
  const QuizTile({Key? key, required this.quiz}) : super(key: key);
  final Quiz quiz;

  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  @override
  Widget build(BuildContext context) {
    /// set the string backPicture with the quizcategory
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final user = Provider.of<AppUser?>(context);
    String backPickture = widget.quiz.quizCategory;

    if (user == null) {
      return Loading();
    } else {
      bool userIsOwner = user.uid == widget.quiz.quizOwnerUID;
      return GestureDetector(
          ///when the card is pressed it oppends a new one
          onTap: () =>
              Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                return _PopupCard(quiz: widget.quiz);
              })),
          child: Hero(
              tag: _heroAddTodo,
              child: Card(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  ///set the distance between the card and the phone border
                  margin: const EdgeInsets.fromLTRB(20.0, 9.0, 20.0, 9.0),
                  ///change the corners of the appso its circular
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  ///here the background for the card is set
                  /// ~ This adds option to delete
                  child: Slidable(
                    startActionPane: ActionPane(
                      extentRatio: 0.35,
                      /// A motion is a widget used to control how the pane animates.
                      motion: StretchMotion(),
                      /// All actions are defined in the children parameter.
                      children: [
                        /// A SlidableAction can have an icon and/or a label.
                        (userIsOwner)
                            ? SlidableAction(
                                onPressed: (context) {
                                  print("trying to delete");
                                  DatabaseService(uid: user.uid)
                                      .deleteOneQuizesPerUID(widget.quiz);
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              )
                            : SlidableAction(
                                onPressed: (context) {
                                  print("trying to add");
                                  DatabaseService(uid: user.uid)
                                      .createQuizData(widget.quiz);
                                },
                                backgroundColor: Color(0xFF4976FE),
                                foregroundColor: Colors.white,
                                icon: Icons.download_outlined,
                                label: 'Download',
                              ),
                      ],
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                ///this funtion set the background immage
                                image: AssetImage(image(backPickture)))),
                        child: Padding(
                            /// the distance between the contetent of the card and the corder of the card
                            padding: const EdgeInsets.all(14.0),
                            ///Content of the card
                            child: Column(children: [
                              ///Title and Shared Icon
                              Stack(children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 70, 0),
                                    /// is for the background of the text
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.teal.shade500,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0),
                                            )),
                                        //////////////////////////////////////////////////////////////////////Quiz Title
                                        child: Text(
                                            "  " + widget.quiz.quizTitle + "  ",
                                            style: const TextStyle(
                                                fontFamily: 'Lobster',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Colors.white)))),
                                ///Shared Icon
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                      ),
                                      ///how big the picture should and the card itself
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: Icon(
                                        Icons.group,
                                        color: widget.quiz.quizIsShared
                                            ? Colors.green
                                            : Colors.red,
                                      ), ///<- here should be logik to change the picture
                                    )),
                              ]),
                              ///discription
                              Stack(children: [
                                /// discribtion
                                Center(
                                  child: Padding(
                                    ///is for that the text and the picture dont overlape
                                    ///change the possition of the text
                                    padding:
                                        const EdgeInsets.fromLTRB(1, 5, 10, 5),
                                    ///where the text shoul be
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        ///text content
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                                bottomLeft:
                                                    Radius.circular(20.0),
                                                bottomRight:
                                                    Radius.circular(20.0),
                                              )),

                                          /////////////////////////////////////////////////
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 10.0, 5.0, 10.0),
                                            child: Text(
                                                "Quiz description: " +
                                                    widget
                                                        .quiz.quizDescription +
                                                    "  ",
                                                style: const TextStyle(
                                                    fontFamily: 'Lobster',
                                                    fontSize: 21,
                                                    color: Colors.white)),
                                          ),
                                        )),
                                  ),
                                ),
                              ]),
                              ///Bottom Text and Botton

                              Row(
                                  ///here are the bottons i have to create my own one because the ones we have arent working with the hero fuktion.
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ///where the bottom text should be
                                    (userIsOwner)
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.26,
                                              child: ElevatedButton(
                                                ///////////////////////////////////////////////////////////////////////////////// Change Quiz

                                                onPressed: () =>
                                                    Navigator.pushNamed(
                                                  context,
                                                  '/EditOldQuizUI',
                                                  arguments: {
                                                    'quiz': widget.quiz
                                                  },
                                                ),
                                                ///<----here for changing the quiz

                                                style: ElevatedButton.styleFrom(
                                                  primary:
                                                      const Color(0xFFFF9800),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5.0, 1.0, 5.0, 0.0),
                                                  child: Text(
                                                    'Edit Quiz',
                                                    style: TextStyle(
                                                        fontFamily: 'Lobster',
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        : Container(),

                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          child: ElevatedButton(
                                            ///////////////////////////////////////////////////////////////////////////////////////join quiz
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFFFF9800),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 1.0, 5.0, 0.0),
                                              child: Text(
                                                'Join Quiz',
                                                style: TextStyle(
                                                    fontFamily: 'Lobster',
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        )),

                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          child: ElevatedButton(
                                            ///////////////////////////////////////////////////////////////////////////////////////////Play quiz
                                            onPressed: () =>
                                                Navigator.pushReplacementNamed(
                                              context,
                                              '/quizWrapper',
                                              arguments: {'quiz': widget.quiz},
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: const Color(0xFFFF9800),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.0, 1.0, 5.0, 0.0),
                                              child: Text(
                                                'Play Quiz',
                                                style: TextStyle(
                                                    fontFamily: 'Lobster',
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ]),
                            ]))),
                  ))));
    }
  }
}

///when you click on the first card this second card is oppened.
///____________________________________________________________----------------------------------------------------------------------
const String _heroAddTodo = 'add-todo-hero';

///with the stransition the values from quiz comes to the new popcard
class _PopupCard extends StatefulWidget {
  const _PopupCard({Key? key, required this.quiz}) : super(key: key);
  final Quiz quiz;

  @override
  State<_PopupCard> createState() => _PopupCardState();
}

class _PopupCardState extends State<_PopupCard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    bool userIsOwner = user!.uid == widget.quiz.quizOwnerUID;

    Size size = MediaQuery.of(context).size;
    double gapBetweenFields = size.height * (1.5/100);
    double paddingFromLeft = size.width * (3/100);

    @override
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String backPickture = widget.quiz.quizCategory;
    return Center(
        child: SizedBox(
      width: width * 0.8,
      height: height * 0.8,
      child: Hero(
        tag: _heroAddTodo,
        child: Material(
            elevation: 8.0,
            clipBehavior: Clip.antiAlias,
            ///set the distance between the card and the phone border
            ///change the corners of the app
            ///so its circular
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image(backPickture)))),
              child: Padding(
                /// the distance between the contetent of the card and the corder of the card
                padding: const EdgeInsets.all(14.0),
                ///Content of the card
                child: Column(children: [
                  ///Title and Shared Icon
                  Stack(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(paddingFromLeft, 0, 40, 0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.teal.shade500,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                )),
                            //////////////////////////////////////////////////////////////////////
                            child: Text("  " + widget.quiz.quizTitle + "  ",
                                style: const TextStyle(
                                    fontFamily: 'Lobster',
                                    fontSize: 25,
                                    color: Colors.white)))),
                    Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(150),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.height * 0.05,
                          child: Icon(
                            Icons.group,
                            color: widget.quiz.quizIsShared
                                ? (Colors.green)
                                : Colors.red,
                          ), ///<- here should be logik to change the picture
                        )),
                  ]),
                  ///middle part of the card where the picture and describtion is stackede
                  Stack(children: [
                    Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.height * 0.13,
                            child: Image.asset(
                              "assets/images/eddu.png",
                            ) ///<- here should be logik to change the picture
                            )),
                    /// discribtion
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          ///is for that the text and the picture dont overlape
                          ///change the possition of the text

                          padding: EdgeInsets.fromLTRB(paddingFromLeft, gapBetweenFields, 80, gapBetweenFields),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    paddingFromLeft, gapBetweenFields, 10.0, gapBetweenFields),
                                child: Text(
                                    widget.quiz.quizDescription,
                                    style: const TextStyle(
                                      fontFamily: 'Lobster',
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                              ))),
                    ),
                  ]),
                  //////////////////////////////////////////////////////////////////////////////////////////Number of questions
                  Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  paddingFromLeft, gapBetweenFields, 1.0, gapBetweenFields),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    )),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      paddingFromLeft, gapBetweenFields, 15.0, gapBetweenFields),
                                  child: Text(
                                      'Number of Questions: ' +
                                          widget.quiz.listOfQuestions.length
                                              .toString() +
                                          '  ',
                                      style: const TextStyle(
                                          fontFamily: 'Lobster',
                                          fontSize: 19,
                                          color: Colors.white)),
                                ),
                              )))),

                  //////////////////////////////////////////////////////////////////////////////////////////////more information
                  Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  paddingFromLeft, gapBetweenFields, 1.0, gapBetweenFields),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      paddingFromLeft, gapBetweenFields, 15.0, gapBetweenFields),
                                  child: Text(
                                      'Tags: ' +
                                          widget.quiz.tags.join(", "),
                                      style: const TextStyle(
                                          fontFamily: 'Lobster',
                                          fontSize: 19,
                                          color: Colors.white)),
                                ),
                              )))),

                  SizedBox(height: gapBetweenFields * 3),
                  ///Bottom Text and Botton
                  SizedBox(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        (userIsOwner)
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: ElevatedButton(
                                    onPressed: () => () {
                                      Navigator.pushNamed(
                                        context,
                                        '/EditOldQuizUI',
                                        arguments: {'quiz': widget.quiz},
                                      );
                                    }, ///<----here for changing the quiz
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFFFF9800),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.0, gapBetweenFields / 6, 5.0, gapBetweenFields / 6),
                                      child: Text(
                                        'Edit Quiz',
                                        style: TextStyle(
                                            fontFamily: 'Lobster',
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ))
                            : Container(),
                        Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/quizWrapper',
                                          arguments: {'quiz': widget.quiz},
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      primary: const Color(0xFFFF9800),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5.0, gapBetweenFields / 6, 5.0, gapBetweenFields / 6),
                                      child: Text(
                                        'Join Quiz',
                                        style: TextStyle(
                                            fontFamily: 'Lobster',
                                            fontSize: 16),
                                      ),
                                    )))),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/quizWrapper',
                                  arguments: {'quiz': widget.quiz},
                                ), ///<-here for joining the quiz
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFFFF9800),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(5.0, gapBetweenFields / 6, 5.0, gapBetweenFields / 6),
                                  child: Text(
                                    'Play Quiz',
                                    style: TextStyle(
                                        fontFamily: 'Lobster', fontSize: 16),
                                  ),
                                ),
                              ),
                            )),
                      ])),
                  ///Back botton
                  SizedBox(height: size.height / 50),
                  SizedBox(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFFFF9800),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(5.0, gapBetweenFields / 6, 5.0, gapBetweenFields / 6),
                                  child: Text(
                                    'Back',
                                    style: TextStyle(
                                        fontFamily: 'Lobster', fontSize: 16),
                                  ),
                                ),
                              ),
                            )),
                      ])),
                  SizedBox(height: gapBetweenFields * 3),
                  ///Quiz owner
                  Align(
                    child: SizedBox(
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: paddingFromLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal.shade500,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  child: Text(
                                      "Quiz Owner: " +
                                          widget.quiz.quizOwner,
                                      style: const TextStyle(
                                          fontFamily: 'Lobster',
                                          fontSize: 19,
                                          color: Colors.white)),
                                ),
                              ),
                            ))),
                  )
                ]),
              ),
            )),
      ),
    ));
  }
}
