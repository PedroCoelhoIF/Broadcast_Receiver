import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../viewmodels/battery_viewmodel.dart';

class BatteryMonitorView extends StatefulWidget {
  const BatteryMonitorView({super.key});

  @override
  State<BatteryMonitorView> createState() => _BatteryMonitorViewState();
}

class _BatteryMonitorViewState extends State<BatteryMonitorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Monitor de Bateria',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Consumer<BatteryViewModel>(
              builder: (context, vm, _) => Text(
                vm.isUsingBroadcastReceiver 
                    ? '📡 Broadcast Receiver Ativo' 
                    : '🔄 Modo Fallback',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<BatteryViewModel>(
        builder: (context, viewModel, child) {
          // Verifica se deve mostrar aviso de bateria baixa
          if (viewModel.shouldShowLowBatteryWarning()) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showLowBatterySnackBar();
            });
          }

          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.tealAccent),
            );
          }

          final battery = viewModel.batteryModel!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Círculo de bateria animado
                CustomPaint(
                  size: const Size(250, 250),
                  painter: BatteryCirclePainter(
                    level: battery.level,
                    color: battery.batteryColor,
                    isCharging: battery.isCharging,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Status da bateria
                Text(
                  battery.statusText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: battery.batteryColor,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Ícone de carregamento
                if (battery.isCharging)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt,
                        color: Colors.yellow.shade700,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Em carregamento',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 60),
                
                
                ElevatedButton.icon(
                  onPressed: _openGitHub,
                  icon: const Icon(Icons.code, size: 24),
                  label: const Text(
                    'GitHub',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent.shade700,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLowBatterySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.battery_alert, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '⚠️ Bateria Baixa!\nNível abaixo de 20%. Conecte o carregador.',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _openGitHub() async {
    final url = Uri.parse('https://github.com/PedroCoelhoIF');
    try {
      final canLaunch = await canLaunchUrl(url);
      if (canLaunch) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir o GitHub: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Painter customizado para desenhar o círculo de bateria
class BatteryCirclePainter extends CustomPainter {
  final int level;
  final Color color;
  final bool isCharging;

  BatteryCirclePainter({
    required this.level,
    required this.color,
    required this.isCharging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Círculo de fundo (cinza)
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Círculo de progresso
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (level / 100) * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, 
      sweepAngle,
      false,
      progressPaint,
    );

    // Texto do nível de bateria
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$level%',
        style: TextStyle(
          color: color,
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    // Ícone de raio se estiver carregando
    if (isCharging) {
      final iconPainter = TextPainter(
        text: TextSpan(
          text: '⚡',
          style: TextStyle(
            fontSize: 40,
            color: Colors.yellow.shade700,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          center.dx - iconPainter.width / 2,
          center.dy + 40,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(BatteryCirclePainter oldDelegate) {
    return oldDelegate.level != level || 
           oldDelegate.color != color ||
           oldDelegate.isCharging != isCharging;
  }
}