import 'package:flutter/material.dart';
import 'package:show_room/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../services/auth_service.dart';
import 'home_screen.dart';


class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              textcell("Email....", _emailController, false),
              SizedBox(
                height: 15,
              ),
              textcell("Password...", _pwdController, true),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  try{
                    firebase_auth.UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
                        email: _emailController.text, password: _pwdController.text
                    );
                    authClass.storeTokenAndData(userCredential);
                    setState(() {
                      circular = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => Homescreen()),
                            (route) => false);
                  }
                  catch (e){
                    final snackbar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    setState(() {
                      circular = false;
                    });
                  }
                },
                child: Container(
                  height: 30,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff465eff),
                        Color(0xff5b9dff),
                        Color(0xff328eff),
                      ],
                    ),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                      "LogIn",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I Don't Have Any Account?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                              (route) => false);
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                              (route) => false);
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget textcell(String labelText, TextEditingController controller, bool obscureText){
  return Container(
    height: 54,
    width: 325,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      // style: te,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color(0xFF3FAFFA),
          fontSize: 17,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}