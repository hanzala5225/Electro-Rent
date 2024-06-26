class OrderModel {
  final String productId;
  final String cnicNumber;
  final String cnincImage;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String rentPrice;
  final String deliveryTime;
  final dynamic returnTime;
  final bool isSale;
  final List productImages;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuantity;
  final double productTotalPrice;
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;
  final int numberOfWeeks;

  OrderModel({
    required this.productId,
    required this.categoryId,
    required this.cnicNumber,
    required this.cnincImage,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.rentPrice,
    required this.deliveryTime,
    required this.returnTime,
    required this.isSale,
    required this.productImages,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerDeviceToken,
    required this.numberOfWeeks,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'cnicNumber': cnicNumber,
      'cnincImage': cnincImage,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'rentPrice': rentPrice,
      'deliveryTime': deliveryTime,
      'returnTime': returnTime,
      'isSale': isSale,
      'productImages': productImages,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerDeviceToken': customerDeviceToken,
      'numberOfWeeks': numberOfWeeks,
    };
  }

  // creating a UserModel instance from a JSON map
  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      productId: json['productId'],
      cnicNumber: json['cnicNumber'],
      cnincImage: json['cnincImage'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      rentPrice: json['rentPrice'],
      deliveryTime: json['deliveryTime'],
      returnTime: json['returnTime'],
      isSale: json['isSale'],
      productImages: json['productImages'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
      customerId: json['customerId'],
      status: json['status'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerDeviceToken: json['customerDeviceToken'],
      numberOfWeeks: json['numberOfWeeks'],
    );
  }
}
