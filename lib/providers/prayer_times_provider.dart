import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'location_provider.dart';

class PrayerTimesProvider with ChangeNotifier {
  PrayerTimes? _prayerTimes;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  PrayerTimes? get prayerTimes => _prayerTimes;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  Future<void> calculatePrayerTimes(LocationProvider locationProvider) async {
    if (!locationProvider.isLocationSet || 
        locationProvider.latitude == null || 
        locationProvider.longitude == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final coordinates = Coordinates(
        locationProvider.latitude!,
        locationProvider.longitude!,
      );

      // Use Muslim World League calculation method (can be customized)
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;

      _prayerTimes = PrayerTimes.today(coordinates, params);
      _selectedDate = DateTime.now();
    } catch (e) {
      debugPrint('Error calculating prayer times: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getFajrTime() => _formatTime(_prayerTimes?.fajr);
  String getSunriseTime() => _formatTime(_prayerTimes?.sunrise);
  String getDhuhrTime() => _formatTime(_prayerTimes?.dhuhr);
  String getAsrTime() => _formatTime(_prayerTimes?.asr);
  String getMaghribTime() => _formatTime(_prayerTimes?.maghrib);
  String getIshaTime() => _formatTime(_prayerTimes?.isha);

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  PrayerTime getNextPrayer() {
    if (_prayerTimes == null) return PrayerTime.fajr;
    return _prayerTimes!.currentPrayer() ?? PrayerTime.fajr;
  }

  Duration getTimeUntilNextPrayer() {
    if (_prayerTimes == null) return Duration.zero;
    
    final nextPrayerTime = _prayerTimes!.nextPrayer();
    if (nextPrayerTime == null) return Duration.zero;

    return nextPrayerTime.difference(DateTime.now());
  }

  String getPrayerName(PrayerTime prayer) {
    switch (prayer) {
      case PrayerTime.fajr: return 'الفجر';
      case PrayerTime.sunrise: return 'الشروق';
      case PrayerTime.dhuhr: return 'الظهر';
      case PrayerTime.asr: return 'العصر';
      case PrayerTime.maghrib: return 'المغرب';
      case PrayerTime.isha: return 'العشاء';
      default: return '';
    }
  }
}
