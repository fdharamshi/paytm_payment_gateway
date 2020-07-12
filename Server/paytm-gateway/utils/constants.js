//PAYTM CONFIGURATION
var PaytmConfig = {
    mid: "MerchantID",
    key: "PaytmSecretKEY",
    website: "WEBSTAGING", //Changes in production

    callbackUrl: `http://192.168.1.125:3000/payment/callback`, //Your API's URL here
    txn_url: "https://securegw-stage.paytm.in/order/process" // for staging. Find the url for production in your business dashboard.
};

module.exports = {
    PaytmConfig: PaytmConfig
};

