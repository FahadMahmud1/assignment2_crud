import 'dart:convert';

import 'package:assignment2_crud/add_product.dart';

import 'package:assignment2_crud/productModel.dart';
import 'package:assignment2_crud/update_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _getProductListInProgress = false;

  List<ProductModel> productList = [];

  @override
  void initState() {

    super.initState();
    _getProductInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductInfo,
        child: Visibility(

          visible: _getProductListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),

          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _buildProductItem(productList[index]);
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const addProductScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );

  }

  Future<void> _getProductInfo() async{
    _getProductListInProgress = true;
    setState(() {});

    productList.clear();
    const String prodcutlink = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri url = Uri.parse(prodcutlink);

    Response response = await get(url);

    print(response.statusCode);
    print(response.body);
    
    if(response.statusCode == 200){
      final decodeData = jsonDecode(response.body);
      final jsonList = decodeData['data'];

      for(Map<String,dynamic> json in jsonList ){
        ProductModel productModel = ProductModel.fromJson(json);

        productList.add(productModel);
      }
      
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product GET failed!!!!")));
    }

    _getProductListInProgress = false;
    setState(() {});


  }

  Widget _buildProductItem(ProductModel product) {
    return ListTile(
      // leading: Image.network('https://img.freepik.com/free-photo/pair-trainers_144627-3799.jpg',height: 60,),
      title: Text(product.productName ?? ''),
      subtitle: Wrap(
        spacing: 14,
        children: [
          Text('Unit Price : ${product.unitPrice}'),
          Text('Quantity : ${product.quantity}'),
          Text('Total Price: ${product.totalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(onPressed: () async {
           final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> updateProductScreen(product: product)));
            if(result == true){
              await _getProductInfo();
            }
          },
              icon: Icon(Icons.edit)),

          IconButton(onPressed: () {
            _deleteDialog(product.id!);
          }, icon: Icon(Icons.delete_rounded)),
        ],
      ),
    );
  }
//
  void _deleteDialog(String productId){
    showDialog(context: context, builder: (context){
      return Expanded(
          child: AlertDialog(
            title: Text("Delete"),
            content: Text("Are you sure you want to delete this Item?"),
            actions: [
              TextButton(
                  onPressed: (){
                _deleteProductInfo(productId);
                Navigator.pop(context);
              }, child: Text("Delete")),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
            ],
          )
      );

    });
  }

  Future<void> _deleteProductInfo(String productId) async{
    _getProductListInProgress = true;
    setState(() {});


     String deleteUrl = 'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    Uri url = Uri.parse(deleteUrl);

    Response response = await get(url);

    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      _getProductInfo();
    }
    else {
      _getProductListInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete Product Failed!!")));
    }




  }


}
