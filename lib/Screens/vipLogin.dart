import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';

import 'homePage.dart';

class VIPLogin extends StatelessWidget {
  const VIPLogin({Key? key}) : super(key: key);

  Future<Future> showVIPDialog(BuildContext ctx, String name) async {
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    name,
                    style:
                        const TextStyle(color: Colors.white, fontFamily: font),
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                await showVIPDialog(context, "Bear");
              },
              child: Container(
                color: const Color(background),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/1.jpg',
                  scale: 1.2,
                ),
                // const AssetImage('assets/images/1.jpg'),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await showVIPDialog(context, "Buffalo");
              },
              child: Container(
                color: const Color(background),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/2.jpg',
                  scale: 1.2,
                ),
                // const AssetImage('assets/images/1.jpg'),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await showVIPDialog(context, "Eagle");
              },
              child: Container(
                color: const Color(background),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/3.jpg',
                  scale: 1.2,
                ),
                // const AssetImage('assets/images/1.jpg'),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await showVIPDialog(context, "Lion");
              },
              child: Container(
                color: const Color(background),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/4.jpg',
                  scale: 1.2,
                ),
                // const AssetImage('assets/images/1.jpg'),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await showVIPDialog(context, "Deer");
              },
              child: Container(
                color: const Color(background),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/5.jpg',
                  scale: 1.2,
                ),
                // const AssetImage('assets/images/1.jpg'),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await showVIPDialog(context, "Tiger");
              },
              child: Container(
                color: const Color(background),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/6.jpg',
                  scale: 1.2,
                ),
                // const AssetImage('assets/images/1.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
