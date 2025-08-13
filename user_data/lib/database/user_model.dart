class UserModelData {
  final int? id;
  final String fName;
  final String lName;
  final String phone;
  final String email;
  final String password;
  final bool gender;
  final String occupation;
  final String city;
  final String state;
  final String country;
  final String userPic;

  UserModelData({
    this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    required this.password,
    required this.gender,
    required this.occupation,
    required this.city,
    required this.state,
    required this.country,
    required this.userPic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fName': fName,
      'lName': lName,
      'phone': phone,
      'email': email,
      'password': password,
      'gender': gender ? 1 : 0,
      'occupation': occupation,
      'city': city,
      'state': state,
      'country': country,
      'userPic': userPic,
    };
  }

  factory UserModelData.fromMap(Map<String, dynamic> map) {
    return UserModelData(
      id: map['id'] as int?,
      fName: map['fName'],
      lName: map['lName'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      gender: (map['gender'] == 1),
      occupation: map['occupation'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      userPic: map['userPic'],
    );
  }

  // ✅ Added copyWith method
  UserModelData copyWith({
    int? id,
    String? fName,
    String? lName,
    String? phone,
    String? email,
    String? password,
    bool? gender,
    String? occupation,
    String? city,
    String? state,
    String? country,
    String? userPic,
  }) {
    return UserModelData(
      id: id ?? this.id,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      userPic: userPic ?? this.userPic,
    );
  }
}
