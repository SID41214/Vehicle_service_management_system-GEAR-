import 'package:flutter/material.dart';
import 'package:gear/Screens/otp_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumber =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Column(
        children: <Widget>[
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Image(
              image: AssetImage('./assets/Image/otp-icon.png'),
              height: 200.0,
              width: 200.0,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
                left: 16.0, top: 10.0, right: 16.0, bottom: 40),
            child: Text(
              "Tap to Join Us",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 9,
                  child: TextField(
                    controller: phoneNumber,
                    focusNode: FocusNode(),
                    maxLength: 10,

                    autofocus: true,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                        hintText: 'Enter Mobile number'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                        fontSize: 20.0, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 40.0, left: 30, right: 30),
            child: SizedBox(
              width: double.infinity,
              height: 45.0,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(number: phoneNumber.text,)));
                  },
                  textColor: Colors.white,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: const Text(
                    "Get OTP",
                    style: TextStyle(fontSize: 18),
                  )),
            ),
          ),
          const Spacer(),
        ],
      ),
    ));
  }

}
