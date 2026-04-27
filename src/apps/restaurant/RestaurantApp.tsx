import { useState } from 'react';
import { LayoutDashboard, Utensils, Settings, Bell, Circle, CheckCircle2, Package, Truck } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { Button, Card } from '../../packages/shared/components';

const MOCK_ORDERS = [
  { id: '101', customer: 'Alice Smith', items: '2x Z Burger, 1x Fries', total: 31.47, status: 'new', time: '5m ago' },
  { id: '100', customer: 'Bob Jones', items: '1x Sushi Platter', total: 45.00, status: 'preparing', time: '15m ago' },
];

export function RestaurantApp() {
  const [activeTab, setActiveTab] = useState('orders');
  const [orders, setOrders] = useState(MOCK_ORDERS);

  const updateStatus = (id: string, nextStatus: string) => {
    setOrders(prev => prev.map(o => o.id === id ? { ...o, status: nextStatus } : o));
  };

  return (
    <div className="bg-slate-50 min-h-screen flex font-sans">
      {/* Sidebar for Desktop / Bottom Nav for Mobile - using Sidebar for this view */}
      <div className="w-64 bg-slate-900 text-white p-6 hidden md:flex flex-col">
        <h1 className="text-2xl font-bold mb-10 flex items-center gap-2">
          <Utensils className="text-orange-500" /> Velox Vendor
        </h1>
        <nav className="space-y-2 flex-1">
          {[
            { id: 'orders', label: 'Orders', icon: LayoutDashboard },
            { id: 'menu', label: 'Menu', icon: Utensils },
            { id: 'settings', label: 'Settings', icon: Settings },
          ].map(item => (
            <button
              key={item.id}
              onClick={() => setActiveTab(item.id)}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${activeTab === item.id ? 'bg-orange-500 text-white' : 'text-slate-400 hover:bg-slate-800'}`}
            >
              <item.icon size={20} />
              {item.label}
            </button>
          ))}
        </nav>
        <div className="mt-auto p-4 bg-slate-800 rounded-xl">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium">Store Status</span>
            <div className="w-10 h-5 bg-emerald-500 rounded-full relative">
              <div className="absolute right-0.5 top-0.5 w-4 h-4 bg-white rounded-full shadow-sm" />
            </div>
          </div>
          <p className="text-[10px] text-slate-400 mt-1">Accepting new orders</p>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 p-8">
        <header className="flex justify-between items-center mb-8">
          <div>
            <h2 className="text-3xl font-bold text-slate-900">
              {activeTab === 'orders' ? 'Current Orders' : activeTab === 'menu' ? 'Menu Manager' : 'Settings'}
            </h2>
            <p className="text-slate-500 mt-1">Managing Burger Queen</p>
          </div>
          <Button variant="outline" className="relative">
            <Bell size={20} />
            <span className="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full border-2 border-white" />
          </Button>
        </header>

        {activeTab === 'orders' && (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* New Orders */}
            <div className="space-y-4">
              <h3 className="text-sm font-bold text-slate-500 uppercase tracking-wider flex items-center gap-2">
                <Circle size={8} fill="#f97316" className="text-orange-500" /> New (1)
              </h3>
              {orders.filter(o => o.status === 'new').map(order => (
                <Card key={order.id} className="p-4 border-l-4 border-l-orange-500">
                  <div className="flex justify-between mb-2">
                    <span className="font-bold">#{order.id}</span>
                    <span className="text-xs text-slate-400">{order.time}</span>
                  </div>
                  <p className="font-semibold text-lg">{order.customer}</p>
                  <p className="text-sm text-slate-500 mt-1">{order.items}</p>
                  <div className="mt-4 flex gap-2">
                    <Button variant="secondary" className="flex-1" onClick={() => updateStatus(order.id, 'preparing')}>Accept</Button>
                    <Button variant="ghost" className="text-red-500">Reject</Button>
                  </div>
                </Card>
              ))}
            </div>

            {/* Preparing */}
            <div className="space-y-4">
              <h3 className="text-sm font-bold text-slate-500 uppercase tracking-wider flex items-center gap-2">
                <Circle size={8} fill="#3b82f6" className="text-blue-500" /> Preparing (1)
              </h3>
              {orders.filter(o => o.status === 'preparing').map(order => (
                <Card key={order.id} className="p-4">
                  <div className="flex justify-between mb-2">
                    <span className="font-bold">#{order.id}</span>
                    <span className="flex items-center gap-1 text-xs text-blue-600 font-medium">
                      <Package size={14} /> In Kitchen
                    </span>
                  </div>
                  <p className="font-semibold text-lg">{order.customer}</p>
                  <p className="text-sm text-slate-500 mt-1">{order.items}</p>
                  <Button className="w-full mt-4" onClick={() => updateStatus(order.id, 'ready')}>Ready for Pickup</Button>
                </Card>
              ))}
            </div>

            {/* Ready / Delivering */}
            <div className="space-y-4">
              <h3 className="text-sm font-bold text-slate-500 uppercase tracking-wider flex items-center gap-2">
                <CheckCircle2 size={14} className="text-emerald-500" /> Dispatched
              </h3>
              <div className="text-center py-12 bg-slate-100 rounded-2xl border-2 border-dashed border-slate-200">
                 <Truck className="mx-auto text-slate-300 mb-2" size={32} />
                 <p className="text-xs text-slate-400">No orders out for delivery</p>
              </div>
            </div>
          </div>
        )}
        
        {activeTab === 'menu' && (
          <div className="bg-white p-8 rounded-2xl border border-slate-100 shadow-sm text-center">
             <Utensils className="mx-auto mb-4 text-slate-200" size={64} />
             <h3 className="text-xl font-bold">Menu Management Coming Soon</h3>
             <p className="text-slate-500 mt-2">Manage categories, items, and availability.</p>
          </div>
        )}
      </div>
    </div>
  );
}
