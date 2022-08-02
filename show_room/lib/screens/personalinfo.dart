import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:show_room/screens/sighin.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../services/auth_service.dart';
import 'home_screen.dart';


class Personalinfo extends StatefulWidget {
  Personalinfo({Key? key}) : super(key: key);

  @override
  _PersonalinfoState createState() => _PersonalinfoState();
}

class _PersonalinfoState extends State<Personalinfo> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
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
                "Your Profile Info",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              textcell("Name...", _nameController, false),
              SizedBox(
                height: 15,
              ),
              textcell("Phone...", _phoneController, false),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  try{
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final User? user = auth.currentUser!;
                    var totalcollection = FirebaseFirestore.instance.collection('Users').doc(user?.email);
                    Map<String, dynamic> tamountmap = {
                      "Name": _nameController.text,
                      "Phone": _phoneController.text
                    };
                    setState(() {
                      circular = false;
                    });
                    totalcollection.set(tamountmap).whenComplete(() => {
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (builder) => Homescreen()), (route) => false)
                    });

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
                      "Submit",
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