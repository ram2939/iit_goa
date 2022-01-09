import 'package:flutter/material.dart';
import 'package:hackathon/Screens/addWorker.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/worker.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../repo.dart';

class Workers extends StatefulWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  _WorkersState createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  List<Worker> all = [];
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
                    Repository.updateWorker(i.name ?? "", e);
                    setState(() {
                      all[index].job = e;
                    });
                  },
                  child: Chip(
                    label: Text(e),
                  ),
                );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddWorker(w: i)));
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
              mainAxisAlignment: MainAxisAlignment.start,
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddWorker(),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color(background),
        title: const Text(
          'WORKERS',
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
              stream: Repository.workersRef.snapshots(),
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
                    return Worker(
                        name: data['name'],
                        address: data['address'],
                        dob: data['dob'],
                        occupation: data['occupation'],
                        job: data['job'] ?? "None");
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
                    Worker i = all[index];
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
    );
  }
}
