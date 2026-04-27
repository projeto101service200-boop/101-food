import 'package:flutter/material.dart';

class SplitBillScreen extends StatefulWidget {
  final int tableNumber;
  final double totalAmount;
  const SplitBillScreen({super.key, required this.tableNumber, required this.totalAmount});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  int _parts = 2;
  double _customAmount = 0;
  bool _isEqualSplit = true;

  @override
  void initState() {
    super.initState();
    _customAmount = widget.totalAmount / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dividir Conta - Mesa ${widget.tableNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                   const Text('VALOR TOTAL', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                   Text('R\$ ${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('FORMA DE DIVISÃO', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTypeButton('IGUALMENTE', _isEqualSplit, () => setState(() => _isEqualSplit = true)),
                const SizedBox(width: 12),
                _buildTypeButton('VALOR PARCIAL', !_isEqualSplit, () => setState(() => _isEqualSplit = false)),
              ],
            ),
            const SizedBox(height: 32),
            if (_isEqualSplit) 
              _buildEqualSplit()
            else 
              _buildPartialSplit(),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pagamento processado com sucesso!'))
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text(_isEqualSplit ? 'RECEBER R\$ ${(widget.totalAmount/_parts).toStringAsFixed(2)} (1/$_parts)' : 'RECEBER R\$ ${_customAmount.toStringAsFixed(2)}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.white,
            border: Border.all(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.white : Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildEqualSplit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Número de Pessoas'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _countButton(Icons.remove, () => setState(() => _parts = _parts > 1 ? _parts - 1 : 1)),
            Text('$_parts', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            _countButton(Icons.add, () => setState(() => _parts++)),
          ],
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        _rowInfo('Valor por Pessoa', 'R\$ ${(widget.totalAmount/_parts).toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildPartialSplit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quanto o cliente vai pagar agora?'),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: 'R\$ ',
            border: OutlineInputBorder(),
          ),
          onChanged: (val) {
             setState(() {
               _customAmount = double.tryParse(val) ?? 0;
             });
          },
        ),
        const SizedBox(height: 16),
        _rowInfo('Restante após pagamento', 'R\$ ${(widget.totalAmount - _customAmount).toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _rowInfo(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget _countButton(IconData icon, VoidCallback onTap) {
    return IconButton.filled(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(backgroundColor: Colors.deepPurple.shade100, foregroundColor: Colors.deepPurple),
    );
  }
}
