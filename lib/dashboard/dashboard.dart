// import 'dart:html';

import 'package:chat_flutter/dashboard/multiImage.dart';
import 'package:chat_flutter/dashboard/jasaRegisterForm.dart';
import 'package:chat_flutter/dashboard/documentUpload.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/screens/home/home_page.dart';
import 'package:chat_flutter/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/shared/globals.dart';
import 'package:provider/provider.dart';

String verifiedNotification;

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    UserData userdata;
    
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        userdata = snapshot.data;

        Future<void> _showVerifiedDialog() async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Verified Account'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Account is already verified.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  RaisedButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Dashboard'
            ),
            backgroundColor: Global.mediumBlue,
            elevation: 0,
          ),
          backgroundColor: Global.mediumBlue,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Icon(Icons.menu, color: Colors.white,size: 52.0,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userdata.picture),
                            radius: 30,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,90,0),
                          child: Text(
                            userdata.name,
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 40
                            ),
                          ),
                        ),
                      ],
                    ),
                    // child: Center(
                    //   child: CircleAvatar(
                    //     backgroundImage: NetworkImage(userdata.picture),
                    //     radius: 30,
                    //   ),
                    // ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(18.0),
                  //   child: Text(
                  //     "Welcome,  \nSelect an option",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 28.0,
                  //       fontWeight: FontWeight.bold
                  //     ),
                  //     textAlign: TextAlign.start,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Wrap(
                        spacing:20,
                        runSpacing: 20.0,
                        children: <Widget>[
                          SizedBox(
                            width:160.0,
                            height: 160.0,
                            child: Card(

                              color: Color.fromARGB(255,21, 21, 21),
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)
                              ),
                              child:Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/todo.png",width: 64.0,),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Todo List",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "2 Items",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100
                                      ),
                                    )
                                  ],
                                  ),
                                )
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width:160.0,
                          //   height: 160.0,
                          //   child: Card(

                          //     color: Color.fromARGB(255,21, 21, 21),
                          //     elevation: 2.0,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8.0)
                          //     ),
                          //     child:Center(
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Column(
                          //             children: <Widget>[
                          //               Image.asset("assets/images/note.png",width: 64.0,),
                          //               SizedBox(
                          //                 height: 10.0,
                          //               ),
                          //               Text(
                          //                 "Notes",
                          //                 style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 20.0
                          //                 ),
                          //               ),
                          //               SizedBox(
                          //                 height: 5.0,
                          //               ),
                          //               Text(
                          //                 "12 Items",
                          //                 style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.w100
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         )
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width:160.0,
                          //   height: 160.0,
                          //   child: Card(

                          //     color: Color.fromARGB(255,21, 21, 21),
                          //     elevation: 2.0,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8.0)
                          //     ),
                          //     child:Center(
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Column(
                          //             children: <Widget>[
                          //               Image.asset("assets/images/calendar.png",width: 64.0,),
                          //               SizedBox(
                          //                 height: 10.0,
                          //               ),
                          //               Text(
                          //                 "Agenda",
                          //                 style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: 20.0
                          //                 ),
                          //               ),
                          //               SizedBox(
                          //                 height: 5.0,
                          //               ),
                          //               Text(
                          //                 "4 Items",
                          //                 style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.w100
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         )
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width:160.0,
                          //   height: 160.0,
                          //   child: Card(

                          //     color: Color.fromARGB(255,21, 21, 21),
                          //     elevation: 2.0,
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8.0)
                          //     ),
                          //     child: Center(
                          //         child: RaisedButton(
                          //           color: Color.fromARGB(255,21, 21, 21),
                          //           onPressed: () {
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(builder: (context) => Dashboard()),
                          //             );
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Column(
                          //               children: <Widget>[
                          //                 Image.asset("assets/images/settings.png",width: 64.0,),
                          //                 SizedBox(
                          //                   height: 10.0,
                          //                 ),
                          //                 Text(
                          //                   "Settings",
                          //                   style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontWeight: FontWeight.bold,
                          //                       fontSize: 20.0
                          //                   ),
                          //                 ),
                          //                 SizedBox(
                          //                   height: 5.0,
                          //                 ),
                          //                 Text(
                          //                   "6 Items",
                          //                   style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontWeight: FontWeight.w100
                          //                   ),
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         )
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            width:160.0,
                            height: 160.0,
                            child: Card(

                              color: Color.fromARGB(255,21, 21, 21),
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Center(
                                  child: RaisedButton(
                                    color: Color.fromARGB(255,21, 21, 21),
                                    onPressed: () {
                                      print(userdata.verifiedDocument);
                                      if (userdata.verifiedDocument == true) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => JasaRegisterForm()),
                                        );
                                      }
                                      else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DocumentUpload()),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset("assets/images/kencan.png",width: 64.0,height: 64,),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            '  Be A Part \n     Of Us',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          )
        );
      }
    );
  }
}
