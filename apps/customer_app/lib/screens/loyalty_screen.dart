import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fidelidade Velox')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildPointsCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('Como Funciona'),
            const SizedBox(height: 16),
            _buildBenefitItem(Icons.star, 'Ganhe 1 ponto a cada R\$ 1,00 gasto.'),
            _buildBenefitItem(Icons.redeem, 'Troque pontos por descontos ou itens grátis.'),
            _buildBenefitItem(Icons.celebration, 'Bônus em datas especiais.'),
            const SizedBox(height: 32),
            _buildSectionHeader('Recompensas Disponíveis'),
            const SizedBox(height: 16),
            _buildRewardTile('Copa Burger Grátis', '500 pts', true),
            _buildRewardTile('R\$ 10,00 de Desconto', '200 pts', false),
            _buildRewardTile('Batata Frita Média', '150 pts', false),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFFFFAB40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: const Column(
        children: [
          Text('MEUS PONTOS', style: TextStyle(color: Colors.white, letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 12)),
          SizedBox(height: 8),
          Text('450', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Você está a 50 pts de um Burger grátis!', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildRewardTile(String title, String points, bool canRedeem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(points, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            onPressed: canRedeem ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canRedeem ? AppTheme.primaryColor : Colors.grey.shade200,
              foregroundColor: canRedeem ? Colors.white : Colors.grey,
              elevation: 0,
            ),
            child: const Text('RESGATAR'),
          ),
        ],
      ),
    );
  }
}
