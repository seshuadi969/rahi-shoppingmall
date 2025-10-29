import React from 'react'

function App() {
  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
      <h1>🛍️ Rahi Shopping Mall</h1>
      <p>Welcome to our online store!</p>
      <div>
        <h2>Features:</h2>
        <ul>
          <li>Product Catalog</li>
          <li>Shopping Cart</li>
          <li>User Authentication</li>
          <li>Secure Checkout</li>
        </ul>
      </div>
      <p>Backend API: <span id="api-status">Checking...</span></p>
    </div>
  )
}

export default App
