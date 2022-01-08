import 'package:flutter/material.dart';
import 'package:hackathon/Utility/constants.dart';
import 'package:hackathon/Utility/sizeConfig.dart';
import 'package:hackathon/models/player.dart';

import '../repo.dart';

class AddPlayer extends StatefulWidget {
  Player? w;
  AddPlayer({Key? key, this.w}) : super(key: key);

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  final TextEditingController name = TextEditingController();

  final TextEditingController dob = TextEditingController();

  final TextEditingController occupation = TextEditingController();

  final TextEditingController address = TextEditingController();

  final TextEditingController debt = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.w != null) {
      name.text = widget.w!.name ?? "";
      dob.text = widget.w!.dob ?? "";
      occupation.text = widget.w!.occupation ?? "";
      address.text = widget.w!.address ?? "";
      debt.text = widget.w!.debt.toString();
    }
  }

  InputDecoration text(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white,
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(accent), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(accent), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Color(accent),
          ),
          backgroundColor: const Color(background),
          title: Text(
            // ignore: prefer_adjacent_string_concatenation
            widget.w == null ? "Add" : "Edit" + " Worker",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Color(accent),
              fontFamily: font,
              fontSize: 24,
            ),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: TextField(
                controller: name,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: text("Enter name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: TextField(
                controller: dob,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: text("Enter DOB"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: TextField(
                controller: occupation,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: text("Enter occupation"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: TextField(
                controller: address,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: text("Enter address"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: TextField(
                controller: address,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: text("Enter debt"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              child: Container(
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
                height: SizeConfig.safeBlockVertical * 8,
                width: SizeConfig.safeBlockHorizontal * 30,
                alignment: Alignment.center,
                child: Text(
                  widget.w == null ? "Add" : "Save",
                  style: const TextStyle(
                    color: Color(background),
                    fontSize: 20,
                  ),
                ),
              ),
              onPressed: () async {
                await Repository.addPlayer(
                    name.text,
                    dob.text,
                    address.text,
                    occupation.text,
                    double.tryParse(debt.text) ?? 0,
                    widget.w == null,
                    oldName: widget.w!.name ?? "");
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
