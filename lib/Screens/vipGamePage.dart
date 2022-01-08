import 'package:flutter/material.dart';
import 'package:hackathon/Screens/particularGameScreen.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/game.dart';
import 'package:hackathon/repo.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'vipGame.dart';

class VipGamesScreen extends StatelessWidget {
  final String name;
  const VipGamesScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Game> all = [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(background),
        title: Text(
          "Welcome " + name,
          style: const TextStyle(
            fontFamily: font,
            color: Color(accent),
            fontSize: 24,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Repository.games_ref.orderBy("game_no").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Fluttertoast.showToast(
              msg: "There was some error",
              toastLength: Toast.LENGTH_LONG,
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {}
          if (snapshot.hasData) {
            all = snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Game(
                  name: data['name'],
                  uuid: data['uuid'],
                  description: data['description'],
                  gameNo: int.tryParse(data['game_no'].toString()),
                  status: data['status'] ?? 0);
            }).toList();
          }
          int x = all.indexWhere((element) => element.status == 1);
          Game? running;
          if (x != -1) running = all[x];
          all = all.where((game) => game.status == 2).toList();
          return ListView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(accent),
                      width: 2.0,
                    ),
                    bottom: BorderSide(
                      color: Color(accent),
                      width: 2.0,
                    ),
                  ),
                ),
                height: SizeConfig.safeBlockVertical * 8,
                width: SizeConfig.screenWidth * 0.9,
                alignment: Alignment.center,
                child: const Text(
                  "Current Games:",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(accent),
                    fontFamily: font,
                  ),
                ),
              ),
              x != -1
                  ? GestureDetector(
                      onTap: () {
                        // print(all[index].name);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VIPGame(g: running),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(accent),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.blockSizeVertical * 20,
                              child: Center(
                                child: Text(
                                  running?.name ?? " ",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Game Of Squids',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.blockSizeVertical * 20,
                      alignment: Alignment.center,
                      child: const Text(
                        "No Games Running",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(accent),
                          fontFamily: font,
                        ),
                      ),
                    ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(accent),
                      width: 2.0,
                    ),
                    bottom: BorderSide(
                      color: Color(accent),
                      width: 2.0,
                    ),
                  ),
                ),
                height: SizeConfig.safeBlockVertical * 8,
                width: SizeConfig.screenWidth * 0.9,
                alignment: Alignment.center,
                child: const Text(
                  "Previous Games:",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(accent),
                    fontFamily: font,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 60,
                child: all.isEmpty
                    ? const Center(
                        child: Text(
                          "NO PREVIOUS GAMES",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(accent),
                            fontFamily: font,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: all.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(all[index].name);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VIPGame(g: all[index]),
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         ParticularGameScreen(g: all[index]),
                              //   ),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(accent),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: SizeConfig.screenWidth,
                                    height: SizeConfig.blockSizeVertical * 20,
                                    child: Center(
                                      child: Text(
                                        all[index].name ?? " ",
                                        style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Game Of Squids',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
            ],
          );
        },
      ),
    );
  }
}
