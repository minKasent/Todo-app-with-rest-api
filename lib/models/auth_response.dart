class AuthResponse {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String accessToken; // Renamed from 'token' to 'accessToken'
  final String refreshToken;
  final int?
  expiresIn; // Made nullable as it might not always be present in the output

  AuthResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn, // Made optional
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      accessToken: json['accessToken'] as String, // Changed to 'accessToken'
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int?, // Changed to int?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken, // Changed to 'accessToken'
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}
