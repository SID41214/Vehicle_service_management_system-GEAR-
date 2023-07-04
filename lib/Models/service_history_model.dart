import 'cart_model.dart';

class ServicesHistoryModel{
  String id;
  String createdBy;
  String createdTime;
  String total;
  String discount;
  String grandTotal;
  String vehicleId;
  String customerId;
  String customerName;
  String status;
  List<CartModel> cart;

  ServicesHistoryModel(
      {required this.id,
      required this.createdBy,
      required this.createdTime,
      required this.total,
      required this.discount,
      required this.grandTotal,
      required this.vehicleId,
      required this.customerId,
      required this.customerName,
      required this.status,
      required this.cart});
}