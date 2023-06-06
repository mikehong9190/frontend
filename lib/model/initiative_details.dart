class InitiativeDetails {
    String message;
    Data data;

    InitiativeDetails({
        required this.message,
        required this.data,
    });

    factory InitiativeDetails.fromJson(Map<String, dynamic> json) => InitiativeDetails(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String id;
    int target;
    String initiativeTypeId;
    int numberOfStudents;
    String grade;
    String name;
    List<String> images;

    Data({
        required this.id,
        required this.target,
        required this.initiativeTypeId,
        required this.numberOfStudents,
        required this.grade,
        required this.name,
        required this.images,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        target: json["target"],
        initiativeTypeId: json["initiativeTypeId"],
        numberOfStudents: json["numberOfStudents"],
        grade: json["grade"],
        name: json["name"],
        images: List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "target": target,
        "initiativeTypeId": initiativeTypeId,
        "numberOfStudents": numberOfStudents,
        "grade": grade,
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}
