import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qibla_provider.dart';
import 'dart:math' as math;

/// شاشة البوصلة التفاعلية للقبلة
class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({Key? key}) : super(key: key);

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QiblaProvider>(context, listen: false);
      provider.getUserLocation();
      provider.startListening();
    });
  }

  @override
  void dispose() {
    final provider = Provider.of<QiblaProvider>(context, listen: false);
    provider.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Consumer<QiblaProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.getUserLocation();
                        provider.startListening();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!provider.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('جاري تحديد اتجاه القبلة...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // البوصلة الدائرية
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green[700]!, width: 4),
                    gradient: RadialGradient(
                      colors: [
                        Colors.green[50]!,
                        Colors.green[100]!,
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // الاتجاهات الأربعة
                      ..._buildDirections(),
                      
                      // دائرة البوصلة الداخلية
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      
                      // سهم القبلة
                      Transform.rotate(
                        angle: (provider.qiblaDirection! * math.pi / 180),
                        child: Container(
                          width: 4,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.place,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                      ),
                      
                      // مؤشر اتجاه الهاتف الحالي
                      if (provider.phoneDirection != null)
                        Transform.rotate(
                          angle: (provider.phoneDirection! * math.pi / 180),
                          child: Container(
                            width: 3,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.red[700],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.red[700],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                        ),
                      
                      // المركز
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // معلومات الاتجاه
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'اتجاه القبلة',
                          '${provider.qiblaDirection!.toStringAsFixed(1)}°',
                          Icons.location_on,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'اتجاه هاتفك',
                          '${provider.phoneDirection?.toStringAsFixed(1) ?? '--'}°',
                          Icons.smartphone,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'الانحراف',
                          '${provider.qiblaOffset?.toStringAsFixed(1) ?? '--'}°',
                          Icons.explore,
                          valueColor: _getOffsetColor(provider.qiblaOffset),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // رسالة التوجيه
                if (provider.isFacingQibla)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[700]!, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'أنت متجه نحو القبلة!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (provider.qiblaOffset != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[700]!, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getDirectionHint(provider.qiblaOffset!),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // زر التحديث
                ElevatedButton.icon(
                  onPressed: () {
                    provider.getUserLocation();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث الموقع'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Text(
                  'ملاحظة: قم بتحريك هاتفك بشكل رقم 8 لمعايرة البوصلة',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildDirections() {
    return [
      _buildDirectionLabel('N', -math.pi / 2),
      _buildDirectionLabel('S', math.pi / 2),
      _buildDirectionLabel('E', 0),
      _buildDirectionLabel('W', math.pi),
    ];
  }

  Widget _buildDirectionLabel(String text, double angle) {
    return Positioned.fill(
      child: Transform.rotate(
        angle: angle,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green[700]),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getOffsetColor(double? offset) {
    if (offset == null) return Colors.black87;
    if (offset.abs() <= 5) return Colors.green[700]!;
    if (offset.abs() <= 15) return Colors.orange[700]!;
    return Colors.red[700]!;
  }

  String _getDirectionHint(double offset) {
    if (offset > 0) {
      return 'در لليسار ${offset.abs().toStringAsFixed(0)} درجة';
    } else {
      return 'در لليمين ${offset.abs().toStringAsFixed(0)} درجة';
    }
  }
}
