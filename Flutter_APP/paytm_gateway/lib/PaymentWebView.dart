import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Constants.dart';

class PaymentWebView extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String amount;

  //TODO: Also take CustomerID, To use this in practically.

  const PaymentWebView(
      {Key key, this.name, this.email, this.phone, this.amount})
      : super(key: key);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  WebViewController _webController;
  bool _loadingPayment = true;
  bool _isResultVisible = false;
  String _responseStatus = STATUS_LOADING;

  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'><input type='hidden' name='orderID' value='ORDER_${DateTime.now().millisecondsSinceEpoch}'/>" +
        "<input  type='hidden' name='custID' value='USER_${widget.name.replaceAll(' ', '')}' />" +
        "<input  type='hidden' name='amount' value='${widget.amount}' />" +
        "<input type='hidden' name='custEmail' value='${widget.email}' />" +
        "<input type='hidden' name='custPhone' value='${widget.phone}' />" +
        "</form></body> </html>";
  }

  void getData() {
    _webController.evaluateJavascript("document.body.innerText").then((data) {
//      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(data);
      final checksumResult = responseJSON["status"];
      final paytmResponse = responseJSON["data"];
      if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
        if (checksumResult == 0) {
          _responseStatus = STATUS_SUCCESSFUL;
        } else {
          _responseStatus = STATUS_CHECKSUM_FAILED;
        }
      } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
        _responseStatus = STATUS_FAILED;
      }
      this.setState(() {});
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCCESSFUL:
        return PaymentSuccessfulScreen();
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen();
      case STATUS_FAILED:
        return PaymentFailedScreen();
    }
    return PaymentSuccessfulScreen();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: (_isResultVisible) ? Colors.white : Color(0xFFE0EAEC),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom),
              child: WebView(
                debuggingEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webController = controller;
                  _webController.loadUrl(new Uri.dataFromString(_loadHTML(),
                          mimeType: 'text/html')
                      .toString());
                },
                onPageStarted: (page) {
                  if (page.contains("/callback")) {
                    setState(() {
                      _isResultVisible = true;
                    });
                  }
                },
                onPageFinished: (page) {
                  if (page.contains("/process")) {
                    if (_loadingPayment) {
                      this.setState(() {
                        _loadingPayment = false;
                      });
                    }
                  }
                  if (page.contains("/callback")) {
                    getData();
                  }
                },
              ),
            ),

            (_isResultVisible)
                ? Container(height: size.height, width: size.width, color: Color(0xFFE0EAEC),) : SizedBox(),

            (_loadingPayment)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(),
            (_responseStatus != STATUS_LOADING)
                ? Center(child: getResponseScreen())
                : Center()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }
}

class PaymentSuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.lightGreen,
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(),
            ),
            Neumorphic(
              style: NeumorphicStyle(
                  depth: 10,
                  color: Colors.green,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.circle()),
              child: Container(
                color: Colors.white,
                width: 160,
                height: 160,
                child: Center(
                  child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: new BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.done,
                        size: 70,
                        color: Colors.black,
                      )
//                decoration: new BoxDecoration(
//                    shape: BoxShape.circle,
//                    image: new DecorationImage(
//                        fit: BoxFit.fill,
//                        image: new AssetImage("images/paytm.png"))),
                      ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            NeumorphicText(
              "Payment Success!",
              textStyle: NeumorphicTextStyle(fontSize: 22),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: NeumorphicButton(
                    style: NeumorphicStyle(color: Colors.white),
                    provideHapticFeedback: true,
                    margin: EdgeInsets.only(top: 15),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName("/"));
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//onPressed: () {
//                    Navigator.popUntil(context, ModalRoute.withName("/"));
//                  })

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Color(0xFFe74c3c),
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(),
            ),
            Neumorphic(
              style: NeumorphicStyle(
                  depth: 10,
                  color: Color(0xFFc0392b),
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.circle()),
              child: Container(
                color: Colors.white,
                width: 160,
                height: 160,
                child: Center(
                  child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: new BoxDecoration(
                        color: Color(0xFFc0392b),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.done,
                        size: 70,
                        color: Colors.white,
                      )
//                decoration: new BoxDecoration(
//                    shape: BoxShape.circle,
//                    image: new DecorationImage(
//                        fit: BoxFit.fill,
//                        image: new AssetImage("images/paytm.png"))),
                      ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            NeumorphicText(
              "Payment Failed!",
              textStyle: NeumorphicTextStyle(
                fontSize: 22,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: NeumorphicButton(
                    style: NeumorphicStyle(
                      color: Colors.white,
                    ),
                    provideHapticFeedback: true,
                    margin: EdgeInsets.only(top: 15),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName("/"));
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Color(0xFFe67e22),
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(),
            ),
            Neumorphic(
              style: NeumorphicStyle(
                  depth: 10,
                  color: Color(0xFFd35400),
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.circle()),
              child: Container(
                color: Colors.white,
                width: 160,
                height: 160,
                child: Center(
                  child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: new BoxDecoration(
                        color: Color(0xFFd35400),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning,
                        size: 70,
                        color: Colors.white,
                      )
//                decoration: new BoxDecoration(
//                    shape: BoxShape.circle,
//                    image: new DecorationImage(
//                        fit: BoxFit.fill,
//                        image: new AssetImage("images/paytm.png"))),
                      ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            NeumorphicText(
              "Verification Failed!",
              textStyle: NeumorphicTextStyle(
                fontSize: 22,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: NeumorphicButton(
                    style: NeumorphicStyle(
                      color: Colors.white,
                    ),
                    provideHapticFeedback: true,
                    margin: EdgeInsets.only(top: 15),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName("/"));
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
