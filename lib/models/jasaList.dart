import 'package:flutter/material.dart';
import 'package:chat_flutter/Component/defaultElements.dart';

class JasaList {
  final String name;
  final String gender;
  String price;
  List<String> pictures;
  String description;
  String notes;
  String languages; 
  int height; 
  List<String> preferences;

  JasaList({
    this.name,
    this.gender,
    this.price,
    this.pictures,
    this.description,
    this.notes,
    this.languages,
    this.height,
    this.preferences,
  });
}
