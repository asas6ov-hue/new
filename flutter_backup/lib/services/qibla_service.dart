import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

/// خدمة البوصلة لحساب اتجاه القبلة باستخدام مستشعر المغناطيسية
class QiblaService {
  // إحداثيات الكعبة المشرفة
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// الاستماع لتغيرات مستشعر المغناطيسية
  Stream<MagnetometerEvent> get magnetometerStream =>
      magnetometerEvents;

  /// حساب اتجاه القبلة بناءً على موقع المستخدم
  /// Returns: زاوية القبلة بالدرجات من الشمال (0-360)
  static double calculateQiblaDirection(
    double userLatitude,
    double userLongitude,
  ) {
    final double lat1 = _toRadians(userLatitude);
    final double lon1 = _toRadians(userLongitude);
    final double lat2 = _toRadians(kaabaLatitude);
    final double lon2 = _toRadians(kaabaLongitude);

    final double deltaLon = lon2 - lon1;

    final double y = sin(deltaLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) -
        sin(lat1) * cos(lat2) * cos(deltaLon);

    double qiblaAngle = _toDegrees(atan2(y, x));

    // تحويل الزاوية لتكون من الشمال باتجاه عقارب الساعة
    qiblaAngle = (qiblaAngle + 360) % 360;

    return qiblaAngle;
  }

  /// حساب الفرق بين اتجاه الهاتف والقبلة
  /// Returns: الفرق بالدرجات (-180 إلى 180)
  static double calculateQiblaOffset(
    double phoneDirection,
    double qiblaDirection,
  ) {
    double offset = qiblaDirection - phoneDirection;

    // تطبيع الزاوية لتكون بين -180 و 180
    while (offset > 180) {
      offset -= 360;
    }
    while (offset < -180) {
      offset += 360;
    }

    return offset;
  }

  /// التحقق مما إذا كان المستخدم متجهاً نحو القبلة
  static bool isFacingQibla(
    double phoneDirection,
    double qiblaDirection, {
    double tolerance = 5.0,
  }) {
    final offset = calculateQiblaOffset(phoneDirection, qiblaDirection);
    return offset.abs() <= tolerance;
  }

  /// تحويل الدرجات إلى راديان
  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// تحويل الراديان إلى درجات
  static double _toDegrees(double radians) {
    return radians * 180 / pi;
  }
}
