const express = require('express')
const app = express()
const bodyParser = require("body-parser")
var cors = require('cors');

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}));

const port = process.env.PORT || 3000

app.get('/', (req, res) => res.send('Hello World!'))

const payment = require('./routes/payment.js');
app.use('/payment', payment);

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`))