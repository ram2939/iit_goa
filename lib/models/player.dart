import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String? name;
  // final String? id;
  final String? dob;
  final String? occupation;
  final String? address;
  final double? debt;
  bool? isAlive;
  int currentBet = 0;
  int? nextGame;
  int? gamesPlayed = 0;
  Player({
    this.name,
    required this.currentBet,
    this.nextGame,
    this.gamesPlayed,
    this.dob,
    this.occupation,
    this.address,
    this.debt,
    this.isAlive,
  });
  static fromDocument(DocumentSnapshot doc) {
    return Player(
        currentBet: doc['currentBet'] ?? 0,
        nextGame: doc['nextGame'] ?? 1,
        isAlive: doc['isAlive'],
        name: doc['name'],
        dob: doc['dob'],
        occupation: doc['occupation'],
        address: doc['address'],
        debt: double.tryParse(doc['debt'].toString()),
        gamesPlayed: doc['gamesPlayed'] ?? 0);
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
        name: json['name'],
        dob: json['dob'],
        address: json['address'],
        occupation: json['occupation'],
        debt: double.tryParse(json['debt'].toString()),
        isAlive: true,
        currentBet: 0,
        nextGame: 1);
  }
  void kill() {
    isAlive = false;
  }
}
