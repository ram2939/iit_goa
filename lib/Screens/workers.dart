import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/worker.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../repo.dart';

class Workers extends StatefulWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  _WorkersState createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  List<Worker> all = [
    Worker(name: "A", dob: "B", address: "c", job: "D", occupation: "E")
  ];
  List<Worker> searchResults = [];
  bool search = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    all = Repository.workers;
    super.initState();
  }

  Widget front(GlobalKey<SimpleFoldingCellState> key, Worker i) {
    List<String> jobs = ["Manager", "Guard", "Utility", "None"];
    int index = all.indexOf(i);
    return Container(
      color: const Color(accent),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Text(
            i.name ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontFamily: font,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: jobs.map((e) {
              if (e == i.job) {
                return Chip(
                    backgroundColor: Colors.grey,
                    label: Text(e,
                        style: const TextStyle(
                          color: Colors.black87,
                        )));
              } else {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        all[index].job = e;
                      });
                    },
                    child: Chip(label: Text(e)));
              }
            }).toList(),
          ),
          IconButton(
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

  Widget _buildInnerWidget(GlobalKey<SimpleFoldingCellState> key, Worker i) {
    return Container(
      color: const Color(accent),
      padding: const EdgeInsets.only(
        top: 10,
        left: 12,
        right: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              i.name ?? " ",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: font,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            i.job ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: font,
            ),
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
      body: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 2),
          height: SizeConfig.safeBlockVertical * 10,
          child: TextField(controller: _controller),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: Repository.workers_ref.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                all = snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Worker(
                      name: data['name'],
                      address: data['address'],
                      dob: data['dob'],
                      occupation: data['occupation'],
                      job: "None");
                }).toList();

                return ListView.builder(
                  itemCount: (search ? searchResults.length : all.length),
                  itemBuilder: (BuildContext context, int index) {
                    Worker i = search ? searchResults[index] : all[index];
                    final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

                    return SimpleFoldingCell.create(
                      key: _foldingCellKey,
                      frontWidget: front(_foldingCellKey, i),
                      innerWidget: _buildInnerWidget(_foldingCellKey, i),
                      cellSize: Size(MediaQuery.of(context).size.width, 140),
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
