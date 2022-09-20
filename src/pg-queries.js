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

const getProducts = (limit = 5, page) => {
    return db.query(`
      SELECT id, name, slogan, description, category, default_price
      FROM products
      LIMIT ${limit}
    `);
}

const getSingleProduct = (product_id) => {
  return db.query(`
    SELECT id, name, slogan, description, category, default_price,
      (SELECT json_agg(item)
        FROM (
          SELECT feature, value
          FROM features
          WHERE product_id = products.id
        ) item
      ) as features
    FROM products
    WHERE id = ${product_id}
  `)
}

const getStyles = (product_id) => {
  return db.query(`
    SELECT id as product_id,
      (SELECT json_agg(item)
        FROM (
          SELECT id as style_id, name, original_price, sale_price, default_style,
            (SELECT json_agg(photos)
              FROM (
                SELECT url, thumbnail_url
                FROM photos
                WHERE style_id = styles.id
              ) photos
            ) as photos,
            (SELECT json_object_agg(
              skus.id, json_build_object(
                'quantity', quantity,
                'size', size
              )
            )
            FROM skus
            WHERE style_id = styles.id
            ) as skus
          FROM styles
          WHERE product_id = products.id
        ) item
      ) as results
    FROM products
    WHERE id = ${product_id}
  `)
}

const getRelated = (product_id) => {
  return db.query(`
    SELECT JSON_AGG(RELATED_PRODUCT_ID)
    FROM RELATED
    WHERE CURRENT_PRODUCT_ID = ${product_id}
  `)
}

module.exports = {
  getProducts: getProducts,
  getSingleProduct: getSingleProduct,
  getStyles: getStyles,
  getRelated: getRelated
}