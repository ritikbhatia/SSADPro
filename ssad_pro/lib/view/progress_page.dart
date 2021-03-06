/**
 * This class return the layout of the page showing
 * progress of each student in adventure mode as well
 * as compete mode.
 *
 *
 */

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ssadpro/view/progress_components.dart';
import 'package:ssadpro/model/user.dart';
import 'package:ssadpro/controller/score_list.dart';
import 'package:provider/provider.dart';
import 'package:ssadpro/services/database.dart';
import 'package:ssadpro/model/progress.dart';

class ProgressPage extends StatefulWidget {
  final String userdata;
  // final Widget child;

  ProgressPage({this.userdata});

  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<charts.Series<Score, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<Task, String>> _seriesPieData1;
  List<charts.Series<Task, String>> _seriesPieData2;

  final abc = ScoreList();
  // final String userProgress;
  int flag = 0;
  int len;

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<Score, String>>();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesPieData1 = List<charts.Series<Task, String>>();
    _seriesPieData2 = List<charts.Series<Task, String>>();
    // _generateData(points);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    print(widget.userdata);
    return StreamBuilder<UserData>(
      stream: DatabaseService(email: user.email).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          List<dynamic> points = userData.points.toList();
          print(points);
          len = points.length;
          double worlds = double.parse(Progress.getWorld(widget.userdata));
          double sections = (worlds - 1) * 5 +
              double.parse(Progress.getSection(widget.userdata));
          double levels = (worlds - 1) * 15 +
              double.parse(Progress.getLevel(widget.userdata));
          //_generateData(points);
          print(widget.userdata);
          // function body of generatePoints
          List<Score> data1 = [];

          for (var i = 0; i < len; i++) {
            data1.add(Score(1, i + 1, points[i]));
          }

          var piedata = [
            new Task('Worlds Completed', worlds, Color(0xffFC963E)),
            new Task('Worlds Left', 5.0 - worlds, Colors.blue),
          ];

          var sectiondata = [
            new Task('Sections Completed', sections, Color(0xffFC963E)),
            new Task('Sections Left', 5.0 * 5.0 - sections, Colors.blue),
          ];

          var leveldata = [
            new Task('Levels Completed', levels, Color(0xffFC963E)),
            new Task('Levels Left', 5.0 * 5.0 * 3.0 - levels, Colors.blue),
          ];

          _seriesData.add(
            charts.Series(
              domainFn: (Score score, _) => score.date.toString(),
              measureFn: (Score score, _) => score.quantity,
              id: '1',
              data: data1,
              fillPatternFn: (_, __) => charts.FillPatternType.solid,
              fillColorFn: (Score score, _) =>
                  charts.ColorUtil.fromDartColor(Color(0xffFC963E)),
            ),
          );

          _seriesPieData.add(
            charts.Series(
              domainFn: (Task task, _) => task.task,
              measureFn: (Task task, _) => task.taskvalue,
              colorFn: (Task task, _) =>
                  charts.ColorUtil.fromDartColor(task.colorval),
              id: 'World Progress',
              data: piedata,
              labelAccessorFn: (Task row, _) => '${row.taskvalue}',
            ),
          );

          _seriesPieData1.add(
            charts.Series(
              domainFn: (Task task, _) => task.task,
              measureFn: (Task task, _) => task.taskvalue,
              colorFn: (Task task, _) =>
                  charts.ColorUtil.fromDartColor(task.colorval),
              id: 'Section Progress',
              data: sectiondata,
              labelAccessorFn: (Task row, _) => '${row.taskvalue}',
            ),
          );

          _seriesPieData2.add(
            charts.Series(
              domainFn: (Task task, _) => task.task,
              measureFn: (Task task, _) => task.taskvalue,
              colorFn: (Task task, _) =>
                  charts.ColorUtil.fromDartColor(task.colorval),
              id: 'Level Progress',
              data: leveldata,
              labelAccessorFn: (Task row, _) => '${row.taskvalue}',
            ),
          );

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/space_background.png"),
                  fit: BoxFit.cover,
//                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(), BlendMode.dstATop)
                ),
              ),
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("Student Progress",
                        style: TextStyle(
                            color: Colors.brown[700],
                            fontSize: 35,
                            fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.amberAccent[100],
                    brightness: Brightness.light,
                    elevation: 0,
                    iconTheme: IconThemeData(
                      color: Colors.brown[700],
                      //change your color here
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(60.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.brown[700],
                            height: 4.0,
                          ),
                          Container(
                            child: TabBar(
                              tabs: [
                                Tab(
                                  icon: Icon(
                                    FontAwesomeIcons.solidChartBar,
                                    color: Colors.brown[700],
                                    size: 30,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    FontAwesomeIcons.chartPie,
                                    color: Colors.brown[700],
                                    size: 30,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    FontAwesomeIcons.poll,
                                    color: Colors.brown[700],
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Student progress - Compete Mode',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: ProgressComponents.getBarChart(
                                      _seriesData),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Student progress - Adventure Mode',
                                  style: TextStyle(
                                      color: Colors.brown[700],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'World Progress',
                                  style: TextStyle(
                                      color: Colors.brown[700],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Expanded(
                                  child: ProgressComponents.getPieChart(
                                      _seriesPieData),
                                ),
                                Text(
                                  'Section Progress',
                                  style: TextStyle(
                                      color: Colors.brown[700],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Expanded(
                                  child: ProgressComponents.getPieChart(
                                      _seriesPieData1),
                                ),
                                Text(
                                  'Level Progress',
                                  style: TextStyle(
                                      color: Colors.brown[700],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Expanded(
                                  child: ProgressComponents.getPieChart(
                                      _seriesPieData2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Strengths and Weakness',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 15),
                                    SizedBox(
                                        width: 300,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          textColor: Colors.white,
                                          color: Colors.blue[700],
                                          onPressed: () {},
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(children: <Widget>[
                                                  Text(
                                                    "World 1",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Best Performance: \n Requirement Elicitation",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    " Worst Performance: \n Requirement Specification",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ])
                                              ]),
                                        )),
                                    SizedBox(height: 10),
                                    SizedBox(
                                        width: 300,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          textColor: Colors.white,
                                          color: Colors.grey[500],
                                          onPressed: () {},
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Center(
                                                  child: Text(
                                                      "World 2 \n Not Available",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center),
                                                )
                                              ]),
                                        )),
                                    SizedBox(height: 10),
                                    SizedBox(
                                        width: 300,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          textColor: Colors.white,
                                          color: Colors.grey[500],
                                          onPressed: () {},
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Center(
                                                  child: Text(
                                                      "World 3 \n Not Available",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center),
                                                )
                                              ]),
                                        )),
                                    SizedBox(height: 10),
                                    SizedBox(
                                        width: 300,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          textColor: Colors.white,
                                          color: Colors.grey[500],
                                          onPressed: () {},
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Center(
                                                  child: Text(
                                                      "World 4 \n Not Available",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center),
                                                )
                                              ]),
                                        )),
                                    SizedBox(height: 10),
                                    SizedBox(
                                        width: 300,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          textColor: Colors.white,
                                          color: Colors.grey[500],
                                          onPressed: () {},
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Center(
                                                  child: Text(
                                                      "World 5 \n Not Available",
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center),
                                                )
                                              ]),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Text('Error Retreiving Points');
        }
      },
    );
  }
}

class Score {
  int date;
  int studentid;
  int quantity;

  Score(this.studentid, this.date, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
