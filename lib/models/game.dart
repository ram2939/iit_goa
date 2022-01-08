import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String? uuid;
  final int? gameNo;
  final String? name;
  final String? description;
  final int? status;
  final int? entered_count;
  final int? survived_count;
  List<String>? died = [];
  List<String>? entered = [];

  Game(
      {this.entered,
      this.died,
      this.description,
      this.gameNo,
      this.name,
      this.status,
      this.uuid,
      this.entered_count,
      this.survived_count});
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      uuid: json['uuid'],
      name: json['name'],
      gameNo: json['game_no'],
      description: json['description'],
      status: 0,
      died: [],
      entered: [],
    );
  }
  static fromDocument(DocumentSnapshot json) {
    return Game(
      uuid: json['uuid'],
      name: json['name'],
      gameNo: json['game_no'],
      description: json['description'],
      status: 0,
      died: [],
      entered: [],
    );
  }
}
