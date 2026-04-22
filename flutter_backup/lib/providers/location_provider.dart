import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  double? _latitude;
  double? _longitude;
  String? _city;
  String? _country;
  bool _isLocationSet = false;
  bool _isLoading = false;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get city => _city;
  String? get country => _country;
  bool get isLocationSet => _isLocationSet;
  bool get isLoading => _isLoading;

  Future<void> setLocation(double lat, double lng, [String? city, String? country]) async {
    _latitude = lat;
    _longitude = lng;
    _city = city;
    _country = country;
    _isLocationSet = true;
    notifyListeners();
  }

  Future<void> detectCurrentLocation() async {
    _isLoading = true;
    notifyListeners();
    
    // TODO: Implement actual GPS detection using geolocator
    // This is a placeholder for demonstration
    await Future.delayed(const Duration(seconds: 2));
    
    // Default to Mecca as fallback
    _latitude = 21.4225;
    _longitude = 39.8262;
    _city = 'مكة المكرمة';
    _country = 'السعودية';
    _isLocationSet = true;
    _isLoading = false;
    notifyListeners();
  }

  void resetLocation() {
    _latitude = null;
    _longitude = null;
    _city = null;
    _country = null;
    _isLocationSet = false;
    notifyListeners();
  }
}
