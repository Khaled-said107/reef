class CreatePostModel {
  final String name;
  final String description;
  final int price;
  final String priceUnit;
  final int quantity;
  final String quantityUnit;
  final String sellType;
  final String condition;
  final String address;
  final String phone;
  final String whatsapp;
  final String categoryId;
  final String subCategoryId;
  final List<String> images;

  CreatePostModel({
    required this.name,
    required this.description,
    required this.price,
    required this.priceUnit,
    required this.quantity,
    required this.quantityUnit,
    required this.sellType,
    required this.condition,
    required this.address,
    required this.phone,
    required this.whatsapp,
    required this.categoryId,
    required this.subCategoryId,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "priceUnit": priceUnit,
      "quantity": quantity,
      "quantityUnit": quantityUnit,
      "sellType": sellType,
      "condition": condition,
      "address": address,
      "phone": phone,
      "whatsapp": whatsapp,
      "categoryId": categoryId,
      "subCategoryId": subCategoryId,
      "images": images,
    };
  }
}
