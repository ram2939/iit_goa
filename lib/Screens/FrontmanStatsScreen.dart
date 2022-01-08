import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/game.dart';

class FrontmanStatsPage extends StatelessWidget {
  final Game g;
  const FrontmanStatsPage({Key? key, required this.g}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? a = g.enteredCount;
    int? b = g.survivedCount;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(accent),
        ),
        backgroundColor: const Color(background),
        title: const Text(
          'GAME STATS',
          style: TextStyle(
            color: Color(accent),
            fontFamily: font,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight * 0.15,
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
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.5,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 80,
                sectionsSpace: 5,
                sections: [
                  PieChartSectionData(
                    radius: 80,
                    showTitle: false,
                    color: const Color(accent),
                    value: (g.survivedCount)!.toDouble() /
                        ((g.enteredCount)!.toDouble()) *
                        360,
                  ),
                  PieChartSectionData(
                    radius: 80,
                    showTitle: false,
                    color: Colors.white,
                    value: (1 -
                            (g.survivedCount)!.toDouble() /
                                (g.enteredCount)!.toDouble()) *
                        360,
                  )
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
              swapAnimationCurve: Curves.linear,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  color: const Color(accent),
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Players Survived",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(accent),
                    fontFamily: font,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  color: Colors.white,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Players Died",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(accent),
                    fontFamily: font,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
