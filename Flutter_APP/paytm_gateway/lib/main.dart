import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paytmgateway/PaymentWebView.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: Colors.white, // status bar color
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: NeumorphicThemeData(lightSource: LightSource.topLeft, depth: 10,
      baseColor: Color(0xFFE0EAEC)),
      home: PaymentForm(),
    );
  }
}

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  void initiatePayment() async {
    if (validateEmail() &&
        validatePhone() &&
        nameController.text.length > 0 &&
        double.tryParse(amountController.text) != null) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymentWebView(name: nameController.text, phone: phoneController.text, amount: amountController.text, email: emailController.text,)),
      );
    } else {
      FlutterToast(context).showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.redAccent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.close),
              SizedBox(
                width: 12.0,
              ),
              Text("Please enter correct details"),
            ],
          ),
        ),
      );
    }
  }

  bool validateEmail() {
    String email = emailController.text;

    RegExp regExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.hasMatch(email);
  }

  bool validatePhone() {
    String num = phoneController.text;

    RegExp regExp = new RegExp(
      r'^[0-9]{10}',
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.hasMatch(num);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
//            SizedBox(height: 45,),
                Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.circle()),
                  child: Container(
                    width: 130,
                    height: 130,
                    child: Center(
                      child: Container(
                        width: 110.0,
                        height: 110.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage("images/paytm.png"))),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Neumorphic(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: EdgeInsets.all(18),
                  style: NeumorphicStyle(
                      depth: 10,
                      boxShape:
                          NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                      shape: NeumorphicShape.flat),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Neumorphic(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(15)),
                            depth: -15,
                            shape: NeumorphicShape.flat),
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Phone Number",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Neumorphic(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(15)),
                            depth: -15,
                            shape: NeumorphicShape.flat),
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Email",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Neumorphic(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(15)),
                            depth: -15,
                            shape: NeumorphicShape.flat),
                        child: TextField(
                          controller: emailController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Amount",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Neumorphic(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(15)),
                            depth: -15,
                            shape: NeumorphicShape.flat),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Amount",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: NeumorphicButton(
                          provideHapticFeedback: true,
                          margin: EdgeInsets.only(top: 15),
                          onPressed: () {
                            initiatePayment();
                          },
                          child: Text(
                            "Pay",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
