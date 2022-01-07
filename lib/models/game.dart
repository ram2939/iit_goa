import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String? uuid;
  final int? gameNo;
  final String? name;
  final String? description;
  List<String>? died = [];
  List<String>? entered = [];

  Game({
    this.entered,
    this.died,
    this.description,
    this.gameNo,
    this.name,
    this.uuid,
  });
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      uuid: json['uuid'],
      name: json['name'],
      gameNo: json['game_no'],
      description: json['description'],
      died: [],
      entered: [],
    );
  }
  static fromDocument(DocumentSnapshot doc) {}
}
