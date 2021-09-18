import 'package:flutter/material.dart';
class AboutDev extends StatefulWidget {
  const AboutDev({Key? key}) : super(key: key);

  @override
  _AboutDevState createState() => _AboutDevState();
}

class _AboutDevState extends State<AboutDev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Developer'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            //SizedBox(height: 30,),
            Column(
              children: [
                Text('Developer Name: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                Text('Adekunle Oludaini (S219202003) ',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  overflow: TextOverflow.visible,
                )
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Text('Physical Address: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                Text('Computer Science, Crescent University ',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  overflow: TextOverflow.visible,
                )
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Text('Promotional Text: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                Text('Design and Implementation of an Android-based mobile Timetable Application for Computer Science Students. Also usable for other students in other disciplines. ',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  overflow: TextOverflow.visible,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
