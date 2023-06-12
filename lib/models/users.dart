class Users {
  int? userID;
  String firstName;
  String lastName;
  String username;
  String password;
  String mobileHp;

  Users({
    this.userID,
    this.firstName = '',
    this.lastName = '',
    required this.username,
    required this.password,
    this.mobileHp = '',
  });

  String get fullName {
    return '$firstName $lastName';
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': userID,
      'f_name': firstName,
      'l_name': lastName,
      'username': username,
      'password': password,
      'mobilehp': mobileHp,
    };
    return map;
  }

  static Users fromMap(Map<String, dynamic> map) {
    return Users(
      userID: map['user_id'],
      firstName: map['f_name'],
      lastName: map['l_name'],
      username: map['username'],
      password: map['password'],
      mobileHp: map['mobilehp'],
    );
  }
}
