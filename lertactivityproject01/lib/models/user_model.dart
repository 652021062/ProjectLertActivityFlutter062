import 'dart:convert';

// ฟังก์ชันสำหรับแปลงจาก JSON เป็น UserModel
UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

// ฟังก์ชันสำหรับแปลงจาก UserModel เป็น JSON
String userModelToJson(UserModel data) => json.encode(data.toJson());

// คลาส UserModel
class UserModel {
  User user;
  String accessToken;
  String refreshToken;

  UserModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
        accessToken: json["accessToken"] ?? '', // ป้องกันค่าที่เป็น null
        refreshToken: json["refreshToken"] ?? '', // ป้องกันค่าที่เป็น null
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}

// คลาส User
class User {
  String id;
  String userName;
  String name;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.userName,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] ?? '', // ป้องกันค่าที่เป็น null
        userName: json["username"] ?? '', // ป้องกันค่าที่เป็น null
        name: json["name"] ?? '', // ป้องกันค่าที่เป็น null
        role: json["role"] ?? '', // ป้องกันค่าที่เป็น null
        createdAt: json["createdAt"] != null 
            ? DateTime.parse(json["createdAt"]) 
            : DateTime.now(), // ป้องกันค่าที่เป็น null และตั้งค่าเริ่มต้น
        updatedAt: json["updatedAt"] != null 
            ? DateTime.parse(json["updatedAt"]) 
            : DateTime.now(), // ป้องกันค่าที่เป็น null และตั้งค่าเริ่มต้น
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": userName,
        "name": name,
        "role": role,
        "createdAt": createdAt.toIso8601String(), // ส่งวันที่ในรูปแบบ ISO 8601
        "updatedAt": updatedAt.toIso8601String(), // ส่งวันที่ในรูปแบบ ISO 8601
      };
}
