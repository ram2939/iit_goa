import 'package:flutter/material.dart';
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
          title: SizedBox(
            width: SizeConfig.screenWidth * 0.8,
            child: Text(
              g.name ?? "Game Stats",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                color: Color(accent),
                fontFamily: font,
                fontSize: 24,
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.18,
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
                    'Mortality Rate : ' + (b / a * 100).toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: font,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: SizeConfig.screenHeight * 0.6,
            ),
          ],
        ),
      ),
    );
  }
}
