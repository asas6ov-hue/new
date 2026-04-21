import 'dart:math';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// خدمة البوصلة لحساب اتجاه القبلة باستخدام مستشعر المغناطيسية (Magnetometer)
class QiblaService {
  static final QiblaService _instance = QiblaService._internal();
  factory QiblaService() => _instance;
  QiblaService._internal();

  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  double _heading = 0.0; // الاتجاه الحالي بالدرجات
  bool _isListening = false;

  /// الحصول على الاتجاه الحالي
  double get heading => _heading;

  /// هل الخدمة تعمل حالياً؟
  bool get isListening => _isListening;

  /// بدء الاستماع لمستشعر المغناطيسية
  void startListening(Function(double heading) onHeadingChanged) {
    if (_isListening) return;

    _magnetometerSubscription = magnetometerEvents.listen((event) {
      // حساب الزاوية من قيم المحاور X و Y
      double heading = atan2(event.y, event.x) * (180 / pi);
      
      // تحويل الزاوية لتكون موجبة (0-360)
      if (heading < 0) {
        heading += 360;
      }

      _heading = heading;
      onHeadingChanged(_heading);
    });

    _isListening = true;
  }

  /// إيقاف الاستماع للمستشعر
  void stopListening() {
    if (!_isListening) return;

    _magnetometerSubscription?.cancel();
    _magnetometerSubscription = null;
    _isListening = false;
  }

  /// حساب زاوية القبلة بناءً على موقع المستخدم
  /// [latitude] خط العرض للمستخدم
  /// [longitude] خط الطول للمستخدم
  /// الإرجاع: زاوية القبلة بالدرجات (من الشمال)
  static double calculateQiblaDirection(double latitude, double longitude) {
    // إحداثيات الكعبة المشرفة
    const double kabaLat = 21.422487;
    const double kabaLng = 39.826206;

    double dLon = (kabaLng - longitude) * (pi / 180);
    double lat1 = latitude * (pi / 180);
    double lat2 = kabaLat * (pi / 180);

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    
    double qibla = atan2(y, x) * (180 / pi);
    
    // تحويل الزاوية لتكون موجبة (0-360)
    if (qibla < 0) {
      qibla += 360;
    }

    return qibla;
  }

  /// حساب الفرق بين اتجاه الهاتف والقبلة
  /// [userHeading] اتجاه الهاتف الحالي
  /// [qiblaDirection] اتجاه القبلة
  /// الإرجاع: الفرق بالدرجات (-180 إلى 180)
  static double calculateQiblaOffset(double userHeading, double qiblaDirection) {
    double offset = qiblaDirection - userHeading;
    
    // تطبيع الزاوية لتكون بين -180 و 180
    while (offset > 180) offset -= 360;
    while (offset < -180) offset += 360;
    
    return offset;
  }

  /// التحقق مما إذا كان المستخدم متجهاً نحو القبلة بدقة معينة
  /// [tolerance] هامش الخطأ المسموح به بالدرجات (افتراضياً 5 درجات)
  bool isFacingQibla(double qiblaDirection, {double tolerance = 5.0}) {
    double offset = calculateQiblaOffset(_heading, qiblaDirection);
    return offset.abs() <= tolerance;
  }
}
