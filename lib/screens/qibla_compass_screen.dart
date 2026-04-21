import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../providers/qibla_provider.dart';

/// واجهة بوصلة القبلة التفاعلية
class QiblaCompassScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const QiblaCompassScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen>
    with SingleTickerProviderStateMixin {
  late QiblaProvider _qiblaProvider;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _qiblaProvider = Provider.of<QiblaProvider>(context, listen: false);
    
    // تحديث اتجاه القبلة بناءً على الموقع
    _qiblaProvider.updateQiblaDirection(widget.latitude, widget.longitude);
    
    // بدء البوصلة
    _qiblaProvider.startCompass();
  }

  @override
  void dispose() {
    _qiblaProvider.stopCompass();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Consumer<QiblaProvider>(
        builder: (context, qiblaProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // بوصلة القبلة
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.teal[700]!, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // خلفية البوصلة مع الاتجاهات
                      Transform.rotate(
                        angle: -qiblaProvider.currentHeading * math.pi / 180,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDirectionLabel('N', Colors.red),
                            const SizedBox(height: 60),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildDirectionLabel('W', Colors.black54),
                                const SizedBox(width: 60),
                                _buildDirectionLabel('E', Colors.black54),
                              ],
                            ),
                            const SizedBox(height: 60),
                            _buildDirectionLabel('S', Colors.black54),
                          ],
                        ),
                      ),
                      
                      // سهم القبلة
                      Transform.rotate(
                        angle: qiblaProvider.qiblaDirection * math.pi / 180,
                        child: Icon(
                          Icons.navigation,
                          size: 80,
                          color: qiblaProvider.isFacingQibla 
                              ? Colors.green 
                              : Colors.orange,
                        ),
                      ),
                      
                      // مؤشر الهاتف (السهم الأحمر في الأعلى)
                      Transform.rotate(
                        angle: qiblaProvider.currentHeading * math.pi / 180,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 40,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      
                      // مركز البوصلة
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // معلومات الاتجاه
                Text(
                  'اتجاهك الحالي: ${qiblaProvider.currentHeading.toStringAsFixed(1)}°',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'اتجاه القبلة: ${qiblaProvider.qiblaDirection.toStringAsFixed(1)}°',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'الانحراف: ${qiblaProvider.qiblaOffset.toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontSize: 16,
                    color: qiblaProvider.qiblaOffset.abs() < 5 
                        ? Colors.green 
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // حالة التوجيه للقبلة
                if (qiblaProvider.isFacingQibla)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'أنت متجه نحو القبلة ✓',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'درّب هاتفك لتتجه نحو القبلة',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDirectionLabel(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
