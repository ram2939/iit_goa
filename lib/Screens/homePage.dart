import 'package:flutter/material.dart';
import 'package:hackathon/Screens/workers.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';

import '../repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int total = 100;
  int alive = 30;
  var f = NumberFormat("###,###", "en_US");
  @override
  void initState() {
    Repository.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: IconButton(
            icon: const Icon(Icons.games),
            onPressed: () {},
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(accent),
          centerTitle: true,
          title: const Text(
            "Welcome Frontman",
            style: TextStyle(
              color: Color(background),
              fontFamily: font,
            ),
          ),
        ),
        body: ListView(children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 2),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: AnimatedTextKit(
                      pause: const Duration(milliseconds: 1),
                      repeatForever: true,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Stake: \$${f.format((total - alive) * 10000000)}',
                          textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Game Of Squids',
                          ),
                          colors: const [Colors.white, Color(accent)],
                        ),
                      ],
                      isRepeatingAnimation: true,
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
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
                          FadeAnimatedText("Total: $total"),
                          FadeAnimatedText("Alive: $alive"),
                          FadeAnimatedText("Dead: ${total - alive}"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    thickness: 2.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Workers(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.contain,
                          opacity: 0.8,
                          image: ExactAssetImage('assets/images/soldier.png'),
                        ),
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
                              'SOLDIERS',
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
                    height: 30,
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.contain,
                          opacity: 0.8,
                          image: ExactAssetImage('assets/images/player.png'),
                        ),
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
                              'PLAYERS',
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
          ),
        ]),
      ),
    );
  }
}
