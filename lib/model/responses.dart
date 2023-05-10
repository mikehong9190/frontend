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