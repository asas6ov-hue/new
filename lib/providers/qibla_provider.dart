import 'package:flutter/foundation.dart';
import 'dart:math' as math;

/// مزود حالة البوصلة والقبلة
class QiblaProvider with ChangeNotifier {
  double? _userLatitude;
  double? _userLongitude;
  double? _phoneDirection;
  double? _qiblaDirection;
  double? _qiblaOffset;
  bool _isListening = false;
  String? _error;

  // Getters
  double? get userLatitude => _userLatitude;
  double? get userLongitude => _userLongitude;
  double? get phoneDirection => _phoneDirection;
  double? get qiblaDirection => _qiblaDirection;
  double? get qiblaOffset => _qiblaOffset;
  bool get isListening => _isListening;
  String? get error => _error;
  bool get hasData => _phoneDirection != null && _qiblaDirection != null;
  bool get isFacingQibla => hasData && (_qiblaOffset?.abs() ?? 999) <= 5.0;

  /// تحديد موقع المستخدم وحساب اتجاه القبلة
  Future<void> getUserLocation() async {
    try {
      _error = null;
      notifyListeners();

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'خدمة الموقع غير مفعلة';
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'تم رفض إذن الموقع';
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'تم رفض إذن الموقع بشكل دائم';
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _userLatitude = position.latitude;
      _userLongitude = position.longitude;

      // حساب اتجاه القبلة بناءً على الموقع
      _qiblaDirection = _calculateQiblaDirection(
        _userLatitude!,
        _userLongitude!,
      );

      // تحديث الانحراف
      if (_phoneDirection != null) {
        _updateQiblaOffset();
      }

      notifyListeners();
    } catch (e) {
      _error = 'خطأ في تحديد الموقع: ${e.toString()}';
      notifyListeners();
    }
  }

  /// بدء الاستماع لمستشعر المغناطيسية
  void startListening() {
    if (_isListening) return;

    _isListening = true;
    notifyListeners();

    magnetometerEvents.listen((MagnetometerEvent event) {
      // حساب اتجاه الهاتف من بيانات المغناطيسية
      final heading = _calculateHeading(event);
      
      _phoneDirection = (heading + 360) % 360;

      // تحديث انحراف القبلة
      _updateQiblaOffset();

      notifyListeners();
    }, onError: (error) {
      _error = 'خطأ في المستشعر: ${error.toString()}';
      _isListening = false;
      notifyListeners();
    });
  }

  /// إيقاف الاستماع للمستشعر
  void stopListening() {
    _isListening = false;
    notifyListeners();
  }

  /// تحديث انحراف القبلة
  void _updateQiblaOffset() {
    if (_phoneDirection != null && _qiblaDirection != null) {
      _qiblaOffset = _calculateQiblaOffset(
        _phoneDirection!,
        _qiblaDirection!,
      );
    }
  }

  /// حساب اتجاه القبلة
  double _calculateQiblaDirection(double userLatitude, double userLongitude) {
    const double kaabaLatitude = 21.4225;
    const double kaabaLongitude = 39.8262;

    final double lat1 = userLatitude * math.pi / 180;
    final double lon1 = userLongitude * math.pi / 180;
    final double lat2 = kaabaLatitude * math.pi / 180;
    final double lon2 = kaabaLongitude * math.pi / 180;

    final double deltaLon = lon2 - lon1;

    final double y = math.sin(deltaLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

    double qiblaAngle = math.atan2(y, x) * 180 / math.pi;
    qiblaAngle = (qiblaAngle + 360) % 360;

    return qiblaAngle;
  }

  /// حساب الفرق بين اتجاه الهاتف والقبلة
  double _calculateQiblaOffset(double phoneDirection, double qiblaDirection) {
    double offset = qiblaDirection - phoneDirection;

    while (offset > 180) {
      offset -= 360;
    }
    while (offset < -180) {
      offset += 360;
    }

    return offset;
  }

  /// حساب الاتجاه من بيانات المغناطيسية
  double _calculateHeading(MagnetometerEvent event) {
    return math.atan2(event.y, event.x) * 180 / math.pi;
  }
}
