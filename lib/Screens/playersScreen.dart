import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/player.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../repo.dart';
import 'addPlayer.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<Player> all = [];
  bool search = false;
  final TextEditingController _controller = TextEditingController();

  // @override
  // void initState() {
  //   all = Repository.players;
  //   super.initState();
  // }

  Widget front(GlobalKey<SimpleFoldingCellState> key, Player i) {
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
                    inactiveTrackColor: const Color.fromRGBO(245, 118, 49, 1),
                    value: i.isAlive ?? true,
                    onChanged: (value) async {
                      setState(() {
                        i.isAlive = value;
                      });
                      Repository.updatePlayer(i.name ?? " ", value);
                    }),
              ),
            ],
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
    final birthDate = DateTime(int.parse(i.dob!.substring(6)),
        int.parse(i.dob!.substring(3, 5)), int.parse(i.dob!.substring(0, 2)));
    final date = DateTime.now();
    int age = date.difference(birthDate).inDays ~/ 365;
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
                Container(
                  width: SizeConfig.safeBlockHorizontal * 50,
                  child: Text(
                    i.name ?? " ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: font,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                CircleAvatar(
                  backgroundColor:
                      i.isAlive ?? true ? Colors.green : Colors.red,
                  radius: 5,
                ),
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPlayer(w: i)));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    await Repository.deleteWorker(i.name ?? "");
                  },
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              "\$ " + i.debt!.toStringAsFixed(1),
              style: const TextStyle(fontFamily: font),
            ),
            backgroundColor: Colors.yellow,
          ),
          SizedBox(
            width: SizeConfig.safeBlockHorizontal * 90,
            child: Text(
              "${age}\n${i.occupation}",
              style: const TextStyle(
                fontFamily: font,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            height: SizeConfig.safeBlockVertical * 4,
            child: Text(
              i.address ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPlayer()));
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color(background),
        title: const Text(
          'PLAYERS',
          style: TextStyle(
            fontFamily: font,
            color: Color(accent),
          ),
        ),
      ),
      body: Column(children: [
        Container(
          // color: Colors.white,
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
          child: StreamBuilder<QuerySnapshot>(
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
                        gamesPlayed: data['gamesPlayed'] ?? 0,
                        nextGame: data['nextGame'] ?? 1);
                  }).toList();
                  if (search) {
                    all = (all.where((element) =>
                        ((element.name?.toLowerCase()) ?? "")
                            .contains(_controller.text))).toList();
                  }
                }
                return ListView.builder(
                  itemCount: all.length,
                  itemBuilder: (BuildContext context, int index) {
                    Player i = all[index];
                    final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

                    return SimpleFoldingCell.create(
                      key: _foldingCellKey,
                      frontWidget: front(_foldingCellKey, i),
                      innerWidget: _buildInnerWidget(_foldingCellKey, i),
                      cellSize: Size(SizeConfig.screenWidth,
                          SizeConfig.safeBlockVertical * 16),
                      padding: const EdgeInsets.all(15),
                      animationDuration: const Duration(milliseconds: 300),
                      borderRadius: 10,
                      onOpen: () => print('cell opened'),
                      onClose: () => print('cell closed'),
                    );
                  },
                );
              }),
        )
      ]),
    ));
  }
}
