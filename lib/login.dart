import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timetable/menu.dart';
import 'package:timetable/register.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final databaseReference = FirebaseDatabase.instance.reference();

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),

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
                    hintText: 'Email'
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password'
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text('Login'),
                onPressed: () async {
                  try{
                    await _auth.signInWithEmailAndPassword(email: email, password: password);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MenuPage(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully Login.'),
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
                          Text(' Ops! Login Failed'),
                          content: Text('${e.message}'),
                        )
                    );
                  }
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text('Register Page'),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));

                  print('object');

                },
              ),
              SizedBox(height: 20,),
              Text('Developed by Adekunle Oludaini (S219202003)  '),
            ],
          ),
        ),
      ),
    );
  }
}
