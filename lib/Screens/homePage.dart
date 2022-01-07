import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';

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
          title: const Text(
            "Welcome Frontman",
            style: TextStyle(
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
                  SizedBox(
                    child: AnimatedTextKit(
                      pause: const Duration(milliseconds: 1),
                      repeatForever: true,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Prize: \$ ${f.format((total - alive) * 10000000)}',
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
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
