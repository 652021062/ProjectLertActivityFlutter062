import 'package:flutter/material.dart';
import 'package:flutter_lab1/controller/product_service.dart';
import 'package:flutter_lab1/models/product_model.dart';
import 'package:intl/intl.dart'; // สำหรับการจัดรูปแบบวันที่

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late String activityName;
  late String details;
  late int numberOfApplicants;
  late String time;
  late String activityHours;
  late DateTime date; // ฟิลด์ date เป็น DateTime
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    activityName = widget.product.activityName;
    details = widget.product.details;
    numberOfApplicants = widget.product.numberOfApplicants;
    time = widget.product.time;
    activityHours = widget.product.activityHours;
    date = widget.product.date; // ใช้ DateTime ตรงๆ
    _dateController.text = DateFormat('dd/MM/yyyy').format(date); // แสดงวันที่ใน TextEditingController
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProduct = ProductModel(
        id: widget.product.id,
        activityName: activityName,
        details: details,
        numberOfApplicants: numberOfApplicants,
        time: time,
        activityHours: activityHours,
        date: date, // ส่ง DateTime ตรงๆ
      );

      final success = await ProductService().updateProduct(updatedProduct, context);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update activity.')));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(date); // อัปเดต TextEditingController
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
        title: Text("Edit Activity"),
        backgroundColor: const Color.fromARGB(255, 90, 1, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: activityName,
                decoration: InputDecoration(
                  labelText: "Activity Name",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => activityName = value,
                validator: (value) => value!.isEmpty ? 'Please enter activity name' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: details,
                decoration: InputDecoration(
                  labelText: "Details",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => details = value,
                validator: (value) => value!.isEmpty ? 'Please enter details' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: numberOfApplicants.toString(),
                decoration: InputDecoration(
                  labelText: "Number of Applicants",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => numberOfApplicants = int.tryParse(value) ?? 0,
                validator: (value) => value!.isEmpty ? 'Please enter number of applicants' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: time,
                decoration: InputDecoration(
                  labelText: "Time",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => time = value,
                validator: (value) => value!.isEmpty ? 'Please enter time' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: activityHours,
                decoration: InputDecoration(
                  labelText: "Activity Hours",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) => activityHours = value,
                validator: (value) => value!.isEmpty ? 'Please enter activity hours' : null,
              ),
              SizedBox(height: 15),
              // ฟิลด์วันที่
              TextFormField(
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: _dateController,
                validator: (value) => date == null ? 'Please select a date' : null,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 4, 255),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: Text(
                    "Update Activity",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
