class Leaderboard {
  static const String COLLECTION_NAME = "leaderboard";

  static const String USER = "user";
  static const String SCORE = "score";
  int score;
  String createdBy;
  String user;
  String docID;

  Leaderboard({this.score, this.createdBy, this.user, this.docID});

  static Map<String, dynamic> serialize(
      {int score, String createdBy, String user}) {
    return {SCORE: score, USER: user};
  }

  static Leaderboard deserialize(Map<String, dynamic> data, String docId) {
    return Leaderboard(
      score: data[SCORE],
      user: data[USER],
      docID: docId,
    );
  }
}
