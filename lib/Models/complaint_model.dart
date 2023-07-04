class ComplaintsModel{
  String id;
  String title;
  String description;
  String customer;
  String customerName;
  String date;
  String dateMillisecondsSinceEpoch;

  ComplaintsModel({required this.id, required this.title, required this.description, required this.customer,required this.customerName,required this.date,required this.dateMillisecondsSinceEpoch});
}