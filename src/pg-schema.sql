DROP DATABASE IF EXISTS 'product_api';
CREATE DATABASE 'product_api';

DROP TABLE IF EXISTS 'products';

CREATE TABLE 'products' (
  'id' TEXT NOT NULL,
  'name' TEXT NOT NULL,
  'slogan' TEXT NOT NULL,
  'description' TEXT NOT NULL,
  'category' TEXT NOT NULL,
  'default_price' TEXT NOT NULL,
  PRIMARY KEY ('id')
);

COPY 'products' (`id, name, slogan, description, category, default_price`)
FROM '/USERS/ytorresnicola/data/product.csv'
DELIMITER ','
CSV HEADER;

DROP TABLE IF EXISTS 'features';

CREATE TABLE 'features' (
  'id' TEXT NOT NULL,
  'product_id' TEXT NOT NULL,
  'feature' TEXT NOT NULL,
  'value' TEXT NOT NULL,
);

COPY 'features' (`id, product_id, feature, value`)
FROM '/USERS/ytorresnicola/data/features.csv'
DELIMITER ','
CSV HEADER;

DROP TABLE IF EXISTS 'related';

CREATE TABLE 'related' (
  'id' TEXT NOT NULL,
  'current_product_id' TEXT NOT NULL,
  'related_product_id' TEXT NOT NULL
);

COPY 'related' (`id, current_product_id, related_product_id`)
FROM '/USERS/ytorresnicola/data/related.csv'
DELIMITER ','
CSV HEADER;

DROP TABLE IF EXISTS 'skus';

CREATE TABLE 'skus' (
  'id' TEXT NOT NULL,
  'style_id' TEXT NOT NULL,
  'size' TEXT NOT NULL,
  'quantity' TEXT NOT NULL
);

COPY 'skus' (`id, style_id, size, quantity`)
FROM '/USERS/ytorresnicola/data/skus.csv'
DELIMITER ','
CSV HEADER;

DROP TABLE IF EXISTS 'styles';

CREATE TABLE 'styles' (
  'id' TEXT NOT NULL,
  'product_id' TEXT NOT NULL,
  'name' TEXT NOT NULL,
  'sale_price' TEXT,
  'original_price' TEXT NOT NULL,
  'default_style' TEXT NOT NULL
);

COPY 'styles' (`id, product_id, name, sale_price, original_price, default_style`)
FROM '/USERS/ytorresnicola/data/styles.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE 'products'
ALTER COLUMN 'id' TYPE 'int' USING 'id::integer';

ALTER TABLE 'features'
ALTER COLUMN 'id' TYPE 'int' USING 'id::integer'
ALTER COLUMN 'product_id' TYPE 'int' USING 'product_id::integer';

ALTER TABLE 'related'
ALTER COLUMN 'id' TYPE 'int' USING 'id::integer'
ALTER COLUMN 'current_product_id' TYPE 'int' USING 'current_product_id::integer'
ALTER COLUMN 'related_product_id' TYPE 'int' USING 'related_product_id::integer';

ALTER TABLE 'skus'
ALTER COLUMN 'id' TYPE 'int' USING 'id::integer'
ALTER COLUMN 'style_id' TYPE 'int' USING 'style_id::integer'
ALTER COLUMN 'quantity' TYPE 'int' USING 'quantity::integer';

ALTER TABLE 'styles'
ALTER COLUMN 'id' TYPE 'int' USING 'id::integer'
ALTER COLUMN 'product_id' TYPE 'int' USING 'product_id::integer'
ALTER COLUMN 'default_style' TYPE 'bool' USING 'default_style::int::bool';

ALTER TABLE 'features'
DROP CONSTRAINT IF EXISTS 'fk_features'
ADD CONSTRAINT 'fk_features'
FOREIGN KEY ('product_id')
REFERENCES 'products'('id')
ON DELETE CASCADE;

ALTER TABLE 'related'
DROP CONSTRAINT IF EXISTS 'fk_related'
ADD CONSTRAINT 'fk_related'
FOREIGN KEY ('current_product_id')
REFERENCES 'products'('id')
ON DELETE CASCADE;

ALTER TABLE 'skus'
DROP CONSTRAINT IF EXISTS 'fk_skus'
ADD CONSTRAINT 'fk_skus'
FOREIGN KEY ('style_id')
REFERENCES 'products'('id')
ON DELETE CASCADE;

ALTER TABLE 'styles'
DROP CONSTRAINT IF EXISTS 'fk_styles'
ADD CONSTRAINT 'fk_styles'
FOREIGN KEY ('product_id')
REFERENCES 'products'('id')
ON DELETE CASCADE;