import 'package:flutter/material.dart';
import 'package:hackathon/Screens/vipGamePage.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VIPLogin extends StatefulWidget {
  const VIPLogin({Key? key}) : super(key: key);

  @override
  State<VIPLogin> createState() => _VIPLoginState();
}

class _VIPLoginState extends State<VIPLogin> {
  final CollectionReference _passwords_ref =
      FirebaseFirestore.instance.collection("vipPassword");

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
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password.',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE256D3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE256D3), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
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
                      onPressed: () async {
                        final snapshots = await _passwords_ref.get();
                        // snapshots.forEach((element) {});
                        for (var i in snapshots.docs) {
                          if (name == i['name'] &&
                              controller.text == i['password']) {
                            Fluttertoast.showToast(
                              msg: "Welcome VIP $name",
                              toastLength: Toast.LENGTH_LONG,
                              fontSize: 16.0,
                            );
                            while (Navigator.canPop(ctx)) {
                              Navigator.pop(ctx);
                            }
                            Navigator.of(ctx).pop();
                            Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (context) => VipGamesScreen(
                                  name: name,
                                ),
                              ),
                            );
                          }
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(background),
          title: const Text(
            "VIP",
            style: TextStyle(
              fontSize: 36,
              color: Color(accent),
              fontFamily: 'Game Of Squids',
            ),
          ),
        ),
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
