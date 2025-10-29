const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

const initDB = async () => {
  try {
    console.log('🔄 Initializing database tables...');
    
    // Users table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        role VARCHAR(50) DEFAULT 'customer',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Products table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS products (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        price DECIMAL(10,2) NOT NULL,
        category VARCHAR(100),
        images TEXT[],
        stock INTEGER DEFAULT 0,
        featured BOOLEAN DEFAULT false,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Insert sample products
    await pool.query(`
      INSERT INTO products (name, description, price, category, stock, featured) 
      VALUES 
        ('Wireless Bluetooth Headphones', 'High-quality wireless headphones with noise cancellation', 99.99, 'Electronics', 50, true),
        ('Smart Watch', 'Feature-rich smartwatch with health monitoring', 199.99, 'Electronics', 30, true),
        ('Cotton T-Shirt', 'Comfortable cotton t-shirt in various colors', 19.99, 'Clothing', 100, false),
        ('Running Shoes', 'Lightweight running shoes for maximum comfort', 79.99, 'Footwear', 25, true)
      ON CONFLICT DO NOTHING;
    `);

    console.log('✅ Database tables initialized successfully');
  } catch (error) {
    console.error('❌ Database initialization failed:', error.message);
  }
};

module.exports = { pool, initDB };
