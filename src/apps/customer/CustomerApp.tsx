import { Routes, Route, Link, useNavigate } from 'react-router-dom';
import { ShoppingCart, Search, User, MapPin, ChevronRight, Star, Clock } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { useState, useEffect } from 'react';
import { Button, Card, Input } from '../../packages/shared/components';

// --- MOCK DATA ---
const RESTAURANTS = [
  { id: '1', name: 'Burger Queen', rating: 4.8, time: '20-30 min', fee: 2.5, image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400', categories: ['Burgers', 'Fast Food'] },
  { id: '2', name: 'Sushi Zen', rating: 4.9, time: '35-45 min', fee: 3.0, image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400', categories: ['Japanese', 'Sushi'] },
  { id: '3', name: 'Pizza Hub', rating: 4.5, time: '15-25 min', fee: 1.5, image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400', categories: ['Pizza', 'Italian'] },
];

const PRODUCTS = [
  { id: 'p1', name: 'Z Burger Deluxe', price: 12.99, description: 'Double beef patty, cheese, special sauce', image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200' },
  { id: 'p2', name: 'Truffle Fries', price: 5.49, description: 'Crispy fries with truffle oil and parmesan', image: 'https://images.unsplash.com/photo-1573015084185-7205ba358ed9?w=200' },
  { id: 'p3', name: 'Z-Cola Large', price: 2.99, description: 'Refreshing 500ml beverage', image: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=200' },
];

export function CustomerApp() {
  const [cart, setCart] = useState<any[]>([]);
  const navigate = useNavigate();

  const addToCart = (product: any) => {
    setCart(prev => [...prev, product]);
  };

  const cartTotal = cart.reduce((acc, item) => acc + item.price, 0);

  return (
    <div className="bg-slate-50 min-h-screen pb-20 max-w-md mx-auto relative shadow-2xl">
      {/* Header */}
      <div className="bg-white p-4 sticky top-0 z-10 border-bottom border-slate-100 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <MapPin size={18} className="text-orange-500" />
          <span className="text-sm font-semibold truncate w-32">Main St, 123</span>
        </div>
        <div className="flex gap-4">
          <Link to="/customer/cart" className="relative">
            <ShoppingCart size={22} className="text-slate-700" />
            {cart.length > 0 && (
              <span className="absolute -top-2 -right-2 bg-orange-500 text-white text-[10px] w-5 h-5 flex items-center justify-center rounded-full border-2 border-white">
                {cart.length}
              </span>
            )}
          </Link>
          <User size={22} className="text-slate-700" />
        </div>
      </div>

      <Routes>
        <Route path="/" element={
          <div className="p-4 space-y-6">
            {/* Search */}
            <div className="relative">
              <Search className="absolute left-3 top-3 text-slate-400" size={18} />
              <Input placeholder="Search restaurants or food..." className="pl-10" />
            </div>

            {/* Categories */}
            <div className="flex gap-4 overflow-x-auto pb-2 scrollbar-hide">
              {['All', 'Burgers', 'Pizza', 'Sushi', 'Vegan'].map(cat => (
                <button key={cat} className="whitespace-nowrap px-4 py-2 rounded-full border border-slate-200 bg-white text-sm hover:bg-orange-500 hover:text-white transition-colors">
                  {cat}
                </button>
              ))}
            </div>

            {/* Restaurant List */}
            <h2 className="text-xl font-bold text-slate-900 pt-2">Popular Nearby</h2>
            <div className="space-y-4">
              {RESTAURANTS.map(res => (
                <Link key={res.id} to={`/customer/restaurant/${res.id}`}>
                  <Card className="flex flex-col gap-0 mb-4 hover:shadow-md transition-shadow">
                    <img src={res.image} className="h-40 w-full object-cover" alt={res.name} />
                    <div className="p-3">
                      <div className="flex justify-between items-start">
                        <h3 className="font-bold text-lg">{res.name}</h3>
                        <span className="flex items-center gap-1 text-sm bg-orange-50 text-orange-700 px-2 py-0.5 rounded font-semibold">
                          <Star size={14} fill="currentColor" /> {res.rating}
                        </span>
                      </div>
                      <p className="text-xs text-slate-500 mt-1">{res.categories.join(', ')}</p>
                      <div className="flex items-center gap-4 mt-3 text-xs text-slate-600">
                        <span className="flex items-center gap-1"><Clock size={14} /> {res.time}</span>
                        <span>•</span>
                        <span>Fee ${res.fee}</span>
                      </div>
                    </div>
                  </Card>
                </Link>
              ))}
            </div>
          </div>
        } />

        <Route path="/restaurant/:id" element={
          <div className="p-4">
            <Button variant="ghost" onClick={() => navigate(-1)} className="mb-4 -ml-2">
              <ChevronRight className="rotate-180" size={20} /> Back
            </Button>
            <h1 className="text-2xl font-bold mb-6">Burger Queen Menu</h1>
            <div className="space-y-6">
              {PRODUCTS.map(product => (
                <Card key={product.id} className="p-3 flex gap-3 relative">
                  <img src={product.image} className="w-20 h-20 rounded-lg object-cover" />
                  <div className="flex-1">
                    <h4 className="font-bold">{product.name}</h4>
                    <p className="text-xs text-slate-500 line-clamp-2 mt-1">{product.description}</p>
                    <p className="text-orange-600 font-bold mt-2">${product.price}</p>
                  </div>
                  <Button 
                    size="sm" 
                    className="absolute bottom-3 right-3 rounded-full w-8 h-8 p-0"
                    onClick={() => addToCart(product)}
                  >
                    +
                  </Button>
                </Card>
              ))}
            </div>
          </div>
        } />

        <Route path="/cart" element={
          <div className="p-4 flex flex-col h-[calc(100vh-140px)]">
            <h1 className="text-2xl font-bold mb-6">My Cart</h1>
            {cart.length === 0 ? (
              <div className="flex-1 flex flex-col items-center justify-center text-slate-400">
                <ShoppingCart size={64} className="mb-4 opacity-20" />
                <p>Your cart is empty</p>
              </div>
            ) : (
              <div className="flex-1 space-y-4 overflow-y-auto">
                {cart.map((item, idx) => (
                  <div key={idx} className="flex justify-between items-center border-b border-slate-100 pb-2">
                    <div className="flex gap-3">
                      <div className="w-12 h-12 bg-slate-100 rounded-lg"></div>
                      <div>
                        <p className="font-medium">{item.name}</p>
                        <p className="text-xs text-slate-400">1x</p>
                      </div>
                    </div>
                    <p className="font-bold">${item.price}</p>
                  </div>
                ))}
              </div>
            )}
            
            {cart.length > 0 && (
              <div className="mt-auto pt-6 border-t border-slate-200">
                <div className="flex justify-between mb-2">
                  <span className="text-slate-500">Subtotal</span>
                  <span>${cartTotal.toFixed(2)}</span>
                </div>
                <div className="flex justify-between mb-4">
                  <span className="text-slate-500">Delivery Fee</span>
                  <span>$2.50</span>
                </div>
                <div className="flex justify-between mb-6 text-lg font-bold">
                  <span>Total</span>
                  <span className="text-orange-600">${(cartTotal + 2.50).toFixed(2)}</span>
                </div>
                <Button className="w-full" size="lg" onClick={() => navigate('/customer/order-tracking')}>
                  Place Order
                </Button>
              </div>
            )}
          </div>
        } />

        <Route path="/order-tracking" element={
          <div className="p-4 flex flex-col items-center text-center">
            <div className="w-full h-48 bg-slate-200 rounded-2xl mb-8 flex items-center justify-center text-slate-400 font-mono text-xs">
              MOCK MAP VIEW <br/> STREETS & RIDER POSITION
            </div>
            <motion.div 
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              className="bg-orange-100 p-4 rounded-full text-orange-600 mb-4"
            >
              <Clock size={32} />
            </motion.div>
            <h2 className="text-xl font-bold">Order in Preparation</h2>
            <p className="text-slate-500 mt-2 text-sm">Estimated delivery in 20-30 mins</p>
            
            <Card className="w-full mt-8 p-4 text-left">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-slate-100 rounded-full flex items-center justify-center font-bold text-slate-600">JS</div>
                <div className="flex-1">
                  <p className="font-bold">John Rider</p>
                  <p className="text-xs text-slate-400">Assigned to your delivery</p>
                </div>
                <Button variant="outline" size="sm">Chat</Button>
              </div>
            </Card>

            <Button variant="ghost" className="mt-8" onClick={() => navigate('/customer/')}>
              Back to Home
            </Button>
          </div>
        } />
      </Routes>
    </div>
  );
}
