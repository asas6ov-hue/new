import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/qibla_service.dart';

/// Provider لإدارة حالة البوصلة والقبلة
class QiblaProvider with ChangeNotifier {
  final QiblaService _qiblaService = QiblaService();
  
  double _currentHeading = 0.0; // اتجاه الهاتف الحالي
  double _qiblaDirection = 0.0; // اتجاه القبلة
  double _qiblaOffset = 0.0; // الفرق بين الاتجاه والقبلة
  bool _isListening = false;
  bool _isFacingQibla = false;
  
  // Getter
  double get currentHeading => _currentHeading;
  double get qiblaDirection => _qiblaDirection;
  double get qiblaOffset => _qiblaOffset;
  bool get isListening => _isListening;
  bool get isFacingQibla => _isFacingQibla;
  
  /// بدء الاستماع للبوصلة
  void startCompass() {
    if (_isListening) return;
    
    _qiblaService.startListening((heading) {
      _currentHeading = heading;
      _updateQiblaOffset();
      notifyListeners();
    });
    
    _isListening = true;
    notifyListeners();
  }
  
  /// إيقاف الاستماع للبوصلة
  void stopCompass() {
    if (!_isListening) return;
    
    _qiblaService.stopListening();
    _isListening = false;
    notifyListeners();
  }
  
  /// تحديث اتجاه القبلة بناءً على موقع المستخدم
  void updateQiblaDirection(double latitude, double longitude) {
    _qiblaDirection = QiblaService.calculateQiblaDirection(latitude, longitude);
    _updateQiblaOffset();
    notifyListeners();
  }
  
  /// تحديث حساب الفرق بين الاتجاه والقبلة
  void _updateQiblaOffset() {
    _qiblaOffset = QiblaService.calculateQiblaOffset(_currentHeading, _qiblaDirection);
    _isFacingQibla = _qiblaService.isFacingQibla(_qiblaDirection);
  }
  
  @override
  void dispose() {
    stopCompass();
    super.dispose();
  }
}
