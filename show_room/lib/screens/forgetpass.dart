import 'package:flutter/material.dart';
import 'package:show_room/screens/sighin.dart';
import 'package:show_room/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../services/auth_service.dart';
import 'home_screen.dart';


class ForgetPass extends StatefulWidget {
  ForgetPass({Key? key}) : super(key: key);

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
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
              const Text(
                "Reset Your Password",
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
              InkWell(
                onTap: () async {
                  try{

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context)=> Center(child: CircularProgressIndicator()),
                    );

                    await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());

                    final snackbar = SnackBar(content: Text("Check your email inbox or spam."));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => SignInPage()),
                            (route) => false);
                  }
                  on firebase_auth.FirebaseAuthException catch (e){
                    final snackbar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.of(context).pop();
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
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
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