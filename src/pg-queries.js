require('dotenv').config();
const { Client } = require('pg');

const db = new Client ({
  user: process.env.USER,
  host: process.env.HOST,
  database: process.env.DB,
  password: process.env.PASS,
  port: process.env.DB_PORT
})

db.connect();

const getProducts = (limit, page) => {
  if (limit && !page) {
    return db.query(`
      SELECT id, name, slogan, description, category, default_price
      FROM products
      LIMIT ${limit}
    `);
  } else {
    return db.query(`
      SELECT id, name, slogan, description, category, default_price
      FROM products
      LIMIT 5
    `);
  }
}

const getSingleProduct = (product_id) => {
  return db.query(`
    select id, name, slogan, description, category, default_price,
      (select json_agg(item)
        from (
          select feature, value
          from features
          where product_id = products.id
        ) item
      ) as features
    from products
    where id = ${product_id}
  `)
}

module.exports = {
  getProducts: getProducts,
  getSingleProduct: getSingleProduct,
}