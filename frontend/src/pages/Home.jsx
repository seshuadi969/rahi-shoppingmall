import React from 'react'
import { Link } from 'react-router-dom'
import { ShoppingBag, Truck, Shield, Star } from 'lucide-react'

const Home = () => {
  const features = [
    {
      icon: <ShoppingBag className="h-8 w-8" />,
      title: 'Wide Selection',
      description: 'Thousands of products across various categories'
    },
    {
      icon: <Truck className="h-8 w-8" />,
      title: 'Fast Delivery',
      description: 'Quick and reliable shipping to your doorstep'
    },
    {
      icon: <Shield className="h-8 w-8" />,
      title: 'Secure Shopping',
      description: 'Your data and payments are always protected'
    },
    {
      icon: <Star className="h-8 w-8" />,
      title: 'Best Quality',
      description: 'Premium products with quality guarantee'
    }
  ]

  return (
    <div>
      {/* Hero Section */}
      <section className="bg-gradient-to-r from-primary-600 to-primary-700 text-white py-20">
        <div className="container mx-auto px-4 text-center">
          <h1 className="text-4xl md:text-6xl font-bold mb-6">
            Welcome to Rahi Shopping Mall
          </h1>
          <p className="text-xl mb-8 opacity-90">
            Discover amazing products at unbeatable prices
          </p>
          <Link 
            to="/products" 
            className="bg-white text-primary-600 px-8 py-3 rounded-lg font-semibold text-lg hover:bg-gray-100 transition-colors inline-block"
          >
            Shop Now
          </Link>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-12">Why Choose Us?</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, index) => (
              <div key={index} className="text-center p-6">
                <div className="bg-primary-100 text-primary-600 rounded-full p-3 inline-flex mb-4">
                  {feature.icon}
                </div>
                <h3 className="text-xl font-semibold mb-2">{feature.title}</h3>
                <p className="text-gray-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-gray-100">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold mb-4">Ready to Start Shopping?</h2>
          <p className="text-gray-600 mb-8">Join thousands of satisfied customers today</p>
          <div className="space-x-4">
            <Link 
              to="/signup" 
              className="btn-primary text-lg px-8 py-3"
            >
              Create Account
            </Link>
            <Link 
              to="/products" 
              className="btn-secondary text-lg px-8 py-3"
            >
              Browse Products
            </Link>
          </div>
        </div>
      </section>
    </div>
  )
}

export default Home
