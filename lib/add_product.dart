import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class addProductScreen extends StatefulWidget {
  const addProductScreen({super.key});

  @override
  State<addProductScreen> createState() => _addProductScreenState();
}

class _addProductScreenState extends State<addProductScreen> {
  final TextEditingController _nameTEcontroller = TextEditingController();
  final TextEditingController _productCodeTEcontroller = TextEditingController();
  final TextEditingController _unitPriceTEcontroller = TextEditingController();
  final TextEditingController _quantityTEcontroller = TextEditingController();
  final TextEditingController _totalPriceTEcontroller = TextEditingController();
  final TextEditingController _imageTEcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _addNewProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameTEcontroller,

                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      InputDecoration(hintText: "Name", labelText: "Name"),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your response";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),

                TextFormField(
                  controller: _productCodeTEcontroller,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                  InputDecoration(hintText: "Product Code", labelText: "Product Code"),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your Product Code";
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: 15,
                ),



                TextFormField(
                  controller: _unitPriceTEcontroller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Unit Price",
                    labelText: "Unit Price",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write Unit Price";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _quantityTEcontroller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Quantity", labelText: "Quantity"),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter Quantity";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _totalPriceTEcontroller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Total Price",
                    labelText: "Total Price",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter Total Price";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _imageTEcontroller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: "Image",
                    labelText: "Image",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Visibility(
                  visible: _addNewProductInProgress ==false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),

                  child: ElevatedButton(
                  onPressed: () {
                    if(_formkey.currentState!.validate()){
                      _addProduct();
                    }
                  },
                  child: Text("Add"),
                ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future <void> _addProduct() async{
    _addNewProductInProgress=true;
    setState(() {});
    const String addProductUrl = 'https://crud.teamrabbil.com/api/v1/CreateProduct';

    Map<String,dynamic> inputData = {
      "Img":_imageTEcontroller.text.trim(),
      "ProductCode":_productCodeTEcontroller.text,
      "ProductName":_nameTEcontroller.text,
      "Qty":_quantityTEcontroller.text,
      "TotalPrice":_totalPriceTEcontroller.text,
      "UnitPrice":_unitPriceTEcontroller.text,
    };


    Uri uri = Uri.parse(addProductUrl);

    Response response = await post(
      uri,
      body: jsonEncode(inputData),
      headers: {'content-type' : 'application/json'},

    );

    print(response.body);
    print(response.statusCode);
    print(response.headers);

    _addNewProductInProgress=false;
    setState(() {});

    if(response.statusCode==200){

      _nameTEcontroller.clear();
      _unitPriceTEcontroller.clear();
      _totalPriceTEcontroller.clear();
      _productCodeTEcontroller.clear();
      _imageTEcontroller.clear();
      _quantityTEcontroller.clear();

     ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(content: Text("Product Added Successfully")
            ));


    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error! Product Add Failed...")
          ));

    }


  }

  @override
  void dispose() {
    _nameTEcontroller.dispose();
    _unitPriceTEcontroller.dispose();
    _quantityTEcontroller.dispose();
    _totalPriceTEcontroller.dispose();
    _productCodeTEcontroller.dispose();
    _imageTEcontroller.dispose();
    super.dispose();
  }


}
