import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/game.dart';
import 'models/player.dart';
import 'models/worker.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:path_provider/path_provider.dart';

class Repository {
  static final List<Player> players = [];
  static final List<Worker> workers = [];
  static final List<Game> games = [];
  static final CollectionReference playersRef =
      FirebaseFirestore.instance.collection("players");
  static final CollectionReference workersRef =
      FirebaseFirestore.instance.collection("workers");
  static final CollectionReference gamesRef =
      FirebaseFirestore.instance.collection("games");
  static final CollectionReference pass =
      FirebaseFirestore.instance.collection("vipPassword");
  static const String _url = 'https://hackoverflow-cepheus.herokuapp.com';

  static Future<void> fetchData() async {
    final data = await playersRef.get();
    for (var d in data.docs) {
      players.add(Player.fromDocument(d));
    }

    final data2 = await workersRef.get();
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
      row['gamesPlayed'] = 0;
      await playersRef.add(row);
    }
  }

  static Future<void> _getWorkers() async {
    final result = await http.get(Uri.parse(_url + "/workers"));
    final data = (json.decode(result.body))['rows'];
    for (var row in data) {
      workers.add(Worker.fromJson(row));

      await workersRef.add({
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
      await gamesRef.add(row);
    }
  }

  static Future<void> updateWorker(String name, String newJob) async {
    final result = await workersRef.where('name', isEqualTo: name).get();
    final id = result.docs[0].id;
    var data = result.docs[0].data();
    data = data as Map<String, dynamic>;
    data['job'] = newJob;
    await workersRef.doc(id).update(data);
  }

  static Future<void> updatePlayer(String name, bool status) async {
    final result = await playersRef.where('name', isEqualTo: name).get();
    final id = result.docs[0].id;
    var data = result.docs[0].data();
    data = data as Map<String, dynamic>;
    data['isAlive'] = status;
    await playersRef.doc(id).update(data);
  }

  static Future<void> updatePlayerBet(String name, int bet) async {
    final result = await playersRef.where('name', isEqualTo: name).get();
    final id = result.docs[0].id;
    var data = result.docs[0].data();
    data = data as Map<String, dynamic>;
    data['currentBet'] = data['currentBet'] ?? 0 + bet;
    await playersRef.doc(id).update(data);
  }

  static Future<void> updateGameEntered(int gameNo) async {
    final result = await gamesRef.where('game_no', isEqualTo: gameNo).get();
    final id = result.docs[0].id;

    final data = await playersRef.where('isAlive', isEqualTo: true).get();
    List<String> aliveIds = [];
    for (var i in data.docs) {
      aliveIds.add(i.id);
    }

    var updatedData = result.docs[0].data();
    updatedData = updatedData as Map<String, dynamic>;
    updatedData['entered'] = aliveIds;
    updatedData['entered_count'] = aliveIds.length;
    updatedData['status'] = 1;
    await gamesRef.doc(id).update(updatedData);
  }

  static Future<void> updateGameSurvived(int gameNo) async {
    final result = await gamesRef.where('game_no', isEqualTo: gameNo).get();
    final id = result.docs[0].id;

    final data = await playersRef.where('isAlive', isEqualTo: true).get();
    List<String> aliveIds = [];
    for (var i in data.docs) {
      var x = i.data() as Map<String, dynamic>;
      x['gamesPlayed'] = (x['gamesPlayed'] ?? 0) + 1;
      await playersRef.doc(i.id).update(x);
      aliveIds.add(i.id);
    }

    var updatedData = result.docs[0].data();
    updatedData = updatedData as Map<String, dynamic>;
    updatedData['surived'] = aliveIds;
    updatedData['survived_count'] = aliveIds.length;
    updatedData['status'] = 2;
    await gamesRef.doc(id).update(updatedData);
  }

  static Future<int> getAlive() async {
    final data = await playersRef.where('isAlive', isEqualTo: true).get();
    return data.docs.length;
  }

  static Future<void> addWorker(
      String name, String dob, String address, String occupation, bool update,
      {String? oldName, String? job}) async {
    if (!update) {
      await workersRef.add({
        'name': name,
        'address': address,
        'dob': dob,
        'occupation': occupation,
        'job': 'None'
      });
    } else {
      final result = await workersRef.where("name", isEqualTo: oldName).get();
      await workersRef.doc(result.docs.first.id).update({
        'name': name,
        'address': address,
        'dob': dob,
        'occupation': occupation,
        'job': job
      });
    }
  }

  static Future<void> deleteWorker(String name) async {
    final res = await workersRef.where("name", isEqualTo: name).get();
    String id = res.docs[0].id;
    await workersRef.doc(id).delete();
  }

  static Future<void> addPlayer(String name, String dob, String address,
      String occupation, double debt) async {
    await playersRef.add({
      'name': name,
      'address': address,
      'dob': dob,
      'occupation': occupation,
      'debt': debt,
      'isAlive': true,
      'gamesPlayed': 0,
    });
  }

  static Future<List<Player>> getPlayers(List<dynamic> ids) async {
    List<Player> p = [];
    for (var i in ids) {
      var d = (await playersRef.doc(i).get()).data() as Map<String, dynamic>;
      p.add(
        Player(
          name: d['name'],
          dob: d['dob'],
          address: d['address'],
          occupation: d['occupation'],
          currentBet: d['currentBet'] ?? 0,
          isAlive: d['isAlive'] ?? true,
          gamesPlayed: d['gamesPlayed'] ?? 0,
          debt: d['debt'],
        ),
      );
    }
    return p;
  }

  static Future<void> generateExcel() async {
    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;
    sheet.getRangeByName('A1:H1').cellStyle.fontSize = 20;
    sheet.getRangeByName('A1:H1').cellStyle.bold = true;
    sheet.getRangeByName("A1").setText("Name");
    sheet.getRangeByName("B1").setText("DOB");
    sheet.getRangeByName("C1").setText("Occupation");
    sheet.getRangeByName("D1").setText("Address");
    sheet.getRangeByName("E1").setText("Debt");
    sheet.getRangeByName("F1").setText("Games Played");
    sheet.getRangeByName("G1").setText("Games Won");
    sheet.getRangeByName("H1").setText("Win Percentage");

    final data = await playersRef.get();
    for (var i = 1; i <= data.docs.length; i++) {
      var d = data.docs[i - 1].data() as Map<String, dynamic>;
      sheet.getRangeByIndex(i, 1).setText(d['dob']);
      sheet.getRangeByIndex(i, 2).setText(d['occupation']);
      sheet.getRangeByIndex(i, 3).setText(d['address']);
      sheet.getRangeByIndex(i, 4).setNumber(d['debt']);
      sheet.getRangeByIndex(i, 5).setNumber(1.0 * (d['gamesPlayed'] ?? 0) + 1);
      sheet.getRangeByIndex(i, 6).setNumber(1.0 * (d['gamesPlayed'] ?? 0));
      sheet.getRangeByIndex(i, 7).setNumber(
          1.0 * (d['gamesPlayed'] ?? 0 / ((d['gamesPlayed'] ?? 0) + 1)));
      Directory? directory = await getExternalStorageDirectory();
      String appDocumentsPath = directory!.path; // 2
      String filePath = '$appDocumentsPath/SquidGame.xlsx'; // 3
      //Save and launch the excel.
      final List<int> bytes = workbook.saveAsStream();
      File(filePath).writeAsBytes(bytes);
      // print(f.path);

      //Dispose the document.
      workbook.dispose();
    }
  }
}
