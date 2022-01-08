import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/game.dart';
import 'models/player.dart';
import 'models/worker.dart';
import 'package:http/http.dart' as http;

class Repository {
  static final List<Player> players = [];
  static final List<Worker> workers = [];
  static final List<Game> games = [];
  static final CollectionReference players_ref =
      FirebaseFirestore.instance.collection("players");
  static final CollectionReference workers_ref =
      FirebaseFirestore.instance.collection("workers");
  static final CollectionReference games_ref =
      FirebaseFirestore.instance.collection("games");
  static final CollectionReference pass =
      FirebaseFirestore.instance.collection("vipPassword");
  static const String _url = 'https://hackoverflow-cepheus.herokuapp.com';

  static Future<void> fetchData() async {
    final data = await players_ref.get();
    for (var d in data.docs) {
      players.add(Player.fromDocument(d));
    }

    final data2 = await workers_ref.get();
    for (var d in data2.docs) {
      workers.add(Worker.fromDocument(d));
    }
  }

  static Future<void> getData() async {
    await _getPlayers();
    await _getWorkers();
    await _getGames();
  }

  static Future<void> _getPlayers() async {
    final http.Response result = await http.get(Uri.parse(_url + "/players"));
    final data = (json.decode(result.body))['rows'];
    for (var row in data) {
      players.add(Player.fromJson(row));
      row['isAlive'] = true;
      await players_ref.add(row);
    }
  }

  static Future<void> _getWorkers() async {
    final result = await http.get(Uri.parse(_url + "/workers"));
    final data = (json.decode(result.body))['rows'];
    for (var row in data) {
      workers.add(Worker.fromJson(row));

      await workers_ref.add({
        'name': row['name'],
        'dob': row['dob'],
        'address': row['address'],
        'occupation': row['occupation']
      });
    }
  }

  static Future<void> _getGames() async {
    final result = await http.get(Uri.parse(_url + "/games"));
    final data = (json.decode(result.body))['rows'];
    for (var row in data) {
      games.add(Game.fromJson(row));
      await games_ref.add(row);
    }
  }

  static Future<void> updateWorker(String name, String newJob) async {
    final result = await workers_ref.where('name', isEqualTo: name).get();
    final id = result.docs[0].id;
    var data = result.docs[0].data();
    data = data as Map<String, dynamic>;
    data['job'] = newJob;
    await workers_ref.doc(id).update(data);
  }

  static Future<void> updatePlayer(String name, bool status) async {
    final result = await players_ref.where('name', isEqualTo: name).get();
    final id = result.docs[0].id;
    var data = result.docs[0].data();
    data = data as Map<String, dynamic>;
    data['isAlive'] = status;
    await players_ref.doc(id).update(data);
  }

  static Future<void> updatePlayerBet(String name, int bet) async {
    final result = await players_ref.where('name', isEqualTo: name).get();
    final id = result.docs[0].id;
    var data = result.docs[0].data();
    data = data as Map<String, dynamic>;
    data['currentBet'] = data['currentBet'] ?? 0 + bet;
    await players_ref.doc(id).update(data);
  }

  static Future<void> updateGameEntered(int game_no) async {
    final result = await games_ref.where('game_no', isEqualTo: game_no).get();
    final id = result.docs[0].id;

    final data = await players_ref.where('isAlive', isEqualTo: true).get();
    List<String> alive_ids = [];
    for (var i in data.docs) {
      alive_ids.add(i.id);
    }

    var updatedData = result.docs[0].data();
    updatedData = updatedData as Map<String, dynamic>;
    updatedData['entered'] = alive_ids;
    updatedData['entered_count'] = alive_ids.length;
    await workers_ref.doc(id).update(updatedData);
  }

  static Future<void> updateGameSurvived(int game_no) async {
    final result = await games_ref.where('game_no', isEqualTo: game_no).get();
    final id = result.docs[0].id;

    final data = await players_ref.where('isAlive', isEqualTo: true).get();
    List<String> alive_ids = [];
    for (var i in data.docs) {
      var x = i.data() as Map<String, dynamic>;
      x['gamesPlayed'] = x['gamesPlayed'] ?? 0 + 1;
      await players_ref.doc(i.id).update(x);
      alive_ids.add(i.id);
    }

    var updatedData = result.docs[0].data();
    updatedData = updatedData as Map<String, dynamic>;
    updatedData['surived'] = alive_ids;
    updatedData['survived_count'] = alive_ids.length;
    await workers_ref.doc(id).update(updatedData);
  }

  static Future<int> getAlive() async {
    final data = await players_ref.where('isAlive', isEqualTo: true).get();
    return data.docs.length;
  }

  static Future<void> generateExcel() async {}
}
