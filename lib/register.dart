import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timetable/login.dart';
import 'package:timetable/menu.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final firestoreInstance = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String firstname = '';
  String lastname = '';
  String matricNo = '';
  String level = '';
  String phone = '';
  String password = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Student register with their details here', style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  hintText: 'First name'
                ),
                onChanged: (value) {
                  firstname = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Last name'
                ),
                onChanged: (value) {
                  lastname = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Matric no.'
                ),
                onChanged: (value) {
                  matricNo = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Phone'
                ),
                onChanged: (value) {
                  phone = value;
                },
              ),

              TextField(
                decoration: InputDecoration(
                    hintText: 'Email'
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Level'
                ),
                onChanged: (value) {
                  level = value;
                },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text('Register'),
                onPressed: () async {
                  try{


                    await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
/*                      databaseReference.child(_auth.currentUser!.uid).set({
                        'firstname': firstname,
                        'lastname': lastname,
                        'matric': matricNo,
                        'phone': phone,
                        'email': email,
                        'level': level,
                      });
                    */
                      firestoreInstance.collection('users').doc(_auth.currentUser!.uid).collection('details').add({
                        'firstname': firstname,
                        'lastname': lastname,
                        'matric': matricNo,
                        'phone': phone,
                        'email': email,
                        'level': level,
                      });
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sucessfully Register.You Can Login Now'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    //Navigator.of(context).pop();
                  } on FirebaseAuthException catch (e) {
                    print(e.message);
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title:
                          Text(' Ops! Registration Failed'),
                          content: Text('${e.message}'),
                        )
                    );
                  }
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text('Login Page'),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  print('object');

                },
              ),
              SizedBox(height: 20,),
              Text('Developed by Adekunle Oludaini (S219202003)  '),
            ],
          ),
        ),
      )
    );
  }
}
