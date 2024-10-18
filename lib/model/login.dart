class Login {
  int? code;
  bool? status;
  String? token;
  int? userId;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userId, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    try {
      if (obj['code'] == 200) {
        return Login(
          code: obj['code'],
          status: obj['status'],
          token: obj['data']?['token'],
          userId: obj['data']?['user']?['id'], // Pastikan ini ada
          userEmail: obj['data']?['user']?['email'],
        );
      } else {
        return Login(
          code: obj['code'],
          status: obj['status'],
        );
      }
    } catch (e) {
      print("Error parsing login response: $e");
      return Login();
    }
  }
}
