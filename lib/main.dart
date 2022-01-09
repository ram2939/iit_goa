import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hackathon/Screens/vipLogin.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackathon/repo.dart';

import 'Screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        const MyApp(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squid Game',
      theme: ThemeData(
        primaryColor: const Color(background),
        accentColor: const Color(accent),
        scaffoldBackgroundColor: const Color(background),
      ),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splashIconSize: 700,
        duration: 6000,
        backgroundColor: Colors.black54,
        splash: "assets/images/squid3.gif",
        nextScreen: const LoginPage(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  Future<Future> showFrontmanDialog(BuildContext ctx) async {
    return showDialog(
      context: ctx,
      builder: (c) {
        TextEditingController controller = TextEditingController();
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 2),
            color: const Color(background),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "FRONTMAN",
                    style: TextStyle(color: Colors.white, fontFamily: font),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 50,
                  child: TextField(
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: controller,
                    decoration: kTextFieldDecoration,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(c);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(accent),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        int alive = await Repository.getAlive();
                        bool authFrontman =
                            await Repository.checkFrontman(controller.text);
                        // if (controller.text == "squid123") {
                        if (authFrontman) {
                          while (Navigator.canPop(ctx)) {
                            Navigator.pop(ctx);
                          }
                          Navigator.of(ctx).pop();
                          Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (context) => HomePage(alive: alive),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      color: const Color(background),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/Logo.png'),
          // SvgPicture.asset(
          //   "./assets/images/squid.svg",
          //   height: SizeConfig.safeBlockVertical * 15,
          // ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  await showFrontmanDialog(context);
                },
                child: SvgPicture.asset(
                  "./assets/images/left.svg",
                  height: SizeConfig.safeBlockVertical * 50,
                ),
              ),
              GestureDetector(
                onTap: () {
                  while (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VIPLogin(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  "./assets/images/right.svg",
                  height: SizeConfig.safeBlockVertical * 50,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              height: 50,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 25,
                  color: Color(accent),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Game Of Squids',
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FadeAnimatedText("CHOOSE"),
                    FadeAnimatedText("YOUR"),
                    FadeAnimatedText("SIDE"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       elevation: 0.0,
    //       backgroundColor: const Color(background),
    //       centerTitle: true,
    //       title: Container(
    //         padding: const EdgeInsets.symmetric(
    //           vertical: 10,
    //         ),
    //         child: SvgPicture.asset(
    //           "./assets/images/squid.svg",
    //           height: SizeConfig.safeBlockVertical * 15,
    //         ),
    //       ),
    //       // title: const Text(
    //       //   "SQUID GAME",
    //       //   style: TextStyle(
    //       //     fontSize: 38,
    //       //     color: Color(accent),
    //       //     fontFamily: 'Game Of Squids',
    //       //   ),
    //       // ),
    //     ),
    //     body: ,
    //   ),
    // );
  }
}
