import 'dart:convert';
import 'dart:io';
import 'package:chat_flutter/dashboard/multiImage.dart';
import 'package:chat_flutter/models/imageUploadModel.dart';
import 'package:chat_flutter/models/jasaUserData.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/services/database.dart';
import 'package:chat_flutter/shared/constants.dart';
import 'package:chat_flutter/shared/globals.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class JasaRegisterForm extends StatefulWidget {
  final File file;

  const JasaRegisterForm({Key key, this.file}) : super(key: key);

  @override
  _JasaRegisterFormState createState() {
    return _JasaRegisterFormState();
  }
}

class _JasaRegisterFormState extends State<JasaRegisterForm> {
  List<Object> images = List<Object>();
  List<String> imagesUrl;
  String picUrl;
  Future<File> _imageFile;
  UserData userdata;
  JasaUserData jasauser;
  DateTime datetime;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String dateWithT;
  String formattedDate;
  List<bool> checked = [false, false, false, false, false];
  String description;
  String price;
  String notes;
  int height;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://flutter-project-62ceb.appspot.com/');

  StorageUploadTask _uploadTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }


  _startUpload(index) {
    String filePath = 'jasaImages/${userdata.uid + userdata.name}.png';
    StorageTaskSnapshot storageTaskSnapshot;
    print('storage:');
    print(storageTaskSnapshot);
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    _uploadTask.onComplete.then((value){
      if (value.error == null){
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadurl) async {
          imagesUrl[index] = downloadurl;
        });
      }
    });
  }

  _convertPicturesObj(List<Object> obj){
    for(int i = 0; i < obj.length; i++){
      jasauser.pictures.add(obj[i].toString());
    }
  }

  _convertPreferencesObj(List<Object> obj){
    for(int i = 0; i < obj.length; i++){
      jasauser.preferences.add(obj[i].toString());
      // setState(() {
      //   jasauser.preferences.add(obj[i].toString());
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        userdata = snapshot.data;
        dateWithT = userdata.datebirth.substring(0, 8) + 'T' + userdata.datebirth.substring(8);
        datetime = DateTime.parse(userdata.datebirth);
        formattedDate = formatter.format(datetime);
          return StreamBuilder<JasaUserData>(
            stream: DatabaseService(uid: user.uid).jasauserData,
            builder: (context, snapshot1) {
              List<Widget> children;
              // print('has data ' + snapshot1.hasData.toString());
              if(snapshot1.hasError){
                return Text(snapshot1.error.toString());
              }
              else if(snapshot1.hasData){
                jasauser = snapshot1.data;
                // print(jasauser.obj2);
                if(snapshot1.data.obj2 != null){
                  _convertPicturesObj(jasauser.obj2);
                  _convertPreferencesObj(jasauser.obj1);
                }
                return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('Describe Yourself'),
                  backgroundColor: Global.mediumBlue,
                  elevation: 0,
                ),
                backgroundColor:Global.mediumBlue,
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await DatabaseService(uid: user.uid).setJasaData(
                      userdata.name ?? jasauser.name,
                      userdata.gender ?? jasauser.gender,
                      price ?? jasauser.price,
                      description ?? jasauser.description,
                      notes ?? jasauser.notes,
                      'Indonesia',
                      0 ?? jasauser.height,
                      jasauser.preferences ?? [],
                      jasauser.pictures ?? [],
                    );
                  },
                  child: Icon(Icons.navigate_next),
                  backgroundColor: Colors.pink,
                ),
                body: ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            // backgroundImage: AssetImage('assets/1.jpg'),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 7, 0, 0),
                              // child: Text('Change Profile Picture',
                              //   style: TextStyle(
                              //     color: Colors.white30
                              //   ),
                              // ),
                            ),
                            backgroundImage: NetworkImage(userdata.picture),
                            radius: 40,
                          ),
                        ),
                        Divider(
                          height: 60,
                          color: Colors.cyanAccent[700],
                        ),
                        Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.purple,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          userdata.name,
                          style: TextStyle(
                            color: Colors.deepOrange,
                            letterSpacing: 2,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                        'Birth Date',
                        style: TextStyle(
                          color: Colors.purple,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.deepOrange,
                          letterSpacing: 2,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Gender',
                        style: TextStyle(
                          color: Colors.purple,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        userdata.gender,
                        style: TextStyle(
                          color: Colors.deepOrange,
                          letterSpacing: 2,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: jasauser.price,
                        decoration: new InputDecoration(labelText: "Harga per kencan"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        onChanged: (input) => price = input,
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: jasauser.description,
                        decoration: formInputDecoration.copyWith(hintText: 'About Me'),
                        onChanged: (descval) {
                          description = descval;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: jasauser.notes,
                        decoration: formInputDecoration.copyWith(hintText: 'Notes'),
                        onChanged: (notesval) {
                          notes = notesval;
                        },
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Height',
                        style: TextStyle(
                          color: Colors.purple,
                          letterSpacing: 2,
                        ),
                      ),
                      CustomNumberPicker(
                        initialValue: 150,
                        maxValue: 250,
                        minValue: 100,
                        step: 1,
                        onValue: (value) {
                          setState(() {
                            height = value;
                          });
                        },
                      ),
                      ],
                    ),
                    // showPictures(),
                    FlatButton(
                      color: Colors.white,
                      child: Text('Add Images'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MultiImage()),
                            );
                          // if(jasauser.description != null){
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => MultiImage()),
                          //   );
                          // }
                          // else{
                          //   AlertDialog(content: Text('Fill Information Above Please'),);
                          // }
                        }
                    ),
                  ],
                ),
              );
              }
              else{
                return CircularProgressIndicator();
              }


              // return Scaffold(
              //   appBar: AppBar(
              //     centerTitle: true,
              //     title: const Text('Describe Yourself'),
              //     backgroundColor: Global.mediumBlue,
              //     elevation: 0,
              //   ),
              //   backgroundColor:Global.mediumBlue,
              //   floatingActionButton: FloatingActionButton(
              //     onPressed: () async {
              //       await DatabaseService(uid: user.uid).setJasaData(
              //         userdata.gender ?? jasauser.gender,
              //         description ?? jasauser.description,
              //         notes ?? jasauser.notes,
              //         'Indonesia',
              //         0 ?? jasauser.height,
              //         [] ?? jasauser.preferences,
              //         [] ?? jasauser.pictures
              //       );
              //     },
              //     child: Icon(Icons.navigate_next),
              //     backgroundColor: Colors.pink,
              //   ),
              //   body: ListView(
              //     children: <Widget>[
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Center(
              //             child: CircleAvatar(
              //               // backgroundImage: AssetImage('assets/1.jpg'),
              //               child: Padding(
              //                 padding: const EdgeInsets.fromLTRB(15, 7, 0, 0),
              //                 // child: Text('Change Profile Picture',
              //                 //   style: TextStyle(
              //                 //     color: Colors.white30
              //                 //   ),
              //                 // ),
              //               ),
              //               backgroundImage: NetworkImage(userdata.picture),
              //               radius: 40,
              //             ),
              //           ),
              //           Divider(
              //             height: 60,
              //             color: Colors.cyanAccent[700],
              //           ),
              //           Text(
              //             'Name',
              //             style: TextStyle(
              //               color: Colors.purple,
              //               letterSpacing: 2,
              //             ),
              //           ),
              //           SizedBox(height: 10,),
              //           Text(
              //             userdata.name,
              //             style: TextStyle(
              //               color: Colors.deepOrange,
              //               letterSpacing: 2,
              //               fontSize: 28,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           SizedBox(height: 20,),
              //           Text(
              //           'Birth Date',
              //           style: TextStyle(
              //             color: Colors.purple,
              //             letterSpacing: 2,
              //           ),
              //         ),
              //         SizedBox(height: 10,),
              //         Text(
              //           formattedDate,
              //           style: TextStyle(
              //             color: Colors.deepOrange,
              //             letterSpacing: 2,
              //             fontSize: 28,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         SizedBox(height: 10,),
              //         Text(
              //           'Gender',
              //           style: TextStyle(
              //             color: Colors.purple,
              //             letterSpacing: 2,
              //           ),
              //         ),
              //         SizedBox(height: 10,),
              //         Text(
              //           userdata.gender,
              //           style: TextStyle(
              //             color: Colors.deepOrange,
              //             letterSpacing: 2,
              //             fontSize: 28,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         SizedBox(height: 10,),
              //         TextFormField(
              //           // initialValue: jasauser.description,
              //           decoration: formInputDecoration.copyWith(hintText: 'About Me'),
              //           onChanged: (descval) {
              //             description = descval;
              //           },
              //         ),
              //         SizedBox(height: 20,),
              //         TextFormField(
              //           // initialValue: jasauser.notes,
              //           decoration: formInputDecoration.copyWith(hintText: 'Notes'),
              //           onChanged: (notesval) {
              //             notes = notesval;
              //           },
              //         ),
              //         SizedBox(height: 10,),
              //         Text(
              //           'Height',
              //           style: TextStyle(
              //             color: Colors.purple,
              //             letterSpacing: 2,
              //           ),
              //         ),
              //         CustomNumberPicker(
              //           initialValue: 150,
              //           maxValue: 250,
              //           minValue: 100,
              //           step: 1,
              //           onValue: (value) {
              //             setState(() {
              //               height = value;
              //             });
              //           },
              //         ),
              //         ],
              //       ),
              //       // showPictures(),
              //       FlatButton(
              //         color: Colors.white,
              //         child: Text('Add Images'),
              //           onPressed: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(builder: (context) => MultiImage()),
              //               );
              //             // if(jasauser.description != null){
              //             //   Navigator.push(
              //             //     context,
              //             //     MaterialPageRoute(builder: (context) => MultiImage()),
              //             //   );
              //             // }
              //             // else{
              //             //   AlertDialog(content: Text('Fill Information Above Please'),);
              //             // }
              //           }
              //       ),
              //     ],
              //   ),
              // );
            }
          );
        }
    );
  }

  // Widget showPictures(){
  //   if(jasauser.pictures != null || jasauser.pictures != []){
  //     return Container(
  //       padding: EdgeInsets.all(4),
  //       child: GridView.builder(
  //           itemCount: jasauser.pictures.length,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 3),
  //           itemBuilder: (context, index) {
  //             return Container(
  //               margin: EdgeInsets.all(3),
  //               child: FadeInImage.memoryNetwork(
  //                   fit: BoxFit.cover,
  //                   placeholder: kTransparentImage,
  //                   image: jasauser.pictures[index],
  //               ),
  //             );
  //           }),
  //     );
  //   }
  // }

 }