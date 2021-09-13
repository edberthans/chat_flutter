import 'package:flutter/material.dart';
import 'package:chat_flutter/Component/defaultElements.dart';

class listOfChats {
  String userId;

  listOfChats({
    this.userId,
  });

  static listOfChats fromJson(Map<String, dynamic> json) => listOfChats(
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() => {
        'userId' : userId,
      };
}
