import 'dart:io';

import 'package:chat_flutter/models/jasaUserData.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:chat_flutter/services/database.dart';
import 'package:provider/provider.dart';

class MultiImage extends StatefulWidget {
  @override
  _MultiImageState createState() => _MultiImageState();
}

class _MultiImageState extends State<MultiImage> {
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.FirebaseStorage ref;

  UserData userData;

  List<File> _image = [];
  List<String> imageUrls = [];

  StorageUploadTask _uploadTask;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://flutter-project-62ceb.appspot.com/');
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        userData = snapshot.data;
        return Scaffold(
            appBar: AppBar(
              title: Text('Add Image'),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        uploading = true;
                      });
                      _startUpload(user).whenComplete(() => Navigator.of(context).pop());
                    },
                    child: Text(
                      'upload',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: GridView.builder(
                      itemCount: _image.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () =>
                                        !uploading ? chooseImage() : null),
                              )
                            : Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      }),
                ),
                uploading
                    ? Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Text(
                              'uploading...',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            value: val,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          )
                        ],
                      ))
                    : Container(),
              ],
            ));
      }
    );
  }

  chooseImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  _startUpload(user) {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
    String filePath = 'jasaImages/${Path.basename(img.path)}';
    StorageTaskSnapshot storageTaskSnapshot;

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(img);
    });

    _uploadTask.onComplete.then((value) async{
      if (value.error == null){
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadurl) async {
          // print(downloadurl + 'url');
          // imgRef.add({'url': downloadurl});
          imageUrls.insert(i-1, downloadurl);
          // imageUrls.insert(i, downloadurl);
          i++;
          await DatabaseService(uid: user.uid).updateJasaImagesData(
            imageUrls
          );
        });
      }
      else{
        print('error here  :  ' + value.error.toString());
      }
      
    });
    
  }
    
  }
}