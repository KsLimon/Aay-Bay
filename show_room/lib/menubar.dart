import 'package:flutter/material.dart';
import 'package:show_room/screens/home_screen.dart';
import 'package:show_room/services/auth_service.dart';
import 'package:flame_audio/flame_audio.dart';


import 'constants.dart';
import 'main.dart';

class menubar extends StatelessWidget{
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context){
    return PopupMenuButton(
      color: obackground,
      shape: OutlineInputBorder(
        borderSide: BorderSide(
            color: knewText,
            width: 2
        ),
      ),
      icon: Icon(Icons.menu_book_sharp, color: knewText),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
            },
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              iconColor: knewText,
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: (){},
            child: ListTile(
              leading: Icon(Icons.clear_rounded),
              title: Text("Monthly Cost"),
              iconColor: knewText,
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: (){},
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Edit Profile"),
              iconColor: knewText,
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () async{
              await FlameAudio.bgm.pause();
            },
            child: ListTile(
              leading: Icon(Icons.music_off_outlined),
              title: Text("Stop Music"),
              iconColor: knewText,
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () async{
              await FlameAudio.bgm.resume();
            },
            child: ListTile(
              leading: Icon(Icons.music_note_outlined),
              title: Text("Resume Music"),
              iconColor: knewText,
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: GestureDetector(
            onTap: ()async {
    await authClass.signOut();
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (builder) => MyApp()),
    (route) => false);
    },
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("SIGN OUT"),
              iconColor: knewText,
              ),
            ),
          ),
      ],
    );
  }
}