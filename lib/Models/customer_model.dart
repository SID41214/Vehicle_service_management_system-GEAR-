class CustomerModel{
  String id;
  String name;
  String number;
  String createdBy;
  String vehicleCount;
  String joinDate;

  CustomerModel(
      {required this.id,
      required this.name,
      required this.number,
      required this.createdBy,
      required this.vehicleCount,
      required this.joinDate});
}