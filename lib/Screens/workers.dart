import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/worker.dart';
import 'package:folding_cell/folding_cell.dart';

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
    return Container(
      color: Color(accent),
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              i.name ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: font,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
              right: 10,
              bottom: 5,
              child: IconButton(
                  onPressed: () => key.currentState?.toggleFold(),
                  icon: Icon(
                    Icons.double_arrow,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }

  Widget _buildInnerWidget(GlobalKey<SimpleFoldingCellState> key, Worker i) {
    return Container(
      color: Color(accent),
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              i.name ?? " ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              i.address ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
          ),
          Positioned(
              right: 10,
              bottom: 5,
              child: IconButton(
                  onPressed: () => key.currentState?.toggleFold(),
                  icon: Icon(
                    Icons.double_arrow,
                    color: Colors.white,
                  ))),
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
          // height: SizeConfig.safeBlockVertical * 80,
          child: ListView.builder(
            itemCount: (search ? searchResults.length : all.length),
            itemBuilder: (BuildContext context, int index) {
              Worker i = search ? searchResults[index] : all[index];
              final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

              return SimpleFoldingCell.create(
                key: _foldingCellKey,
                frontWidget: front(_foldingCellKey, i),
                innerWidget: _buildInnerWidget(_foldingCellKey, i),
                cellSize: Size(MediaQuery.of(context).size.width, 140),
                padding: EdgeInsets.all(15),
                animationDuration: Duration(milliseconds: 300),
                borderRadius: 10,
                onOpen: () => print('cell opened'),
                onClose: () => print('cell closed'),
              );
            },
          ),
        )
      ]),
    ));
  }
}
