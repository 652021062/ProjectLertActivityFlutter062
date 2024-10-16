import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String activityName;
  String details;
  int numberOfApplicants;
  String time;
  String activityHours;
  DateTime date; // ฟิลด์ date เป็น DateTime

  ProductModel({
    required this.id,
    required this.activityName,
    required this.details,
    required this.numberOfApplicants,
    required this.time,
    required this.activityHours,
    required this.date,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"] ?? '',
        activityName: json["activity_name"] ?? '',
        details: json["details"] ?? '',
        numberOfApplicants: json["number_of_applicants"] ?? 0,
        time: json["time"] ?? '',
        activityHours: json["activity_hours"] ?? '',
        date: json["date"] != null && json["date"] is String
            ? DateTime.tryParse(json["date"]) ?? DateTime.now() // แปลงเป็น DateTime หรือใช้วันที่ปัจจุบันถ้าแปลงไม่สำเร็จ
            : DateTime.now(), // ใช้วันที่ปัจจุบันถ้าเป็น null
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "activity_name": activityName,
        "details": details,
        "number_of_applicants": numberOfApplicants,
        "time": time,
        "activity_hours": activityHours,
        "date": date.toIso8601String(), // แปลงเป็น ISO 8601
      };
}
