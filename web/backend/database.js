require('dotenv').config();
const postgres = require("pg-promise")()
const database =  postgres(process.env.POSTGRESQL);
module.exports = database