var express = require('express');
var router = express.Router();

const checksum_lib = require("../utils/checksum.js");

const Constants = require("../utils/constants.js");

router.get('/', (req, res)=>{
  console.log(Constants.PaytmConfig);
  res.send("Recieved");
  res.end();
});

router.post('/pay', (req, res, next)=>{
    let paymentData = req.body;
  
    //TODO: Add validation for request data

    var params = {};
    params["MID"] = Constants.PaytmConfig.mid;
    params["WEBSITE"] = Constants.PaytmConfig.website;
    
    params["CHANNEL_ID"] = "WAP";
    params["INDUSTRY_TYPE_ID"] = "Retail";
    params["ORDER_ID"] = paymentData.orderID;
    params["CUST_ID"] = paymentData.custID;
    params["TXN_AMOUNT"] = paymentData.amount;

    params["CALLBACK_URL"] = Constants.PaytmConfig.callbackUrl;

    params["EMAIL"] = paymentData.custEmail;
    params["MOBILE_NO"] = paymentData.custPhone;
  
    checksum_lib.genchecksum(params, Constants.PaytmConfig.key, (err, checksum) => {
        if (err) {
        console.log("Error: " + e);
        }
  
        var form_fields = "";
        for (var x in params) {
        form_fields +=
            "<input type='hidden' name='" + x + "' value='" + params[x] + "' >";
        }
        form_fields +=
        "<input type='hidden' name='CHECKSUMHASH' value='" + checksum + "' >";
  
        res.writeHead(200, { "Content-Type": "text/html" });
        res.write(
        '<html><head><title>Merchant Checkout Page</title></head><body><center><h1>Please do not refresh this page...</h1></center><form method="post" action="' +
        Constants.PaytmConfig.txn_url +
            '" name="f1">' +
            form_fields +
            '</form><script type="text/javascript">document.f1.submit();</script></body></html>'
        );
        res.end();
    });
  });
  
  router.post("/callback", (req, res) => {
      let responseData = req.body;
      console.log(req.body);
      var checksumhash = responseData.CHECKSUMHASH;
      var result = checksum_lib.verifychecksum(
        responseData,
        Constants.PaytmConfig.key,
        checksumhash
      );
      if (result) {

        //TODO: Add data to database.

        return res.send({
          status: 0,
          data: responseData
        });
      } else {
        return res.send({
          status: 1,
          data: responseData
        });
      }
    });

//export this router to use in our index.js
module.exports = router;