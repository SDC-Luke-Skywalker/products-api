require('dotenv').config();
const express = require('express');
const app = express();
const path = require('path');
const postgres = require('../src/pg-queries.js');

app.use(express.json());

app.listen(process.env.PORT);
console.log(`Listening on port ${process.env.PORT}`);

app.get(`/products`, (req, res) => {
  postgres.getProducts(null, null)
  .then(data => {
    res.send(data.rows);
  })
})

app.get(`/products/1`, (req, res) => {
  postgres.getSingleProduct(1)
  .then(data => {
    res.send(data.rows[0]);
  })
})