import 'package:cloud_firestore/cloud_firestore.dart';

class Worker {
  final String? name;
  final String? dob;
  final String? occupation;
  final String? address;
  String? job;

  Worker({this.name, this.dob, this.occupation, this.address, this.job});
  static fromDocument(DocumentSnapshot doc) {
    return Worker(
      job: doc['job'] ?? "None",
      name: doc['name'],
      dob: doc['dob'],
      occupation: doc['occupation'],
      address: doc['address'],
    );
  }

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
        name: json['name'],
        dob: json['dob'],
        address: json['address'],
        occupation: json['occupation'],
        job: "None");
  }
}
