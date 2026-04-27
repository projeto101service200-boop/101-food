import 'package:flutter/material.dart';

class DeliveryRouteScreen extends StatelessWidget {
  const DeliveryRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mock Map Background
          Container(
            color: Colors.grey.shade100,
            child: CustomPaint(
              painter: MapPainter(),
              size: Size.infinite,
            ),
          ),
          
          // Current Action Info
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: const Row(
                      children: [
                         Icon(Icons.navigation, color: Colors.white, size: 32),
                         SizedBox(width: 16),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Vire à direita em 200m', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                               Text('Rua das Amoreiras', style: TextStyle(color: Colors.white70)),
                             ],
                           ),
                         ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Info Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Row(
                     children: [
                       const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.store, color: Colors.white)),
                       const SizedBox(width: 12),
                       const Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('Retirada: Enatega Burgers', style: TextStyle(fontWeight: FontWeight.bold)),
                             Text('Pedido #1025', style: TextStyle(color: Colors.grey, fontSize: 12)),
                           ],
                         ),
                       ),
                       TextButton(onPressed: () {}, child: const Text('DETALHES')),
                     ],
                   ),
                   const Divider(height: 32),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CHEGADA ESTIMADA', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                            Text('18:45 (8 min)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(140, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('CHEGUEI'),
                        ),
                     ],
                   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPath = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.2, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.5, size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width * 0.9, size.height * 0.3)
      ..lineTo(size.width * 0.9, 0);

    canvas.drawPath(roadPath, paint);

    // Current route progress
    final routePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPath = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.2, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.6, size.width * 0.3, size.height * 0.58);

    canvas.drawPath(progressPath, routePaint);

    // Rider Icon
    final riderPaint = Paint()..color = Colors.green;
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.58), 12, riderPaint);
    
    // Store Icon Position
    final storePaint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), 15, storePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
