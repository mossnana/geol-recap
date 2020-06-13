require('dotenv').config();
const express = require('express');
const cors = require('cors');
const port = process.env.PORT || 3000
const app = express()
const bodyParser = require("body-parser");

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const webRouter = require('./routes/web');
const mobileRouter = require('./routes/mobile');

app.use('/web', webRouter);
app.use('/mobile', mobileRouter);

app.listen(port, () => console.log(`Example app listening on port ${port}!`));