class SchoolDetailResponse {
    String message;
    Data data;

    SchoolDetailResponse({
        required this.message,
        required this.data,
    });

    factory SchoolDetailResponse.fromJson(Map<String, dynamic> json) => SchoolDetailResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    School school;
    List<Datum> data;

    Data({
        required this.school,
        required this.data,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        school: School.fromJson(json["school"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "school": school.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String userFirstName;
    String userLastName;
    List<String> images;

    Datum({
        required this.userFirstName,
        required this.userLastName,
        required this.images,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userFirstName: json["user_first_name"],
        userLastName: json["user_last_name"],
        images: List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "user_first_name": userFirstName,
        "user_last_name": userLastName,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}

class School {
    String name;
    String district;
    dynamic description;
    dynamic image;

    School({
        required this.name,
        required this.district,
        this.description,
        required this.image,
    });

    factory School.fromJson(Map<String, dynamic> json) => School(
        name: json["name"],
        district: json["district"],
        description: json["description"] ?? '',
        image: json["image"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "district": district,
        "description": description,
        "image": image,
    };
}