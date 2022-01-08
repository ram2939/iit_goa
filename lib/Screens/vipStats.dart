import 'package:flutter/material.dart';
import 'package:hackathon/Screens/vipPlayerStats.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/game.dart';

class VipGameStats extends StatelessWidget {
  final Game g;
  const VipGameStats({Key? key, required this.g}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? a = g.enteredCount;
    int? b = g.survivedCount;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Color(accent),
          ),
          backgroundColor: const Color(background),
          title: const Text(
            "Game Stats",
            style: TextStyle(
              color: Color(accent),
              fontFamily: font,
              fontSize: 24,
            ),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: Text(
                g.name ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 30,
                  color: Color(accent),
                  fontFamily: 'Game Of Squids',
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: SizeConfig.screenHeight * 0.2,
              child: Column(
                children: [
                  Text(
                    'Players Entered : ' + g.enteredCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: font,
                    ),
                  ),
                  Text(
                    'Players Survived : ' + g.survivedCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: font,
                    ),
                  ),
                  Text(
                    'Players Died : ' + (a! - b!).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: font,
                    ),
                  ),
                  Text(
                    'Mortality Rate : ' +
                        (100 - (b / a * 100)).toStringAsFixed(1) +
                        '%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: font,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VipPlayerStats(ids: g.entered ?? [], type: "Entered"),
                  ),
                );
              },
              child: Container(
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
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.blockSizeVertical * 20,
                      child: const Text(
                        'Entered',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Game Of Squids',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VipPlayerStats(ids: g.survived ?? [], type: "Survived"),
                  ),
                );
              },
              child: Container(
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
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.blockSizeVertical * 20,
                      child: const Text(
                        'Survived',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Game Of Squids',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
