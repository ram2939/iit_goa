import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackathon/Screens/vipLogin.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        MyApp(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(background),
        accentColor: const Color(accent),
        scaffoldBackgroundColor: const Color(background),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
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
                          color: Color(0xFFE256D3),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // if (controller.text == "squid123") {
                        if (true) {
                          while (Navigator.canPop(ctx)) {
                            Navigator.pop(ctx);
                          }
                          Navigator.of(ctx).pop();
                          Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(background),
          centerTitle: true,
          title: const Text(
            "SQUID GAME",
            style: TextStyle(
              fontSize: 38,
              color: Color(accent),
              fontFamily: 'Game Of Squids',
            ),
          ),
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 20),
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
                    color: Color(0xFFE256D3),
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
      ),
    );
  }
}
