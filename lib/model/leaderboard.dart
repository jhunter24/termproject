class Leaderboard {
  static const String COLLECTION_NAME = "leaderboard";
  static const String CREATED_BY = "createdBy";
  static const String USER = "user";
  static const String SCORE = "score";
  int score;
  String createdBy;
  String user;
  String docID;

  Leaderboard({this.score, this.createdBy, this.user, this.docID});

  Map<String, dynamic> serialize({int score, String createdBy, String user}) {
    return {"score": score, "createdBy": createdBy, "user": user};
  }

  static Leaderboard deserialize(Map<String, dynamic> data, String docId) {
    return Leaderboard(
      score: data[SCORE],
      createdBy: data[CREATED_BY],
      user: data[USER],
      docID: docId,
    );
  }
}
