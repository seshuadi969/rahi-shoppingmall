const { pool } = require('../config/database');

class Product {
  static async create(productData) {
    const { name, description, price, category, images, stock, featured = false } = productData;
    
    const query = `
      INSERT INTO products (name, description, price, category, images, stock, featured)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
    `;
    
    const result = await pool.query(query, [name, description, price, category, images, stock, featured]);
    return result.rows[0];
  }

  static async findAll({ page = 1, limit = 10, category } = {}) {
    const offset = (page - 1) * limit;
    let query = 'SELECT * FROM products';
    let countQuery = 'SELECT COUNT(*) FROM products';
    const params = [];
    
    if (category) {
      query += ' WHERE category = $1';
      countQuery += ' WHERE category = $1';
      params.push(category);
    }
    
    query += ' ORDER BY created_at DESC LIMIT $' + (params.length + 1) + ' OFFSET $' + (params.length + 2);
    params.push(limit, offset);
    
    const [productsResult, countResult] = await Promise.all([
      pool.query(query, params),
      pool.query(countQuery, category ? [category] : [])
    ]);
    
    return {
      products: productsResult.rows,
      totalCount: parseInt(countResult.rows[0].count),
      page,
      limit
    };
  }

  static async findById(id) {
    const query = 'SELECT * FROM products WHERE id = $1';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  static async update(id, productData) {
    const { name, description, price, category, images, stock, featured } = productData;
    
    const query = `
      UPDATE products 
      SET name = $1, description = $2, price = $3, category = $4, images = $5, stock = $6, featured = $7, updated_at = CURRENT_TIMESTAMP
      WHERE id = $8
      RETURNING *
    `;
    
    const result = await pool.query(query, [name, description, price, category, images, stock, featured, id]);
    return result.rows[0];
  }

  static async delete(id) {
    const query = 'DELETE FROM products WHERE id = $1 RETURNING *';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }
}

module.exports = Product;
