import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class chatUser {
  String idUser;
  String targetUser;
  String name;
  String urlAvatar;
  DateTime lastMessageTime;

  chatUser({
    this.idUser,
    this.targetUser,
    this.name,
    this.urlAvatar,
    this.lastMessageTime,
  });

  chatUser copyWith({
    String idUser,
    String targetUser,
    String name,
    String urlAvatar,
    String lastMessageTime,
  }) =>
      chatUser(
        idUser: idUser ?? this.idUser,
        targetUser: targetUser?? this.targetUser,
        name: name ?? this.name,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static chatUser fromJson(Map<String, dynamic> json) => chatUser(
        idUser: json['idUser'],
        targetUser: json['targetUser'],
        name: json['username'],
        urlAvatar: json['urlAvatar'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'targetUser': targetUser,
        'username': name,
        'urlAvatar': urlAvatar,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
