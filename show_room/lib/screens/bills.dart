import 'package:flutter/material.dart';
import 'package:show_room/menubar.dart';

import '../appback.dart';
import '../constants.dart';
import '../services/auth_service.dart';

class Billscreen extends StatelessWidget{
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: menubar(),
      body: Appback(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Container(
                        height: 136,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xBAD627D3),
                          boxShadow: [BoxShadow(
                            offset: Offset(3, 3),
                            blurRadius: 10,
                            color: Colors.black, // Black color with 12% opacity
                          )
                          ],
                        ),
                        child: GestureDetector(
                          onTap: ()=> {},
                          child: Container(
                            height: 136,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kBackgrondColor,
                            ),

                            child: new Column(
                              children: [
                                new ListTile(
                                  title: Text(
                                    '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                new Container(
                                  height: 30,
                                  width: 50,
                                  margin: const EdgeInsets.only(left: 240, top: 40, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Color(0xFF31ADB8),
                                  ),
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
