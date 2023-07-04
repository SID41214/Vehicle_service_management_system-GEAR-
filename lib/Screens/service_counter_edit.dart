import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Constants/my_colors.dart';
import '../Constants/my_functions.dart';
import '../Constants/user_preferences.dart';
import '../Models/cart_model.dart';
import '../Models/services_model.dart';

class ServiceCounterEdit extends StatefulWidget {
  String id;

  ServiceCounterEdit({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ServiceCounterEdit> createState() => _ServiceCounterEditState();
}

class _ServiceCounterEditState extends State<ServiceCounterEdit> {
  DatabaseReference mRootReference = FirebaseDatabase.instance.ref();
  TextEditingController searchProduct = TextEditingController();
  TextEditingController discountController = TextEditingController();
  String total = '0.00';
  String discount = '0.00';
  String grandTotal = '0.00';
  List<CartModel> cart = [];
  List<ServicesModel> list = [];
  List<ServicesModel> filterList = [];
  String orderId = "";
String customerName='';
String vehicle='';
  String accessCode='1';
  String status='PENDING';
  @override
  initState() {
    orderId = widget.id;
    getServiceItems();
    getServices();
    super.initState();
  }

  getData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(child: Text('Customer\n${customerName}')),
                Expanded(
                    child: Text('Vehicle\n${vehicle}')),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3.0),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.grey, width: 0.1)),
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: TextField(
                        keyboardType: TextInputType.text,
                        controller: searchProduct,
                        onChanged: onSearchProductChanged,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          // labelText: 'Username',
                          hintText: 'Search Product',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      content: SizedBox(
                        width: 400.0,
                        // Change as per your requirement
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () async {
                                setProductToCart(index);
                                // finish(context);
                              },
                              // trailing: Text(provider.filterList[index].rate),
                              title: Text(list[index].name),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        ),
                      ),
                    );
                  });
            },
            child: Row(
              children: const [
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Search Product",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.search),
                SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          // color: primaryColor,
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      color: primaryColor,
                      child: Text(
                        "Product",
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      color: primaryColor,
                      child: Text(
                        "Qty",
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      color: Colors.red,
                      child: Text(
                        "Rate",
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.red,
                    height: 30,
                    child: const Text(
                      "Total",
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: cart.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: InkWell(
                highlightColor: Colors.white12,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Product Data"),
                        content: SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              const Text(
                                "Quantity",
                                style: TextStyle(fontSize: 8),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  TextButton(

                                      onPressed: () {

                                        if(double.parse(cart[index].qty)!=0.0){

                                          cart[index].qty =(double.parse(cart[index].qty)-1).toString();
                                          calculateAmount();
                                          finish(context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty
                                            .resolveWith<Color>(
                                              (Set<MaterialState>
                                          states) {
                                            if (states.contains(
                                                MaterialState
                                                    .pressed)) {
                                              return primaryColor
                                                  .withOpacity(0.5);
                                            } else {
                                              return primaryColor
                                                  .withOpacity(0.5);
                                            }
                                          },
                                        ),
                                        padding: MaterialStateProperty.resolveWith<
                                            EdgeInsetsGeometry>(
                                              (Set<MaterialState>
                                          states) {
                                            if (states.contains(
                                                MaterialState
                                                    .pressed)) {
                                              return const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 30,
                                                  vertical: 10);
                                            } else {
                                              return const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 30,
                                                  vertical: 10);
                                            }
                                          },
                                        ),
                                      ),
                                      child: const Text(
                                        "-",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(cart[index].qty),
                                  ),
                                  // Text(provider
                                  //     .productCart[index].qty),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(

                                    // onPressed: () => provider.setCart(index, 1),

                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty
                                            .resolveWith<Color>(
                                              (Set<MaterialState>
                                          states) {
                                            if (states.contains(
                                                MaterialState
                                                    .pressed)) {
                                              return primaryColor;
                                            } else {
                                              return primaryColor;
                                            }
                                          },
                                        ),
                                        padding: MaterialStateProperty
                                            .resolveWith<
                                            EdgeInsetsGeometry>(
                                              (Set<MaterialState>
                                          states) {
                                            if (states.contains(
                                                MaterialState
                                                    .pressed)) {
                                              return const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 30,
                                                  vertical: 10);
                                            } else {
                                              return const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 30,
                                                  vertical: 10);
                                            }
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        if(double.parse(cart[index].qty)!=0.0){

                                          cart[index].qty =(double.parse(cart[index].qty)+1).toString();
                                          calculateAmount();
                                          finish(context);
                                        }
                                      },

                                      child: const Text(
                                        "+",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),


                              const Spacer(),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        mRootReference
                                            .child("Services")
                                            .child(orderId)
                                            .child("Items")
                                            .child(cart[index].id)
                                            .remove();
                                        cart.removeAt(index);
                                        calculateAmount();
                                        finish(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty
                                            .resolveWith<Color>(
                                              (Set<MaterialState>
                                          states) {
                                            if (states.contains(
                                                MaterialState
                                                    .pressed)) {
                                              return primaryColor
                                                  .withOpacity(0.5);
                                            } else {
                                              return primaryColor
                                                  .withOpacity(0.5);
                                            }
                                          },
                                        ),
                                        padding: MaterialStateProperty
                                            .resolveWith<
                                            EdgeInsetsGeometry>(
                                              (Set<MaterialState>
                                          states) {
                                            if (states.contains(
                                                MaterialState
                                                    .pressed)) {
                                              return const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 10,
                                                  vertical: 10);
                                            } else {
                                              return const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 10,
                                                  vertical: 10);
                                            }
                                          },
                                        ),
                                      ),
                                      child: const Text(
                                        "DELETE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 2.5),
                                      child: MaterialButton(
                                        color: primaryColor,
                                        onPressed: () =>
                                            finish(context),
                                        child: const Text(
                                          "CANCEL",
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                      )),
                                  const Spacer(),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 2.5),
                                    child: MaterialButton(
                                      color: primaryColor,
                                      onPressed: () {

                                        finish(context);
                                      },
                                      child: const Text(
                                        "OK",
                                        style:
                                        TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 35,
                            child: Text(
                              cart[index].name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: myBlack,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: Text(
                              cart[index].qty,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: myBlack,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: Text(
                              cart[index].rate,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: Text(
                              cart[index].total,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        )),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(child: Text("Total:\n$total")),
                Expanded(child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  AlertDialog(
                              title: const Text("Bill Discount"),
                              content: SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    TextFormField(
                                      inputFormatters: decimalValidation,
                                      controller:discountController,
                                      keyboardType:
                                      TextInputType.number,
                                      decoration:
                                      const InputDecoration(
                                        labelText: '0.00',
                                        hintText: 'Bill Discount',
                                        enabledBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(
                                                  5.0)),
                                          borderSide: BorderSide(
                                              width: 1.2),
                                        ),
                                        focusedBorder:
                                        OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(
                                                  5.0)),
                                          borderSide: BorderSide(
                                              width: 1.6),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Padding(
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                2.5),
                                            child: MaterialButton(
                                              color: primaryColor,
                                              onPressed: () =>
                                                  finish(context),
                                              child: const Text(
                                                "CANCEL",
                                              ),
                                            )),
                                        const Spacer(),
                                        Padding(
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                2.5),
                                            child: MaterialButton(
                                              color: primaryColor,
                                              onPressed: () {
                                                mRootReference.child("Services").child(orderId).child('Discount').set(discountController.text);
                                                finish(context);
                                              },
                                              child: const Text(
                                                "OK",

                                              ),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Text("Discount: \n$discount"))),
                Expanded(child: Text("Grand Total: \n${double.parse(grandTotal)}")),
              ],
            ),
          ),
        ),
        accessCode=='1'?status=='PENDING'?Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {
              mRootReference.child("Services").child(orderId).child('Status').set('APPROVED');
            },
            color: primaryColor,
            minWidth: double.infinity,
            child: const Text('APPROVE'),
          ),
        ):Container():(accessCode=='2'||accessCode=='3')?status=='APPROVED'?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {
              mRootReference.child("Services").child(orderId).child('Status').set('DELIVERED');
            },
            color: primaryColor,
            minWidth: double.infinity,
            child: const Text('PROCEED'),
          ),
        ):Container():Container(),
      ]),
    );
  }

  getServiceItems() async {
    mRootReference.child("ServicesItem").onValue.listen((event) {
      Map<dynamic, dynamic> customer = event.snapshot.value as Map;
      list.clear();
      customer.forEach((key, value) {
        list.add(ServicesModel(
          id: value['Id'],
          rate: value['Rate'],
          model: value['Model'],
          name: value['Name'],
          description: value['Description'],
        ));
      });
      filterList.addAll(list);
      setState(() {});
    });
  }

  onSearchProductChanged(String text) async {
    list.clear();
    if (text.isEmpty) {
      filterList.addAll(list);
      setState(() {});
      return;
    }
    for (var userDetail in list) {
      if (userDetail.name.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.name.contains(text)) {
        filterList.add(userDetail);
      }
    }
    setState(() {});
  }

  Future<void> setProductToCart(int index) async {
    if (cart.any((element) => element.serviceId == filterList[index].id)) {
      int i = cart
          .indexWhere((element) => element.serviceId == filterList[index].id);
      double qty = (double.parse(cart[i].qty) + 1);

      cart[i].qty = qty.toString();
      calculateAmount();
    } else {
      String amount = double.parse(filterList[index].rate).toStringAsFixed(3);
      String grossAmount =
          double.parse(filterList[index].rate).toStringAsFixed(3);
      String netAmount =
          double.parse(filterList[index].rate).toStringAsFixed(3);
      String taxAmount = "0.00";

      cart.add(CartModel(
          id: (cart.length + 1).toString(),
          serviceId: filterList[index].id,
          name: filterList[index].name,
          price: filterList[index].rate,
          qty: '1',
          rate: filterList[index].rate,
          total: filterList[index].rate));
      calculateAmount();
    }
  }

  void calculateAmount() async {
    double _totalAmt = 0.00;
    double _grandAmt = 0.00;
    int i = 0;
    for (CartModel s in cart) {
      String amount = (double.parse(s.rate)* double.parse(s.qty)).toStringAsFixed(3);
      cart[i].total = amount;
      _totalAmt = _totalAmt + double.parse(amount);
      _grandAmt = _grandAmt + double.parse(amount);
      i++;
      HashMap<String,dynamic>data=HashMap();
      data['Id']=s.id;
      data['ServiceId']=s.serviceId;
      data['Name']=s.name;
      data['Price']=s.price;
      data['Qty']=s.qty;
      data['Rate']=s.rate;
      data['Total']=s.total;
      mRootReference.child("Services").child(orderId).child("Items").child(s.id).update(data);
    }
    total = (_grandAmt).toStringAsFixed(3);
    grandTotal = (_grandAmt-double.parse(discount)).toStringAsFixed(3);
    HashMap<String,dynamic>main=HashMap();
    main['Total'] = total;
    main['Discount'] = discount;
    main['GrandTotal'] = grandTotal;
    mRootReference.child("Services").child(orderId).update(main);

    setState((){});
  }
  getServices() async{
    accessCode=await getString(UserPreferences.ACCESS_CODE);
    mRootReference.child("Services").child(orderId).onValue.listen((event) {
      if(event.snapshot.exists) {
        Map<dynamic, dynamic> services = event.snapshot.value as Map;
        status= services['Status'];
        customerName=services['CustomerName'] ;
        vehicle=services['vehicleId'] ;
        total=services['Total'] ;
        discount=services['Discount'];
        grandTotal=services['GrandTotal'];
        setState(() {
        });
      }else{
        setState(() {
        });
      }
    });
    mRootReference.child("Services").child(orderId).child('Items').onValue.listen((event) {
      if(event.snapshot.exists) {
        Map<dynamic, dynamic> services = event.snapshot.value as Map;
        cart.clear();
        services.forEach((key1, value1) {
          cart.add(CartModel(id: value1['Id'],
              serviceId:  value1['ServiceId'],
              name:  value1['Name'],
              price:  value1['Price'],
              qty:  value1['Qty'],
              rate:  value1['Rate'],
              total:  value1['Total']));
        });
        setState(() {
        });
      }else{
        setState(() {
        });
      }
    });
  }
}
