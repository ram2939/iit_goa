class Game {
  final String? uuid;
  final int? gameNo;
  final String? name;
  final String? description;
  final int? status;
  final int? enteredCount;
  final int? survivedCount;
  List<dynamic>? survived = [];
  List<dynamic>? entered = [];

  Game(
      {this.entered,
      this.survived,
      this.description,
      this.gameNo,
      this.name,
      this.status,
      this.uuid,
      this.enteredCount,
      this.survivedCount});
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      survivedCount: 0,
      enteredCount: 0,
      uuid: json['uuid'],
      name: json['name'],
      gameNo: json['game_no'],
      description: json['description'],
      status: 0,
      survived: [],
      entered: [],
    );
  }
  // static fromDocument(DocumentSnapshot json) {
  //   return Game(
  //     uuid: json['uuid'],
  //     name: json['name'],
  //     gameNo: json['game_no'],
  //     description: json['description'],
  //     status: 0,
  //     survived: [],
  //     entered: [],
  //   );
  // }
}
