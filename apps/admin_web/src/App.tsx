import React from 'react';
import { 
  LayoutDashboard, 
  Store, 
  Bike, 
  Users, 
  Settings, 
  ShoppingBag,
  TrendingUp,
  AlertCircle
} from 'lucide-react';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  LineChart,
  Line
} from 'recharts';

const data = [
  { name: 'Seg', total: 4000, orders: 240 },
  { name: 'Ter', total: 3000, orders: 198 },
  { name: 'Qua', total: 2000, orders: 150 },
  { name: 'Qui', total: 2780, orders: 190 },
  { name: 'Sex', total: 1890, orders: 180 },
  { name: 'Sáb', total: 2390, orders: 250 },
  { name: 'Dom', total: 3490, orders: 310 },
];

function App() {
  return (
    <div className="flex h-screen bg-gray-50">
      {/* Sidebar */}
      <aside className="w-64 bg-slate-900 text-white p-6">
        <h1 className="text-2xl font-bold mb-10 text-orange-500">Velox Admin</h1>
        <nav className="space-y-4">
          <SidebarLink icon={<LayoutDashboard size={20} />} label="Dashboard" active />
          <SidebarLink icon={<Store size={20} />} label="Restaurantes" />
          <SidebarLink icon={<Bike size={20} />} label="Entregadores" />
          <SidebarLink icon={<ShoppingBag size={20} />} label="Pedidos" />
          <SidebarLink icon={<Users size={20} />} label="Usuários" />
          <SidebarLink icon={<Settings size={20} />} label="Configurações" />
        </nav>
      </aside>

      {/* Main Content */}
      <main className="flex-1 overflow-y-auto p-10">
        <header className="flex justify-between items-center mb-10">
          <h2 className="text-3xl font-bold text-gray-800">Visão Geral</h2>
          <div className="flex gap-4">
            <button className="bg-white px-4 py-2 rounded-lg border text-sm font-medium">Exportar Relatório</button>
            <button className="bg-orange-600 text-white px-4 py-2 rounded-lg text-sm font-medium">Filtros</button>
          </div>
        </header>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
          <StatCard title="Vendas Mensais" value="R$ 124.500" change="+12.5%" icon={<TrendingUp className="text-green-500" />} />
          <StatCard title="Total de Pedidos" value="1.240" change="+8.2%" icon={<ShoppingBag className="text-blue-500" />} />
          <StatCard title="Novos Vendors" value="12" change="+3" icon={<Store className="text-purple-500" />} />
          <StatCard title="Pendentes de Aprovação" value="7" change="-2" icon={<AlertCircle className="text-orange-500" />} />
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
          <div className="bg-white p-6 rounded-xl shadow-sm border">
            <h3 className="text-lg font-bold mb-6">Receita Semanal</h3>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={data}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="name" />
                  <YAxis />
                  <Tooltip />
                  <Bar dataKey="total" fill="#f97316" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>

          <div className="bg-white p-6 rounded-xl shadow-sm border">
            <h3 className="text-lg font-bold mb-6">Volume de Pedidos</h3>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={data}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="name" />
                  <YAxis />
                  <Tooltip />
                  <Line type="monotone" dataKey="orders" stroke="#3b82f6" strokeWidth={3} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

function SidebarLink({ icon, label, active = false }: { icon: React.ReactNode, label: string, active?: boolean }) {
  return (
    <a href="#" className={`flex items-center gap-3 p-3 rounded-lg transition-colors ${active ? 'bg-orange-600 text-white' : 'hover:bg-slate-800 text-slate-400'}`}>
      {icon}
      <span className="font-medium">{label}</span>
    </a>
  );
}

function StatCard({ title, value, change, icon }: { title: string, value: string, change: string, icon: React.ReactNode }) {
  const isPositive = change.startsWith('+');
  return (
    <div className="bg-white p-6 rounded-xl shadow-sm border">
      <div className="flex justify-between items-start mb-4">
        <span className="text-sm text-gray-500 font-medium">{title}</span>
        {icon}
      </div>
      <div className="flex items-end gap-2">
        <span className="text-2xl font-bold">{value}</span>
        <span className={`text-xs font-bold mb-1 ${isPositive ? 'text-green-500' : 'text-red-500'}`}>{change}</span>
      </div>
    </div>
  );
}

export default App;
