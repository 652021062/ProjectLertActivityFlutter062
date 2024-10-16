import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/product_service.dart';
import 'package:flutter_lab1/models/product_model.dart';
import 'package:intl/intl.dart'; // สำหรับการจัดรูปแบบวันที่

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String? activityName;
  String? details;
  int? numberOfApplicants;
  String? time;
  String? activityHours;
  DateTime? date; // ฟิลด์วันที่เป็น DateTime
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ตั้งค่าควบคุมวันที่เริ่มต้นเป็นวันที่ปัจจุบัน
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  void addProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ProductModel newProduct = ProductModel(
        id: '',
        activityName: activityName!,
        details: details!,
        numberOfApplicants: numberOfApplicants ?? 0,
        time: time!,
        activityHours: activityHours!,
        date: date ?? DateTime.now(),
      );

      try {
        final response = await ProductService().addProduct(context, newProduct);
        if (response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Activity added successfully!')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add activity')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(date!);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Activity'),
        backgroundColor: const Color.fromARGB(255, 90, 1, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a New Activity',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // ฟิลด์ข้อมูล (Activity Name)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Activity Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onSaved: (value) => activityName = value,
                  validator: (value) => value!.isEmpty ? 'Please enter activity name' : null,
                ),
                SizedBox(height: 16),

                // ฟิลด์ข้อมูล (Details)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onSaved: (value) => details = value,
                  validator: (value) => value!.isEmpty ? 'Please enter details' : null,
                ),
                SizedBox(height: 16),

                // ฟิลด์ข้อมูล (Number of Applicants)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Number of Applicants',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => numberOfApplicants = int.tryParse(value ?? '') ?? 0,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter number of applicants';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // ฟิลด์ข้อมูล (Time)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onSaved: (value) => time = value,
                  validator: (value) => value!.isEmpty ? 'Please enter time' : null,
                ),
                SizedBox(height: 16),

                // ฟิลด์ข้อมูล (Activity Hours)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Activity Hours',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onSaved: (value) => activityHours = value,
                  validator: (value) => value!.isEmpty ? 'Please enter activity hours' : null,
                ),
                SizedBox(height: 16),

                // ฟิลด์สำหรับวันที่
                TextFormField(
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  validator: (value) => date == null ? 'Please select a date' : null,
                  controller: _dateController,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: addProduct,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 0, 30, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Add Activity',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
