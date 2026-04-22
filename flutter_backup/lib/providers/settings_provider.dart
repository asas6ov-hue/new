import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // Adhan Sound Settings
  String _adhanReader = 'مشاري العفاسي';
  bool _autoSilent = false;
  List<String> _silentPrayers = [];

  // Dhikr Notifications
  bool _dhikrNotifications = false;
  int _dhikrInterval = 30; // minutes
  String _dhikrSound = 'صوت افتراضي';

  // General Settings
  String _language = 'ar';
  bool _darkMode = false;

  // Getters
  String get adhanReader => _adhanReader;
  bool get autoSilent => _autoSilent;
  List<String> get silentPrayers => _silentPrayers;
  bool get dhikrNotifications => _dhikrNotifications;
  int get dhikrInterval => _dhikrInterval;
  String get dhikrSound => _dhikrSound;
  String get language => _language;
  bool get darkMode => _darkMode;

  // Available Adhan Readers
  static const List<String> adhanReaders = [
    'مشاري العفاسي',
    'عبدالباسط عبدالصمد',
    'محمد صديق المنشاوي',
    'سعد الغامدي',
    'ماهر المعيقلي',
    'أحمد العجمي',
    'خالد القحطاني',
    'علي الحذيفي',
    'صلاح البدير',
    'عبدالرحمن السديس',
  ];

  // Available Dhikr Sounds
  static const List<String> dhikrSounds = [
    'صوت افتراضي',
    'صوت 1',
    'صوت 2',
    'صوت 3',
    'صوت 4',
  ];

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _adhanReader = prefs.getString('adhan_reader') ?? 'مشاري العفاسي';
    _autoSilent = prefs.getBool('auto_silent') ?? false;
    _silentPrayers = prefs.getStringList('silent_prayers') ?? [];
    _dhikrNotifications = prefs.getBool('dhikr_notifications') ?? false;
    _dhikrInterval = prefs.getInt('dhikr_interval') ?? 30;
    _dhikrSound = prefs.getString('dhikr_sound') ?? 'صوت افتراضي';
    _language = prefs.getString('language') ?? 'ar';
    _darkMode = prefs.getBool('dark_mode') ?? false;
    
    notifyListeners();
  }

  Future<void> setAdhanReader(String reader) async {
    _adhanReader = reader;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhan_reader', reader);
    notifyListeners();
  }

  Future<void> setAutoSilent(bool value) async {
    _autoSilent = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_silent', value);
    notifyListeners();
  }

  Future<void> setSilentPrayers(List<String> prayers) async {
    _silentPrayers = prayers;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('silent_prayers', prayers);
    notifyListeners();
  }

  Future<void> setDhikrNotifications(bool value) async {
    _dhikrNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dhikr_notifications', value);
    notifyListeners();
  }

  Future<void> setDhikrInterval(int minutes) async {
    _dhikrInterval = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dhikr_interval', minutes);
    notifyListeners();
  }

  Future<void> setDhikrSound(String sound) async {
    _dhikrSound = sound;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dhikr_sound', sound);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    notifyListeners();
  }
}
