import 'package:chat_flutter/models/message.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/services/database.dart';
import 'package:chat_flutter/models/jasaUserData.dart';
import 'package:chat_flutter/widgets/chat_body_widget.dart';
import 'package:chat_flutter/widgets/chat_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){ 
    final user = Provider.of<User>(context);
    return Scaffold(
        backgroundColor: Colors.amberAccent,
        body: SafeArea(
          child: StreamBuilder<List<Message>>(
            stream: DatabaseService(uid: user.uid).messageByUid,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try later');
                  }
                  else {
                    // print(snapshot.data[0].toJson());
                    final users = snapshot.data;
                    
                    if (users.isEmpty || users.isEmpty == null) {
                      return buildText('No Users Found');
                    } else
                      return Column(
                        children: [
                          ChatHeaderWidget(users: users),
                          ChatBodyWidget(users: users)
                        ],
                      );
                  }
              }
            },
          ),
        ),
      );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.brown),
        ),
      );
}