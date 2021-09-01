import 'dart:io';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/services/auth.dart';
import 'package:chat_flutter/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// Widget to capture and crop the image
class DocumentUpload extends StatefulWidget {
  createState() => _DocumentUploadState();
}

Image picture;
String picUrl;
String docUrl;

class _DocumentUploadState extends State<DocumentUpload> {
  /// Active image file
  File _imageFile;
  UserData userdata;

  /// Cropper plugin
  // Future<void> _cropImage() async {
  //   File cropped = await ImageCropper.cropImage(
  //       sourcePath: _imageFile.path,
  //       // ratioX: 1.0,
  //       // ratioY: 1.0,
  //       // maxWidth: 512,
  //       // maxHeight: 512,
  //       toolbarColor: Colors.purple,
  //       toolbarWidgetColor: Colors.white,
  //       toolbarTitle: 'Crop It');

  //   setState(() {
  //     _imageFile = cropped ?? _imageFile;
  //   });
  // }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        userdata = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('KTP / SIM Verification'),
            backgroundColor: Colors.cyanAccent[700],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.photo_camera,
                    size: 30,
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(
                    Icons.photo_library,
                    size: 30,
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  color: Colors.pink,
                ),
              ],
            ),
          ),
          body: ListView(
            children: <Widget>[
              if (_imageFile != null) ...[
                Container(
                    padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // FlatButton(
                    //   color: Colors.white,
                    //   child: Icon(Icons.crop),
                    //   onPressed: _cropImage,
                    // ),
                    FlatButton(
                      color: Colors.white,
                      child: Icon(Icons.refresh),
                      onPressed: _clear,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Uploader(
                    file: _imageFile,
                  ),
                )
              ]
            ],
          ),
        );
      }
    );
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final AuthService _auth = AuthService();
  UserData userdata;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://flutter-project-62ceb.appspot.com/');

  StorageUploadTask _uploadTask;

  _startUploadDocument() {
    String filePath = 'documents/${userdata.uid + userdata.name}.png';
    StorageTaskSnapshot storageTaskSnapshot;

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });

    _uploadTask.onComplete.then((value){
      if (value.error == null){
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadurl) async {
          docUrl = downloadurl;
          await DatabaseService(uid: userdata.uid).updateUserData(
            userdata.name,
            userdata.picture,
            '',
            userdata.datebirth,
            userdata.gender,
            false,
            docUrl,
          ).then(await DatabaseService(uid: userdata.uid).setJasaData(
            userdata.name, userdata.gender, "", "", "", "Indonesia", 0, [], []
            ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                userdata = snapshot.data;
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_uploadTask.isComplete)
                        Text('Verifikasi akan memakan waktu 2x24jam'),
                        Text('🎉🎉🎉',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                height: 2,
                                fontSize: 30)),
                      if (_uploadTask.isPaused)
                        FlatButton(
                          child: Icon(Icons.play_arrow, size: 50),
                          onPressed: _uploadTask.resume,
                        ),
                      if (_uploadTask.isInProgress)
                        FlatButton(
                          child: Icon(Icons.pause, size: 50),
                          onPressed: _uploadTask.pause,
                        ),

                        
                      LinearProgressIndicator(value: progressPercent),
                      Text(
                        '${(progressPercent * 100).toStringAsFixed(2)} % ',
                        style: TextStyle(fontSize: 50),
                      ),
                    ]);
              }
            );
          });
    } else {
      return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          userdata = snapshot.data;
          return FlatButton.icon(
              color: Colors.blue,
              label: Text('Upload To Verify'),
              icon: Icon(Icons.cloud_upload),
              onPressed: () async{
                _startUploadDocument();
                // FutureBuilder(
                //   future: getImage(context, 'images/${userdata.uid + userdata.name}.png'),
                //   builder: (context, snapshot){
                //     if (snapshot.connectionState == ConnectionState.done){
                //       print('done' + snapshot.data);
                //     }
                //   }
                // );
                // await DatabaseService(uid: user.uid).updateUserData(
                //   userdata.name,
                //   picture,
                //   '',
                //   '',
                //   userdata.gender,
                // );
              });
        }
      );
    }
  }
}

//get image url
class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}


Future<Widget> getImage(BuildContext context, String imageName) async {
  await FireStorageService.loadImage(context, imageName).then((value) {
    picture = Image.network(value.toString(), fit: BoxFit.scaleDown,);
  });
}
