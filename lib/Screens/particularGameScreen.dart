import 'dart:core';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/game.dart';
import 'package:hackathon/models/player.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../repo.dart';

class ParticularGameScreen extends StatefulWidget {
  Game? g;
  ParticularGameScreen({Key? key, required this.g}) : super(key: key);
  @override
  _ParticularGameScreenState createState() => _ParticularGameScreenState();
}

class _ParticularGameScreenState extends State<ParticularGameScreen> {
  List<Player> all = [];
  bool search = false;
  int alive = 0;
  int totalBet = 0;
  final TextEditingController _controller = TextEditingController();
  int status = 0;
  // print(g.toString())

  // @override
  // void initState() {
  //   all = Repository.players;
  //   super.initState();
  // }

  Widget front(GlobalKey<SimpleFoldingCellState> key, Player i) {
    int index = all.indexOf(i);
    return Container(
      color: const Color(accent),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                i.name ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: font,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Transform.scale(
                scale: 1.2,
                child: Switch(
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    value: status == 1 ? (i.isAlive ?? true) : true,
                    onChanged: status == 1
                        ? (value) async {
                            setState(() {
                              i.isAlive = value;
                            });
                            Repository.updatePlayer(i.name ?? " ", value);
                          }
                        : null),
              ),
            ],
          ),
          Text(
            "Bet: \$" + i.currentBet.toString(),
            style: const TextStyle(
              fontFamily: font,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          IconButton(
            alignment: Alignment.bottomCenter,
            onPressed: () => key.currentState?.toggleFold(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerWidget(GlobalKey<SimpleFoldingCellState> key, Player i) {
    return Container(
      color: const Color(accent),
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  i.name ?? " ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: font,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                Chip(
                  label: Text(
                    "\$ " + i.currentBet.toStringAsFixed(1),
                    style: const TextStyle(fontFamily: font),
                  ),
                  backgroundColor: Colors.yellow,
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              "Debt: \$ " + i.debt!.toStringAsFixed(1),
              style: const TextStyle(fontFamily: font),
            ),
            backgroundColor: Colors.red[200],
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              i.address ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.safeBlockHorizontal * 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "DOB: ${i.dob}\nOccupation: ${i.occupation}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            // right: 10,
            // bottom: 5,
            child: IconButton(
              onPressed: () => key.currentState?.toggleFold(),
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(accent),
        ),
        backgroundColor: const Color(background),
        title: Expanded(
          child: Text(
            widget.g?.name ?? "abc",
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontFamily: font,
              color: Color(accent),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Repository.playersRef.snapshots(),
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
                return Player(
                    name: data['name'],
                    address: data['address'],
                    dob: data['dob'],
                    occupation: data['occupation'],
                    isAlive: data['isAlive'] ?? true,
                    debt: data['debt'],
                    currentBet: data['currentBet'] ?? 0,
                    nextGame: data['nextGame'] ?? 1);
              }).toList();

              all =
                  (all.where((element) => (element.isAlive == true))).toList();

              alive = all.length;
              totalBet = 0;
              for (var i in all) {
                totalBet += i.currentBet;
              }
              if (search) {
                all = (all.where((element) =>
                    ((element.name?.toLowerCase()) ?? "")
                        .contains(_controller.text))).toList();
              }
              all.sort((a, b) => (b.currentBet - a.currentBet));
              print(all.length);
              return Column(children: [
                SizedBox(
                  height: 50,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color(0xFFE256D3),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Game Of Squids',
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        FadeAnimatedText("Alive: $alive"),
                        FadeAnimatedText("Total Bet: $totalBet")
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 3,
                      vertical: SizeConfig.safeBlockVertical * 1.5),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 2),
                  height: SizeConfig.safeBlockVertical * 8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: SizeConfig.safeBlockHorizontal * 70,
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              // borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                          ),
                          controller: _controller,
                          style: const TextStyle(
                              // fontFamily: font,
                              color: Color(background),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          onChanged: (value) {
                            if (value == "") {
                              setState(() {
                                search = false;
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            search = true;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: all.length,
                    itemBuilder: (BuildContext context, int index) {
                      Player i = all[index];
                      final _foldingCellKey =
                          GlobalKey<SimpleFoldingCellState>();

                      return SimpleFoldingCell.create(
                        key: _foldingCellKey,
                        frontWidget: front(_foldingCellKey, i),
                        innerWidget: _buildInnerWidget(_foldingCellKey, i),
                        cellSize: Size(SizeConfig.screenWidth,
                            SizeConfig.safeBlockVertical * 20),
                        padding: const EdgeInsets.all(15),
                        animationDuration: const Duration(milliseconds: 300),
                        borderRadius: 10,
                        onOpen: () => print('cell opened'),
                        onClose: () => print('cell closed'),
                      );
                    },
                  ),
                ),
                TextButton(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    height: SizeConfig.safeBlockVertical * 8,
                    width: SizeConfig.screenWidth,
                    child: Center(
                      child: Text(
                          status == 0
                              ? "Start"
                              : (status == 1 ? "End" : "Completed"),
                          style: const TextStyle(
                            color: Color(background),
                            fontFamily: font,
                            fontSize: 25,
                          )),
                    ),
                    color: status == 0
                        ? Colors.green
                        : (status == 1 ? Colors.red : Color(accent)),
                  ),
                  onPressed: () async {
                    if (status == 0) {
                      await Repository.updateGameEntered(widget.g?.gameNo ?? 0);
                      setState(() {
                        status = 1;
                      });
                    } else if (status == 1) {
                      await Repository.updateGameSurvived(
                          widget.g?.gameNo ?? 0);
                      setState(() {
                        status = 2;
                      });
                    }
                  },
                ),
              ]);
            } else {
              return Container();
            }
          }),
    ));
  }
}
