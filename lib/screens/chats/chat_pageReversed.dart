import 'package:chat_flutter/models/chatUser.dart';
import 'package:chat_flutter/models/message.dart';
import 'package:chat_flutter/models/messageReversed.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/widgets/messages_widget.dart';
import 'package:chat_flutter/widgets/new_message_widget.dart';
import 'package:chat_flutter/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';

class ChatPageReversed extends StatefulWidget {
  final MessageReversed user;

  const ChatPageReversed({
    @required this.user,
    Key key,
  }) : super(key: key);

  @override
  _ChatPageReversedState createState() => _ChatPageReversedState();
}

class _ChatPageReversedState extends State<ChatPageReversed> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.user.username),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(idUser: widget.user.idUser),
                ),
              ),
              NewMessageWidget(idUser: widget.user.idUser, myUrlAvatar: widget.user.urlAvatar, myUsername: widget.user.username, targetUser: widget.user.targetUser,)
            ],
          ),
        ),
      );
}
