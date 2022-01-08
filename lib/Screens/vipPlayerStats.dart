import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../repo.dart';

class VipPlayerStats extends StatelessWidget {
  final List<dynamic>? ids;
  final String? type;
  const VipPlayerStats({Key? key, this.ids, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(accent),
        ),
        backgroundColor: const Color(background),
        title: Text(
          type ?? "",
          style: const TextStyle(
            fontFamily: font,
            color: Color(accent),
            fontSize: 24,
          ),
        ),
      ),
      body: SizedBox(
        height: SizeConfig.screenHeight * 0.9,
        child: FutureBuilder(
          future: Repository.getPlayers(ids ?? []),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              final data = snapshot.data as List<Player>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      final birthDate = DateTime(
                          int.parse(data[idx].dob!.substring(6)),
                          int.parse(data[idx].dob!.substring(3, 5)),
                          int.parse(data[idx].dob!.substring(0, 2)));
                      final date = DateTime.now();
                      int age =
                          (date.difference(birthDate).inDays ~/ 365).toInt();
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
                                    Text(
                                      data[idx].name ?? "",
                                      style: const TextStyle(
                                        fontFamily: font,
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Age " + age.toString(),
                                      style: const TextStyle(
                                        fontFamily: font,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Debt " + data[idx].debt.toString(),
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
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(accent),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      height: SizeConfig.safeBlockVertical * 10,
                      child: Text(
                        data[idx].name ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: font,
                        ),
                      ),
                    ),
                  );
                },
              );
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
