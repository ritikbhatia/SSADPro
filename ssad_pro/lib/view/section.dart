import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssadpro/model/Section.dart';
import 'package:flutter/foundation.dart';
import 'package:ssadpro/view/world_ui.dart';
import 'package:ssadpro/view/levelview.dart';
import 'package:ssadpro/view/appbar.dart';

class SectionUI extends StatefulWidget {
  final List<Section> list;
  int worldInt = 0;

  SectionUI({Key key, @required this.list, @required this.worldInt})
      : super(key: key);

  @override
  _SectionUIState createState() =>
      _SectionUIState(list: list, worldInt: worldInt);
}

class _SectionUIState extends State<SectionUI> {
  final List<Section> list;
  int worldInt = 0;

  _SectionUIState(
      {Key key,
      @required this.list,
      @required this.worldInt}); //: super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.getAppBar(
          "World $worldInt", Colors.blue[600], Colors.grey[50]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.lightBlue.shade900),
            )),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Text("Requirement Elicitation",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue[600], fontSize: 20)),
          ),
          SizedBox(height: 50),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 80, top: 60),
                width: 100,
                height: 100,
                color: Colors.blue[300],
                child: FlatButton(
                  child: Text('Section 1'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LevelViewPage()),
                    );
                  },
                ),
              ),
              SectionBox(list[1].sectionName),
            ],
          ),
          Row(
            children: <Widget>[
              SectionBox(list[2].sectionName),
              SectionBox(list[3].sectionName),
            ],
          ),
//          Row(
//            children: <Widget>[SectionBox('abc'), SectionBox('abc')],
//          ),
        ],
      ),
    );
  }
}

Container SectionBox(String Boxname) {
  return Container(
    margin: EdgeInsets.only(left: 80, top: 60),
    width: 100,
    height: 100,
    color: Colors.blue[300],
    child: FlatButton(
      child: Text('$Boxname'),
      onPressed: () {
        print('abc');
      },
    ),
  );
}
