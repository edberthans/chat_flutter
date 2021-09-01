import 'package:chat_flutter/data.dart';
import 'package:chat_flutter/models/chatUser.dart';
import 'package:chat_flutter/models/chats.dart';
import 'package:chat_flutter/models/jasaList.dart';
import 'package:chat_flutter/models/jasaUserData.dart';
import 'package:chat_flutter/models/message.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/shared/imageCapture.dart';
import 'package:chat_flutter/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference chatCollection = Firestore.instance.collection('user');
  final CollectionReference jasaCollection = Firestore.instance.collection('jasa');

  Future updateUserData(String name, String picture, String phone, String datebirth, String gender, bool verifiedDocument, String docUrl) async {
    return await chatCollection.document(uid).setData({
      'name': name,
      'picture': picture,
      'phone': phone,
      'datebirth': datebirth,
      'gender': gender,
      'verifiedDocument' : verifiedDocument,
      'docUrl' : docUrl,

    });
  }

  Future setJasaData(String name, String gender, String price, String description, String notes, String languages, int height, List<String> preferences, List<String> pictures) async {
    return await jasaCollection.document(uid).setData({
      'jasaName' : name,
      'jasaGender': gender,
      'jasaPrice' : price,
      'jasaDescription': description ?? '',
      'jasaNotes': notes ?? '',
      'jasaLanguages': languages ?? 'Indonesia',
      'jasaHeight': height ?? 0,
      'jasaPreferences': preferences ?? '',
      'jasaPictures': pictures ?? []
    });
  }

  Future updateJasaImagesData(List<String> pictures) async {
    print('uploading jasa image' + pictures[0]);
    return await jasaCollection.document(uid).updateData({
      'jasaPictures': pictures,
    });
  }

  static Future uploadMessage(String idUser, String message) async {
    final refMessages =
        Firestore.instance.collection('chats/$idUser/messages');

    final newMessage = Message(
      idUser: idUser,
      urlAvatar: myUrlAvatar,
      username: myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = Firestore.instance.collection('chats');
    await refUsers
      .document(idUser)
      .updateData({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String idUser) =>
      Firestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  //chats list from snapshots
  List<Chats> _chatsListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) => Chats(
      datebirth: doc.data['datebirth'] ?? '',
      phone: doc.data['phone'] ?? '',
      name: doc.data['name'] ?? '',
      picture: doc.data['picture'] ?? '',
      gender: doc.data['gender'] ?? '',
    )).toList();
  }

  //jasa list from snapshots
  List<JasaUserData> _jasaListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) => JasaUserData(
      uid:uid,
      name: doc.data['jasaName'],
      gender: doc.data['jasaGender'],
      price: doc.data['jasaPrice'],
      obj2: doc.data['jasaPictures'] ?? [''],
      description: doc.data['jasaDescription'],
      notes: doc.data['jasaNotes'],
      languages: doc.data['jasaLanguanges'] ?? 'Indonesia',
      height: doc.data['jasaHeight'],
      obj1: doc.data['jasaPreferences'] ?? [''],
      pictures: [],
      preferences: [],
    )).toList();
  }

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid:uid,
      datebirth: snapshot.data['datebirth'] ?? '',
      phone: snapshot.data['phone'] ?? '',
      name: snapshot.data['name'] ?? '',
      picture: snapshot.data['picture'] ?? '',
      gender: snapshot.data['gender'] ?? '',
      verifiedDocument: snapshot.data['verifiedDocument'],
      docUrl: snapshot.data['docUrl'] ?? '',
    );
  }

  //jasa user data from snapshot
  JasaUserData _jasauserDataFromSnapshot(DocumentSnapshot snapshot){
    return JasaUserData(
      uid:uid,
      name: snapshot.data['jasaName'],
      gender: snapshot.data['jasaGender'],
      price: snapshot.data['jasaPrice'],
      obj2: snapshot.data['jasaPictures'] ?? [''],
      description: snapshot.data['jasaDescription'],
      notes: snapshot.data['jasaNotes'],
      languages: snapshot.data['jasaLanguanges'] ?? 'Indonesia',
      height: snapshot.data['jasaHeight'],
      obj1: snapshot.data['jasaPreferences'] ?? [''],
      pictures: [],
      preferences: [],
    );
    
  }

  //get user chat
  Stream<List<Chats>> get chats {
    return chatCollection.snapshots()
      .map(_chatsListFromSnapshot);
  }

  //get jasa list
  Stream<List<JasaUserData>> get jasaLists {
    return jasaCollection.snapshots()
      .map(_jasaListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData{
    return chatCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

  //get jasa user doc stream
  Stream<JasaUserData> get jasauserData{
    return jasaCollection.document(uid).snapshots()
      .map(_jasauserDataFromSnapshot);
  }

  //
  static Stream<List<chatUser>> getUsers() => Firestore.instance
      .collection('chats')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(chatUser.fromJson));

}

