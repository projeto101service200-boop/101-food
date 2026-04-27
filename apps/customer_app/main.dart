// Este é o arquivo inicial para o App Cliente em Flutter.
// Ele será preenchido gradualmente conforme o desenvolvimento avança.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/theme/app_theme.dart';
import 'lib/screens/restaurant_menu_screen.dart';
import 'lib/screens/product_detail_screen.dart';
import 'lib/screens/checkout_screen.dart';
import 'lib/screens/dine_in_scanner_screen.dart';
import 'lib/widgets/restaurant_card.dart';
import 'lib/providers/service_providers.dart';

void main() {
  runApp(const ProviderScope(child: CustomerApp()));
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velox Delivery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/tracking': (context) => const TrackingScreen(),
        '/dine-in': (context) => const DineInScannerScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/menu') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => RestaurantMenuScreen(restaurantName: args['name']),
          );
        }
        if (settings.name == '/product-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productName: args['name'],
              basePrice: args['price'],
            ),
          );
        }
        return null;
      },
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo ao Velox',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Entre para continuar',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'exemplo@email.com',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                hintText: '********',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('ENTRAR'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navegar para Registro
                },
                child: const Text('Não tem uma conta? Cadastre-se'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      // Por enquanto, logar anonimamente ou apenas navegar para simular
      // No futuro usaremos _emailController e _passwordController
      await ref.read(authServiceProvider).signInAnonymously();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao entrar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isDineIn = args?['type'] == 'DINE_IN';

    return Scaffold(
      appBar: AppBar(title: Text(isDineIn ? 'Pedido em Preparo' : 'Acompanhando Pedido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDineIn ? Icons.restaurant : Icons.delivery_dining, 
              size: 80, 
              color: AppTheme.primaryColor
            ),
            const SizedBox(height: 16),
            Text(
              isDineIn 
                ? 'Seu pedido foi enviado para a cozinha!' 
                : 'Seu pedido está sendo preparado!', 
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            if (isDineIn) ...[
              const SizedBox(height: 8),
              const Text('Aguarde na Mesa 05. Traremos tudo em breve.', style: TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                // Simular chamado de garçom
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Garçom notificado! Já estamos indo até você.'))
                );
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('CHAMAR GARÇOM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
              child: const Text('VOLTAR PARA HOME'),
            ),
          ],
        ),
      ),
    );
  }
}


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ENTREGAR EM', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, letterSpacing: 1.2)),
            const Row(
              children: [
                Text('Sua Localização', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'O que você quer comer hoje?',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Dine-In Banner Shortcut
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/dine-in'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.black, Colors.grey]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estou no Restaurante', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Peça direto da mesa via QR Code', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Promotion Banner Placeholder
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('VELOX OFFERS', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('Até 50% de DESCONTO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(minimumSize: const Size(100, 36)),
                          child: const Text('APROVEITAR', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('RESTAURANTES PRÓXIMOS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            
            // Restaurant List Dynamic
            restaurantsAsync.when(
              data: (restaurants) {
                if (restaurants.isEmpty) {
                  return const Center(child: Text('Nenhum restaurante encontrado.'));
                }
                return Column(
                  children: restaurants.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return RestaurantCard(
                      name: data['name'] ?? 'Sem Nome',
                      category: data['category'] ?? 'Diversos',
                      rating: (data['rating'] ?? 0.0).toDouble(),
                      deliveryTime: data['deliveryTime'] ?? '30-40 min',
                      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
                      onTap: () => Navigator.pushNamed(
                        context, 
                        '/menu', 
                        arguments: {
                          'id': doc.id,
                          'name': data['name'],
                        }
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erro ao carregar: $err')),
            ),
          ],
        ),
      ),
    );
  }
}
