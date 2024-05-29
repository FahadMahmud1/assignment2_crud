import 'dart:convert';


import 'package:assignment2_crud/productModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class updateProductScreen extends StatefulWidget {
  const updateProductScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<updateProductScreen> createState() => _addProductScreenState();
}

class _addProductScreenState extends State<updateProductScreen> {
  final TextEditingController _nameTEcontroller = TextEditingController();
  final TextEditingController _productCodeTEcontroller = TextEditingController();
  final TextEditingController _unitPriceTEcontroller = TextEditingController();
  final TextEditingController _quantityTEcontroller = TextEditingController();
  final TextEditingController _totalPriceTEcontroller = TextEditingController();
  final TextEditingController _imageTEcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _updateProductInProgress = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTEcontroller.text = widget.product.productName ?? '';
    _productCodeTEcontroller.text = widget.product.productCode ?? '';
    _quantityTEcontroller.text = widget.product.quantity ?? '';
    _imageTEcontroller.text = widget.product.image ?? '';
    _unitPriceTEcontroller.text = widget.product.unitPrice ?? '';
    _totalPriceTEcontroller.text = widget.product.totalPrice ?? '';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update a Product"),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Product Code",
                    labelText: "Product Code",
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write Product Code Here";
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
                 visible: _updateProductInProgress == false,
                 replacement: const Center(
                   child: CircularProgressIndicator(),
                 ),
                 child: ElevatedButton(
                      onPressed: () {
                        if(_formkey.currentState!.validate()){
                          _updateProduct();
                        }
                      },
                      child: Text("Update",style: TextStyle(fontSize: 18),),
                    ),
               ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async{
    _updateProductInProgress  = true;
    setState(() {});

    Map<String, String> inputData = {
      "Img": _imageTEcontroller.text,
      "ProductCode": _productCodeTEcontroller.text,
      "ProductName": _nameTEcontroller.text,
      "Qty": _quantityTEcontroller.text,
      "TotalPrice": _totalPriceTEcontroller.text,
      "UnitPrice":_unitPriceTEcontroller.text,
    };

    String updateProductUrl = 'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}';

    Uri url = Uri.parse(updateProductUrl);

    Response response = await post(
      url,
    headers: {'content-type': 'application/json'},
      body: jsonEncode(inputData),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product Updated Successfully")
          ));
      Navigator.pop(context,true);
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error! Not Successful")
          ));
    }



  }

  @override
  void dispose() {
    _nameTEcontroller.dispose();
    _unitPriceTEcontroller.dispose();
    _quantityTEcontroller.dispose();
    _totalPriceTEcontroller.dispose();
    _imageTEcontroller.dispose();
    _productCodeTEcontroller.dispose();
    super.dispose();

  }


}
