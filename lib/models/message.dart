import 'package:flutter/material.dart';

import '../utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idUser;
  final String targetUser;
  final String urlAvatar;
  final String username;
  final String message;
  final DateTime createdAt;

  const Message({
    @required this.idUser,
    @required this.targetUser,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    @required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        idUser: json['idUser'],
        targetUser: json['targetUser'],
        urlAvatar: json['urlAvatar'],
        username: json['username'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'idUser' : idUser,
        'targetUser' : targetUser,
        'urlAvatar': urlAvatar,
        'username': username,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}
