class ProductModel {
  String? id;
  String? productName;
  String? productCode;
  String? unitPrice;
  String? image;
  String? quantity;
  String? totalPrice;

  ProductModel({
    this.id,
    this.productName,
    this.productCode,
    this.unitPrice,
    this.image,
    this.quantity,
    this.totalPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      productName: json['ProductName'],
      productCode: json['ProductCode'],
      unitPrice: json['UnitPrice'],
      image: json['Img'],
      quantity: json['Qty'] ?? '',
      totalPrice: json['TotalPrice'] ?? '',
    );
  }
}
