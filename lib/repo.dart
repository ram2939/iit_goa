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
  static final CollectionReference _players_ref =
      FirebaseFirestore.instance.collection("players");
  static final CollectionReference _workers_ref =
      FirebaseFirestore.instance.collection("workers");
  static final CollectionReference _games_ref =
      FirebaseFirestore.instance.collection("games");

  static String _url = 'https://hackoverflow-cepheus.herokuapp.com';

  static Future<void> fetchData() async {
    final data = await _players_ref.get();
    for (var d in data.docs) {
      players.add(Player.fromDocument(d));
    }

    final data2 = await _workers_ref.get();
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
      await _players_ref.add(row);
    }
  }

  static Future<void> _getWorkers() async {
    final result = await http.get(Uri.parse(_url + "/workers"));
    final data = (json.decode(result.body))['rows'];
    for (var row in data) {
      workers.add(Worker.fromJson(row));
      await _workers_ref.add(row);
    }
  }

  static Future<void> _getGames() async {
    final result = await http.get(Uri.parse(_url + "/games"));
    final data = (json.decode(result.body))['rows'];
    for (var row in data) {
      games.add(Game.fromJson(row));
      await _games_ref.add(row);
    }
  }
}
