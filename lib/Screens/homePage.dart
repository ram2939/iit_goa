import 'package:flutter/material.dart';
import 'package:hackathon/Screens/playersScreen.dart';
import 'package:hackathon/Screens/workers.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';
import '../repo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'GamesPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  int alive;
  HomePage({Key? key, required this.alive}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int total = 100;
  // int dead = 0;
  var f = NumberFormat("###,###", "en_US");
  bool import = false;
  @override
  void initState() {
    if (widget.alive == 0) {
      import = true;
      // Repository.getData();
      total = 0;
    }
    // dead = total - widget.alive;
    // Repository.generateExcel();
    super.initState();
  }

  void showBlockingDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return const Center(
              child: SpinKitWave(
            color: Color(accent),
            size: 50.0,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        drawer: SizedBox(
          width: SizeConfig.screenWidth * 0.5,
          child: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: Color(background),
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      "./assets/images/left.svg",
                      height: SizeConfig.safeBlockVertical * 20,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.of(context).pop();
                    double wallet = await Repository.getFrontmanBalance();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: const Color(background),
                            elevation: 2,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              alignment: Alignment.center,
                              height: SizeConfig.safeBlockVertical * 30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Current Balance",
                                    style: TextStyle(
                                      fontFamily: font,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "\$ " + wallet.toString(),
                                    style: const TextStyle(
                                      fontFamily: font,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  leading: const Icon(
                    Icons.mail_outline_outlined,
                    color: Color(background),
                  ),
                  title: const Text(
                    "Wallet",
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: 24,
                      color: Color(background),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.mail_outline_outlined,
                    color: Color(background),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    showBlockingDialog(context);
                    await Repository.generateExcel();
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: "Report generated successfully",
                    );
                  },
                  title: const Text(
                    "Report",
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: 22,
                      color: Color(background),
                    ),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.logout,
                    color: Color(background),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: 24,
                      color: Color(background),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GamesScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.games,
          ),
        ),
        appBar: AppBar(
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.logout),
          //     onPressed: () {
          //       Navigator.pushReplacement(context,
          //           MaterialPageRoute(builder: (context) => const LoginPage()));
          //     },
          //   )
          // ],
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
        body: StreamBuilder<QuerySnapshot>(
          stream: Repository.playersRef
              .where("isAlive", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Fluttertoast.showToast(
                msg: "There was some error",
                toastLength: Toast.LENGTH_LONG,
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {}
            if (snapshot.hasData) {
              int alive = snapshot.data!.docs.length;
              int dead = total - alive;
              return ListView(children: [
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
                                'Stake: \$${import ? 0 : f.format((dead) * 10000000)}',
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
                              color: Color(accent),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Game Of Squids',
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                FadeAnimatedText("Total: $total"),
                                FadeAnimatedText("Alive: ${alive}"),
                                FadeAnimatedText("Dead: $dead"),
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
                          height: 15,
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
                                image: ExactAssetImage(
                                    'assets/images/soldier.png'),
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
                                    'WORKERS',
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
                                builder: (context) => const PlayerScreen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.contain,
                                opacity: 0.8,
                                image:
                                    ExactAssetImage('assets/images/player.png'),
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
                        const SizedBox(
                          height: 20,
                        ),
                        import
                            ? GestureDetector(
                                onTap: () async {
                                  showBlockingDialog(context);
                                  await Repository.getData();
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                      msg: "Data Successfully imported");
                                  setState(() {
                                    total = 100;
                                    import = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Import Data",
                                    style: TextStyle(
                                      fontFamily: font,
                                      fontSize: 20,
                                    ),
                                  ),
                                  height: SizeConfig.safeBlockVertical * 10,
                                  width: SizeConfig.safeBlockHorizontal * 50,
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
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ]);
            } else {
              return const Center(
                child: SpinKitWave(
                  color: Color(accent),
                  size: 50.0,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
