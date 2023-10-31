// ignore_for_file: file_names

class AdminModel {
  List? pending;
  List? accepted;
  List? rejected;

  AdminModel(
      {required this.pending, required this.accepted, required this.rejected});

// ~ from Json to dart
  AdminModel.fromMap(Map<String, dynamic> map) {
    pending = map["pending"];
    accepted = map["accepted"];
    rejected = map["rejected"];
  }

  //  !  will be Used to change your AdminModel  object into Map/Json
  Map<String, dynamic> toMap() {
    return {
      "pending": pending,
      "accepted": accepted,
      "rejected": rejected,
    };
  }
}
