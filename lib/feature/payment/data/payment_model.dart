class PaymentModel {
  final String? status;
  final String? message;
  final SubscriptionData? data;

  PaymentModel({
    this.status,
    this.message,
    this.data,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      status: json['status'],
      message: json['message'],
      data:
          json['data'] != null ? SubscriptionData.fromJson(json['data']) : null,
    );
  }
}

class SubscriptionData {
  final Subscription? subscription;

  SubscriptionData({this.subscription});

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
    );
  }
}

class Subscription {
  final String? user;
  final String? receiptImage;
  final String? status;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  Subscription({
    this.user,
    this.receiptImage,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      user: json['user'],
      receiptImage: json['receiptImage'],
      status: json['status'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
