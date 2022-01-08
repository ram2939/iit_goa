import 'package:flutter/material.dart';
import 'package:hackathon/Screens/particularGameScreen.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/game.dart';
import 'package:hackathon/repo.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'vipGame.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Game> all = [];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(background),
          title: const Text(
            "GAMES",
            style: TextStyle(
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
                    gameNo: int.tryParse(data['game_no'].toString()));
              }).toList();
            }

            return ListView.builder(
                itemCount: all.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print(all[index].name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ParticularGameScreen(g: all[index]),
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
                });
          },
        ));
  }
}
