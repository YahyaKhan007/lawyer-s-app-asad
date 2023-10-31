class RatingModel {
  String? message;
  String? ratingId;
  double? rating;
  String? fromuser;

  RatingModel(
      {required this.message,
      required this.ratingId,
      required this.rating,
      required this.fromuser});

  RatingModel.fromMap(Map<String, dynamic> map) {
    message = map['messgae'];
    ratingId = map['ratingId'];
    rating = map['rating'];
    fromuser = map['fromuser'];
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "ratingId": ratingId,
      'rating': rating,
      'fromuser': fromuser,
    };
  }
}
