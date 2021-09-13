import 'dart:collection';
import 'dart:core';
import 'package:chat_flutter/models/chatUser.dart';
import 'package:chat_flutter/models/message.dart';
import 'package:chat_flutter/models/messageReversed.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/screens/chats/chat_page.dart';
import 'package:chat_flutter/screens/chats/chat_pageReversed.dart';
import 'package:chat_flutter/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<Message> users;

  const ChatBodyWidget({
    @required this.users,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() {
      Set<String> newSet = users.map((user)=> user.targetUser).toSet();
      List<String> shownUsers = [];
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // print(newSet);
          final user = Provider.of<User>(context);
          final chat = users[index];
          if(user.uid == newSet.elementAt(index)){
            return StreamBuilder<UserData>(
              stream: DatabaseService(uid: chat.idUser).userData,
              builder: (context, snapshot) {
                final message = Message(idUser: user.uid, targetUser: snapshot.data.uid, urlAvatar: snapshot.data.picture, username: snapshot.data.name, message: chat.message);
                if(shownUsers.contains(message.idUser) == false){
                  shownUsers.add(message.idUser);
                  print(shownUsers);
                  return Container(
                    height: 75,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPage(user: message),
                        ));
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(message.urlAvatar),
                      ),
                      title: Text(message.username),
                    ),
                  );
                }
                else{
                  return Container();
                }
              }
            );
          }
          else{
            print('else');
            return StreamBuilder<UserData>(
              stream: DatabaseService(uid: newSet.elementAt(index)).userData,
              builder: (context, snapshot) {
                // print(user.uid);
                final message = MessageReversed(idUser: user.uid, targetUser: snapshot.data.uid, urlAvatar: snapshot.data.picture, username: snapshot.data.name, message: chat.message);
                
                if(shownUsers.contains(message.idUser) == false){
                  shownUsers.add(snapshot.data.uid);
                  shownUsers.add(user.uid);
                  return Container(
                    height: 75,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPageReversed(user: message),
                        ));
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(message.urlAvatar),
                      ),
                      title: Text(message.username),
                    ),
                  );
                }
                else{
                  return Container();
                }
              }
            );
          }
        },
        itemCount: newSet.toList().length,
      );
  }
}
