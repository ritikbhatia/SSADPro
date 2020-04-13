import 'package:flutter/material.dart';
import 'package:ssadpro/controller/txt_handle.dart';
import 'package:ssadpro/view/appbar.dart';
import 'package:ssadpro/view/mcq_boxes.dart';
import 'mcq_boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:ssadpro/view/match_page.dart';

class FIBPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState(question, answer);

  final String question;
  final String answer;
  FIBPage(this.question, this.answer);
}

class _InputPageState extends State<FIBPage> with TickerProviderStateMixin {
  final myController = TextEditingController();
  AnimationController controller;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  final String question;
  final String answer;
  int confirmButton = 0;
  _InputPageState(this.question, this.answer);

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ReusableWidgets.getAppBar(
            "Fill in the Blanks", Colors.blue[600], Colors.grey[50]),
        body: Container(
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: SingleChildScrollView(
                  child: Container(
                    height: 600,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 100),
                          MCQBoxes.getFibQuestion(question),
                          SizedBox(height: 20),
                          AnimatedBuilder(
                              animation: offsetAnimation,
                              builder: (buildContext, child) {
                                if (offsetAnimation.value < 0.0)
                                  print('${offsetAnimation.value + 8.0}');
                                return Center(
                                  child: Container(
                                    decoration: new BoxDecoration(boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey[400],
                                        blurRadius: 50.0,
                                      ),
                                    ]),
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: SizedBox(
                                        child: RaisedButton(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side:
                                              BorderSide(color: Colors.white)),
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      textColor: Colors.black,
                                      color: confirmButton == 0
                                          ? Colors.white
                                          : (confirmButton == 1
                                              ? Colors.green[200]
                                              : Colors.red),
                                      //Colors.white,
                                      onPressed: () {},
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 10.0,
                                              left:
                                                  offsetAnimation.value + 15.0,
                                              right:
                                                  15.0 - offsetAnimation.value),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 30),
                                                        controller:
                                                            myController,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Enter your answer here...',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    )),
                                  ),
                                );
                              }),
                          SizedBox(height: 50),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: SizedBox(
                                width: 55.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(color: Colors.white)),
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  textColor: Colors.white,
                                  color: Colors.blue[600],
                                  onPressed: () async {
                                    if (myController.text == answer) {
                                      confirmButton = 1;
                                      createRecord("Correct", "fib");
                                      await new Future.delayed(
                                          const Duration(seconds: 2));
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => MatchPage()),
                                      );
                                    } else {
                                      confirmButton = 2;
                                      createRecord("Wrong", "fib");
                                      controller.forward(from: 0.0);
                                      await new Future.delayed(
                                          const Duration(seconds: 2));
                                      _showWrongDialog();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Confirm Answer",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  ),
                                )),
                          ),
                          SizedBox(height: 10),
                        ]),
                  ),
                ))));
  }

  void _showWrongDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Wrong Answer"),
          content: new Text("Give it another try!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
