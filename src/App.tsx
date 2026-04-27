import { BrowserRouter as Router, Routes, Route, Link, Navigate } from 'react-router-dom';
import { LayoutDashboard, ShoppingBag, Store, Bike, ShieldCheck } from 'lucide-react';
import { motion } from 'motion/react';
import { CustomerApp } from './apps/customer/CustomerApp';
import { RestaurantApp } from './apps/restaurant/RestaurantApp';
import { RiderApp } from './apps/rider/RiderApp';
import { AdminApp } from './apps/admin/AdminApp';

// Root Landing to select Module (for dev preview context)
function ModuleSelector() {
  const modules = [
    { title: 'Customer App', path: '/customer', icon: ShoppingBag, color: 'bg-orange-500' },
    { title: 'Restaurant App', path: '/restaurant', icon: Store, color: 'bg-red-500' },
    { title: 'Rider App', path: '/rider', icon: Bike, color: 'bg-emerald-500' },
    { title: 'Admin Web', path: '/admin', icon: ShieldCheck, color: 'bg-indigo-500' },
  ];

  return (
    <div className="min-h-screen bg-slate-50 flex flex-col items-center justify-center p-6 font-sans">
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center mb-12"
      >
        <h1 className="text-4xl font-bold text-slate-900 mb-2">Velox Delivery</h1>
        <p className="text-slate-500">Select a module to view the prototype</p>
      </motion.div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 w-full max-w-6xl">
        {modules.map((m, idx) => (
          <Link key={m.path} to={m.path}>
            <motion.div
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: idx * 0.1 }}
              className="bg-white p-8 rounded-2xl shadow-sm border border-slate-100 flex flex-col items-center text-center group h-full"
            >
              <div className={`${m.color} p-4 rounded-xl text-white mb-4 group-hover:shadow-lg transition-all`}>
                <m.icon size={32} />
              </div>
              <h3 className="text-xl font-semibold text-slate-800">{m.title}</h3>
              <p className="text-sm text-slate-500 mt-2">
                Access the {m.title.toLowerCase()} module and flows.
              </p>
            </motion.div>
          </Link>
        ))}
      </div>
    </div>
  );
}

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<ModuleSelector />} />
        <Route path="/customer/*" element={<CustomerApp />} />
        <Route path="/restaurant/*" element={<RestaurantApp />} />
        <Route path="/rider/*" element={<RiderApp />} />
        <Route path="/admin/*" element={<AdminApp />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
}
