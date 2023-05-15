class EmailVerificationResponse {
  final String message;
  const EmailVerificationResponse({required this.message});

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResponse(message: json['message']);
  }
}

class SingleDistrictResponse {
  final String district;
  const SingleDistrictResponse({required this.district});

  factory SingleDistrictResponse.fromJson(Map<String, dynamic> json) {
    return SingleDistrictResponse(district: json['district']);
  }
}

class DistrictResponse {
  final String message;
  final List<SingleDistrictResponse> data;

  const DistrictResponse({required this.message, required this.data});

  factory DistrictResponse.fromJson(Map<String, dynamic> json) {
    return DistrictResponse(
        message: json['message'],
        data: List<SingleDistrictResponse>.from(
            json['data'].map((x) => SingleDistrictResponse.fromJson(x))));
  }
}

class School {
  String id;
  String name;
  String district;

  School({
    required this.id,
    required this.name,
    required this.district,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"],
        name: json["name"],
        district: json["district"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "district": district,
      };
}

class SchoolList {
  String message;
  List<School> data;

  SchoolList({
    required this.message,
    required this.data,
  });

  factory SchoolList.fromJson(Map<String, dynamic> json) => SchoolList(
        message: json["message"],
        data: List<School>.from(json["data"].map((x) => School.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class UserDetailsResponse {
  String message;
  UserDetails data;

  UserDetailsResponse({
    required this.message,
    required this.data,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      UserDetailsResponse(
        message: json["message"],
        data: UserDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class UserDetails {
  String firstName;
  String lastName;
  String email;
  dynamic bio;
  String profilePicture;
  String schoolName;
  String schoolDistrict;
  dynamic goalsMet;
  dynamic moneyRaised;
  dynamic collectibles;

  UserDetails(
      {required this.firstName,
      required this.lastName,
      this.bio,
      required this.profilePicture,
      required this.schoolName,
      required this.schoolDistrict,
      this.goalsMet,
      this.moneyRaised,
      this.collectibles,
      required this.email});

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        bio: json["bio"],
        profilePicture: json["profilePicture"],
        schoolName: json["schoolName"],
        schoolDistrict: json["schoolDistrict"],
        goalsMet: json["goalsMet"],
        moneyRaised: json["moneyRaised"],
        collectibles: json["collectibles"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "bio": bio,
        "profilePicture": profilePicture,
        "schoolName": schoolName,
        "schoolDistrict": schoolDistrict,
        "goalsMet": goalsMet,
        "moneyRaised": moneyRaised,
        "collectibles": collectibles,
      };
}

class RegisteredUserResponse {
  String message;
  RegisteredUserData data;

  RegisteredUserResponse({
    required this.message,
    required this.data,
  });

  factory RegisteredUserResponse.fromJson(Map<String, dynamic> json) =>
      RegisteredUserResponse(
        message: json["message"],
        data: RegisteredUserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class RegisteredUserData {
  String id;
  String token;
  // String profilePicture;
  RegisteredUserData({
    required this.id,
    required this.token,
    // required this.profilePicture
  });

  factory RegisteredUserData.fromJson(Map<String, dynamic> json) =>
      RegisteredUserData(
        id: json["id"],
        token: json["token"],
        // profilePicture: json["profilePicture"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
      };
}

// class UserId {
//   String userId;

//   UserId ({required this.userId});

//   factory UserID.fromJson
// }

class UserIdData {
  String userId;

  UserIdData({
    required this.userId,
  });

  factory UserIdData.fromJson(Map<String, dynamic> json) => UserIdData(
        userId: json["UserId"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
      };
}

class Welcome {
  String message;
  Data data;

  Welcome({
    required this.message,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
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
  String token;

  Data({
    required this.id,
    required this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
      };
}
