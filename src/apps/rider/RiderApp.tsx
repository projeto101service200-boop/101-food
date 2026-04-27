import { useState } from 'react';
import { Bike, Map as MapIcon, DollarSign, History, Power, Navigation, Phone, MessageSquare, CheckCircle } from 'lucide-react';
import { motion } from 'motion/react';
import { Button, Card } from '../../packages/shared/components';

export function RiderApp() {
  const [isOnline, setIsOnline] = useState(false);
  const [activeDelivery, setActiveDelivery] = useState<any>(null);

  const MOCK_REQUEST = {
    id: 'R77',
    restaurant: 'Burger Queen',
    distance: '1.2 km',
    earning: 4.50,
    address: '456 Delivery Ave, Apt 4B'
  };

  return (
    <div className="bg-slate-900 min-h-screen text-white font-sans max-w-md mx-auto shadow-2xl relative overflow-hidden">
      {/* Background "Map" visual */}
      <div className="absolute inset-0 opacity-20 pointer-events-none">
        <div className="w-full h-full bg-[linear-gradient(rgba(255,255,255,0.1)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.1)_1px,transparent_1px)] bg-[size:40px_40px]"></div>
      </div>

      <header className="p-6 relative z-10 flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-bold">Hello, Alex</h2>
          <p className="text-slate-400 text-sm">Rider #4492</p>
        </div>
        <button 
          onClick={() => setIsOnline(!isOnline)}
          className={`flex items-center gap-2 px-4 py-2 rounded-full font-bold transition-all ${isOnline ? 'bg-emerald-500 text-white shadow-[0_0_20px_rgba(16,185,129,0.4)]' : 'bg-slate-800 text-slate-400'}`}
        >
          <Power size={18} />
          {isOnline ? 'ONLINE' : 'OFFLINE'}
        </button>
      </header>

      <div className="px-6 grid grid-cols-2 gap-4 mt-4 relative z-10">
        <Card className="bg-slate-800 border-slate-700 p-4 text-white">
          <p className="text-xs text-slate-400 uppercase font-bold tracking-wider">Today's Earnings</p>
          <div className="flex items-end gap-1 mt-2">
            <span className="text-2xl font-bold">$124.50</span>
            <span className="text-xs text-emerald-400 pb-1">+12%</span>
          </div>
        </Card>
        <Card className="bg-slate-800 border-slate-700 p-4 text-white">
          <p className="text-xs text-slate-400 uppercase font-bold tracking-wider">Deliveries</p>
          <div className="flex items-end gap-1 mt-2">
            <span className="text-2xl font-bold">18</span>
            <span className="text-xs text-slate-500 pb-1">Target: 20</span>
          </div>
        </Card>
      </div>

      <div className="p-6 mt-8 relative z-10">
        {!isOnline ? (
          <div className="text-center py-20">
            <div className="w-20 h-20 bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-4">
               <Bike size={32} className="text-slate-600" />
            </div>
            <h3 className="text-xl font-bold">You are currently offline</h3>
            <p className="text-slate-400 mt-2">Go online to start receiving delivery requests.</p>
          </div>
        ) : !activeDelivery ? (
          <motion.div
            initial={{ y: 50, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            className="bg-white text-slate-900 rounded-3xl p-6 shadow-2xl"
          >
            <div className="flex justify-between items-start mb-6">
              <div>
                <span className="bg-orange-100 text-orange-600 text-[10px] font-bold px-2 py-1 rounded-full uppercase tracking-widest">New Request</span>
                <h3 className="text-2xl font-bold mt-2">{MOCK_REQUEST.restaurant}</h3>
                <p className="text-slate-500 text-sm">{MOCK_REQUEST.distance} away from you</p>
              </div>
              <div className="bg-emerald-100 text-emerald-700 p-3 rounded-2xl text-center">
                 <p className="text-xs font-bold">Earning</p>
                 <p className="text-xl font-black">${MOCK_REQUEST.earning}</p>
              </div>
            </div>

            <div className="space-y-4 mb-8">
               <div className="flex gap-4">
                  <div className="flex flex-col items-center gap-1">
                    <div className="w-3 h-3 bg-orange-500 rounded-full"></div>
                    <div className="w-0.5 h-6 bg-slate-200"></div>
                    <div className="w-3 h-3 border-2 border-slate-300 rounded-full"></div>
                  </div>
                  <div className="flex-1 space-y-4">
                    <p className="text-sm font-semibold">{MOCK_REQUEST.restaurant} (Pickup)</p>
                    <p className="text-sm font-semibold text-slate-500">{MOCK_REQUEST.address} (Delivery)</p>
                  </div>
               </div>
            </div>

            <div className="flex gap-4">
              <Button variant="outline" className="flex-1 border-slate-200" size="lg">Ignorar</Button>
              <Button className="flex-1 bg-emerald-600 hover:bg-emerald-700" size="lg" onClick={() => setActiveDelivery(MOCK_REQUEST)}>ACEITAR</Button>
            </div>
          </motion.div>
        ) : (
          <div className="space-y-6">
             <div className="flex items-center justify-between">
                <h3 className="text-xl font-bold flex items-center gap-2">
                  <Navigation size={20} className="text-emerald-400" /> Going to Restaurant
                </h3>
                <span className="text-emerald-400 animate-pulse font-mono">Live</span>
             </div>

             <Card className="bg-slate-800 border-slate-700 p-0 overflow-hidden text-white">
                <div className="p-4 bg-slate-700/50 flex justify-between items-center">
                   <div>
                     <p className="text-xs text-slate-400">Order ID</p>
                     <p className="font-bold">#R77092</p>
                   </div>
                   <div className="flex gap-2">
                      <Button size="sm" variant="outline" className="bg-slate-800 border-slate-600"><Phone size={14}/></Button>
                      <Button size="sm" variant="outline" className="bg-slate-800 border-slate-600"><MessageSquare size={14}/></Button>
                   </div>
                </div>
                <div className="p-4">
                   <p className="text-sm font-medium mb-1">Pick up at</p>
                   <p className="text-lg font-bold text-orange-400">Burger Queen - Downtown</p>
                   <p className="text-sm text-slate-400 mt-2 italic">"Ask for Order #77 at the counter"</p>
                </div>
                <div className="p-4 border-t border-slate-700">
                  <Button className="w-full bg-orange-500 hover:bg-orange-600" size="lg" onClick={() => {}}>
                    I HAVE ARRIVED AT RESTAURANT
                  </Button>
                </div>
             </Card>
             
             <Button variant="ghost" className="w-full text-slate-500 text-sm" onClick={() => setActiveDelivery(null)}>
                Cancel Request (Penalty may apply)
             </Button>
          </div>
        )}
      </div>

      {/* Persistent Bottom Stats for Rider */}
      <div className="absolute bottom-6 left-6 right-6 flex justify-around p-4 bg-slate-800 rounded-2xl border border-slate-700 shadow-2xl">
         <div className="text-center">
            <History size={20} className="mx-auto text-slate-400 mb-1" />
            <span className="text-[10px] text-slate-500 uppercase font-bold">History</span>
         </div>
         <div className="text-center">
            <MapIcon size={20} className="mx-auto text-emerald-400 mb-1" />
            <span className="text-[10px] text-emerald-400 uppercase font-bold">Live Map</span>
         </div>
         <div className="text-center">
            <DollarSign size={20} className="mx-auto text-slate-400 mb-1" />
            <span className="text-[10px] text-slate-500 uppercase font-bold">Wallet</span>
         </div>
      </div>
    </div>
  );
}
