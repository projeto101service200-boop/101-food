import { useState } from 'react';
import { 
  BarChart3, Users, Store, Bike, ClipboardList, ShieldAlert, 
  Settings, Search, ArrowUpRight, TrendingUp, DollarSign, Activity 
} from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line } from 'recharts';
import { Button, Card, Input } from '../../packages/shared/components';

const MOCK_DATA = [
  { name: 'Mon', orders: 400, revenue: 2400 },
  { name: 'Tue', orders: 300, revenue: 1398 },
  { name: 'Wed', orders: 200, revenue: 9800 },
  { name: 'Thu', orders: 278, revenue: 3908 },
  { name: 'Fri', orders: 189, revenue: 4800 },
  { name: 'Sat', orders: 239, revenue: 3800 },
  { name: 'Sun', orders: 349, revenue: 4300 },
];

export function AdminApp() {
  const [activeView, setActiveView] = useState('dashboard');

  return (
    <div className="bg-slate-50 min-h-screen flex font-sans">
      {/* Admin Sidebar */}
      <div className="w-72 bg-white border-r border-slate-200 p-8 flex flex-col h-screen sticky top-0">
        <div className="flex items-center gap-3 mb-10 px-2 text-indigo-600">
          <div className="bg-indigo-600 text-white p-2 rounded-xl">
            <ClipboardList size={24} />
          </div>
          <h1 className="text-2xl font-black tracking-tight text-slate-900">Velox Admin</h1>
        </div>

        <nav className="space-y-1 flex-1">
          {[
            { id: 'dashboard', label: 'Dashboard', icon: BarChart3 },
            { id: 'restaurants', label: 'Restaurants', icon: Store },
            { id: 'riders', label: 'Riders', icon: Bike },
            { id: 'users', label: 'Customers', icon: Users },
            { id: 'approvals', label: 'Approvals', icon: ShieldAlert, badge: 3 },
            { id: 'settings', label: 'Settings', icon: Settings },
          ].map(item => (
            <button
              key={item.id}
              onClick={() => setActiveView(item.id)}
              className={`w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all ${activeView === item.id ? 'bg-indigo-50 text-indigo-700 font-bold shadow-sm' : 'text-slate-500 hover:bg-slate-50'}`}
            >
              <div className="flex items-center gap-3">
                <item.icon size={20} />
                {item.label}
              </div>
              {item.badge && (
                <span className="bg-red-500 text-white text-[10px] w-5 h-5 flex items-center justify-center rounded-full">
                  {item.badge}
                </span>
              )}
            </button>
          ))}
        </nav>

        <div className="mt-auto border-t border-slate-100 pt-6">
           <div className="flex items-center gap-3 px-2">
              <div className="w-10 h-10 bg-slate-100 rounded-full"></div>
              <div>
                <p className="text-sm font-bold">Admin User</p>
                <p className="text-[10px] text-slate-400">Global Moderator</p>
              </div>
           </div>
        </div>
      </div>

      {/* Main Panel */}
      <div className="flex-1 p-10 overflow-y-auto">
        <header className="flex justify-between items-center mb-10">
          <div>
            <h2 className="text-4xl font-black text-slate-900 capitalize">{activeView}</h2>
            <p className="text-slate-500 mt-2">Overview of platform performance and operations.</p>
          </div>
          <div className="flex gap-4">
             <div className="relative w-64">
                <Search className="absolute left-3 top-3 text-slate-400" size={18} />
                <Input placeholder="Global search..." className="pl-10" />
             </div>
             <Button variant="secondary">Generate Report</Button>
          </div>
        </header>

        {activeView === 'dashboard' && (
          <div className="space-y-8">
            {/* Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {[
                { label: 'Total Revenue', value: '$45,231.89', trend: '+12.5%', icon: DollarSign, color: 'text-emerald-600' },
                { label: 'Total Orders', value: '1,284', trend: '+18.2%', icon: TrendingUp, color: 'text-indigo-600' },
                { label: 'Active Riders', value: '42', trend: '+3', icon: Bike, color: 'text-orange-600' },
                { label: 'Live Sessions', value: '256', trend: 'Stable', icon: Activity, color: 'text-slate-600' },
              ].map(stat => (
                <Card key={stat.label} className="p-6">
                  <div className="flex justify-between items-start mb-4">
                    <div className={`p-3 rounded-2xl bg-opacity-10 ${stat.color.replace('text', 'bg')}`}>
                      <stat.icon className={stat.color} size={24} />
                    </div>
                    <span className={`text-xs font-bold ${stat.trend.startsWith('+') ? 'text-emerald-600' : 'text-slate-500'}`}>
                      {stat.trend}
                    </span>
                  </div>
                  <h4 className="text-3xl font-black text-slate-900">{stat.value}</h4>
                  <p className="text-xs text-slate-400 font-bold uppercase tracking-wider mt-1">{stat.label}</p>
                </Card>
              ))}
            </div>

            {/* Charts */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
              <Card className="p-8">
                <div className="flex justify-between items-center mb-8">
                  <h3 className="text-xl font-bold">Revenue Dynamics</h3>
                  <Button variant="ghost" size="sm">Last 7 Days</Button>
                </div>
                <div className="h-80 w-full">
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={MOCK_DATA}>
                      <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                      <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} dy={10} />
                      <YAxis axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} />
                      <Tooltip 
                        contentStyle={{ borderRadius: '12px', border: 'none', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)' }}
                        cursor={{ fill: '#f8fafc' }}
                      />
                      <Bar dataKey="revenue" fill="#4f46e5" radius={[4, 4, 0, 0]} />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </Card>

              <Card className="p-8">
                <div className="flex justify-between items-center mb-8">
                  <h3 className="text-xl font-bold">Order Volume</h3>
                  <Button variant="ghost" size="sm">Monthly Growth</Button>
                </div>
                <div className="h-80 w-full">
                  <ResponsiveContainer width="100%" height="100%">
                    <LineChart data={MOCK_DATA}>
                      <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                      <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} dy={10} />
                      <YAxis axisLine={false} tickLine={false} tick={{fill: '#94a3b8', fontSize: 12}} />
                      <Tooltip />
                      <Line type="monotone" dataKey="orders" stroke="#f97316" strokeWidth={4} dot={{ r: 6, fill: '#f97316', strokeWidth: 2, stroke: '#fff' }} activeDot={{ r: 8 }} />
                    </LineChart>
                  </ResponsiveContainer>
                </div>
              </Card>
            </div>
          </div>
        )}

        {activeView === 'approvals' && (
          <div className="space-y-6">
            <h3 className="text-xl font-bold">Pending Approval Queue</h3>
            <div className="space-y-4">
              {[
                { name: 'Taco Palace', type: 'Restaurant', date: '2h ago', email: 'owner@tacos.com' },
                { name: 'Marco Rossi', type: 'Rider', date: '5h ago', email: 'm.rossi@email.com' },
                { name: 'Veggie Heaven', type: 'Restaurant', date: 'Yesterday', email: 'hi@veggie.com' },
              ].map((item, idx) => (
                <Card key={idx} className="p-6 flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 bg-slate-100 rounded-2xl flex items-center justify-center font-bold text-slate-500">
                      {item.name[0]}
                    </div>
                    <div>
                      <p className="font-bold">{item.name}</p>
                      <p className="text-xs text-slate-400">{item.type} • Submitted {item.date}</p>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button variant="outline" size="sm">View Details</Button>
                    <Button className="bg-emerald-600 hover:bg-emerald-700" size="sm">Approve</Button>
                  </div>
                </Card>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
