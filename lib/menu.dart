import 'package:flutter/material.dart';
import 'package:timetable/lectures/view_lectures.dart';
import 'package:timetable/settings/settings.dart';
import 'package:timetable/testExam/testExam.dart';
class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome', style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewLectures())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child:  Column(
                      children: [
                        Image.asset('images/presentation.png', height: 100,),
                        SizedBox(height: 10,),
                        Text("Lectures", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                      ],
                    ),
                    //color: Colors.teal[100],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TestExam())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child:  Column(
                      children: [
                        Image.asset('images/exam.png', height: 100,),
                        SizedBox(height: 10,),
                        Text("Test/Exams", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                      ],
                    ),
                    //color: Colors.teal[100],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child:  Column(
                      children: [
                        Image.asset('images/settings.png', height: 100,),
                        SizedBox(height: 10,),
                        Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                      ],
                    ),
                    //color: Colors.teal[100],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child:  Column(
                    children: [
                      Image.asset('images/information.png', height: 100,),
                      SizedBox(height: 10,),
                      Text("Help", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                    ],
                  ),
                  //color: Colors.teal[100],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
