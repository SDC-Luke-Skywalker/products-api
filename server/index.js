require('dotenv').config();
const express = require('express');
const app = express();
const path = require('path');
const postgres = require('../src/pg-queries.js');

app.use(express.json());

app.listen(process.env.PORT);
console.log(`Listening on port ${process.env.PORT}`);

app.get(`/products/`, (req, res) => {
  postgres.getProducts(req.query.count, req.query.page)
  .then(data => {
    res.send(data.rows);
  })
});

app.get(`/products/:product_id`, (req, res) => {
  postgres.getSingleProduct(req.params.product_id)
  .then(data => {
    res.send(data.rows[0]);
  })
});

app.get(`/products/:product_id/styles`, (req, res) => {
  postgres.getStyles(req.params.product_id)
  .then(data => {
    res.send(data.rows[0]);
  })
});

app.get(`/products/:product_id/related`, (req, res) => {
  postgres.getRelated(req.params.product_id)
  .then(data => {
    res.send(data.rows[0].json_agg ? data.rows[0].json_agg : 'No related products.');
  })
});