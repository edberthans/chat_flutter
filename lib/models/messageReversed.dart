import 'package:flutter/material.dart';

import '../utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class MessageReversed {
  String idUser;
  String targetUser;
  String urlAvatar;
  String username;
  String message;
  DateTime createdAt;

  MessageReversed({
    @required this.idUser,
    @required this.targetUser,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    this.createdAt
  });

  static MessageReversed fromJson(Map<String, dynamic> json) => MessageReversed(
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
