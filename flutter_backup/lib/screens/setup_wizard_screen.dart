import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../providers/prayer_times_provider.dart';

class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {
  int _currentStep = 0;
  String? _selectedCountry;
  String? _selectedCity;

  final List<String> _countries = [
    'السعودية',
    'مصر',
    'الإمارات',
    'الكويت',
    'قطر',
    'البحرين',
    'عمان',
    'الأردن',
    'فلسطين',
    'سوريا',
    'لبنان',
    'العراق',
    'اليمن',
    'المغرب',
    'الجزائر',
    'تونس',
    'ليبيا',
    'السودان',
  ];

  final Map<String, List<String>> _cities = {
    'السعودية': ['مكة المكرمة', 'المدينة المنورة', 'الرياض', 'جدة', 'الدمام'],
    'مصر': ['القاهرة', 'الإسكندرية', 'الجيزة', 'الأقصر', 'أسوان'],
    'الإمارات': ['دبي', 'أبو ظبي', 'الشارقة', 'عجمان', 'رأس الخيمة'],
    'الكويت': ['الكويت', 'حولي', 'السالمية', 'الفروانية'],
    'قطر': ['الدوحة', 'الريان', 'الوكرة'],
    'البحرين': ['المنامة', 'المحرق', 'الرفاع'],
    'عمان': ['مسقط', 'صلالة', 'نزوى'],
    'الأردن': ['عمّان', 'إربد', 'الزرقاء', 'العقبة'],
    'فلسطين': ['القدس', 'غزة', 'رام الله', 'نابلس'],
    'سوريا': ['دمشق', 'حلب', 'حمص', 'لاذقية'],
    'لبنان': ['بيروت', 'طرابلس', 'صيدا'],
    'العراق': ['بغداد', 'البصرة', 'الموصل', 'أربيل'],
    'اليمن': ['صنعاء', 'عدن', 'تعز'],
    'المغرب': ['الرباط', 'الدار البيضاء', 'مراكش', 'فاس'],
    'الجزائر': ['الجزائر', 'وهران', 'قسنطينة'],
    'تونس': ['تونس', 'صفاقس', 'سوسة'],
    'ليبيا': ['طرابلس', 'بنغازي', 'مصراتة'],
    'السودان': ['الخرطوم', 'أم درمان', 'بورتسودان'],
  };

  // Approximate coordinates for major cities
  final Map<String, Map<String, double>> _cityCoordinates = {
    'مكة المكرمة': {'lat': 21.4225, 'lng': 39.8262},
    'المدينة المنورة': {'lat': 24.5247, 'lng': 39.5692},
    'الرياض': {'lat': 24.7136, 'lng': 46.6753},
    'جدة': {'lat': 21.5433, 'lng': 39.1728},
    'الدمام': {'lat': 26.4207, 'lng': 50.0888},
    'القاهرة': {'lat': 30.0444, 'lng': 31.2357},
    'الإسكندرية': {'lat': 31.2001, 'lng': 29.9187},
    'دبي': {'lat': 25.2048, 'lng': 55.2708},
    'أبو ظبي': {'lat': 24.4539, 'lng': 54.3773},
    'الكويت': {'lat': 29.3759, 'lng': 47.9774},
    'الدوحة': {'lat': 25.2854, 'lng': 51.5310},
    'المنامة': {'lat': 26.2285, 'lng': 50.5860},
    'مسقط': {'lat': 23.5880, 'lng': 58.3829},
    'عمّان': {'lat': 31.9454, 'lng': 35.9284},
    'القدس': {'lat': 31.7683, 'lng': 35.2137},
    'دمشق': {'lat': 33.5138, 'lng': 36.2765},
    'بيروت': {'lat': 33.8938, 'lng': 35.5018},
    'بغداد': {'lat': 33.3152, 'lng': 44.3661},
    'صنعاء': {'lat': 15.3694, 'lng': 44.1910},
    'الرباط': {'lat': 34.0209, 'lng': -6.8416},
    'الدار البيضاء': {'lat': 33.5731, 'lng': -7.5898},
    'الجزائر': {'lat': 36.7538, 'lng': 3.0588},
    'تونس': {'lat': 36.8065, 'lng': 10.1815},
    'طرابلس': {'lat': 32.8872, 'lng': 13.1913},
    'الخرطوم': {'lat': 15.5007, 'lng': 32.5599},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعداد الموقع'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFE8F5E9),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Indicator
              LinearProgressIndicator(
                value: (_currentStep + 1) / 3,
                backgroundColor: Colors.green.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 30),
              
              // Step Content
              Expanded(
                child: _buildStepContent(),
              ),
              
              const SizedBox(height: 20),
              
              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _currentStep--),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('السابق'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  ElevatedButton.icon(
                    onPressed: _currentStep == 2 ? _completeSetup : () => setState(() => _currentStep++),
                    icon: Icon(_currentStep == 2 ? Icons.check : Icons.arrow_forward),
                    label: Text(_currentStep == 2 ? 'إنهاء' : 'التالي'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildWelcomeStep();
      case 1:
        return _buildCountryStep();
      case 2:
        return _buildCityStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWelcomeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on,
          size: 100,
          color: Color(0xFF2E7D32),
        ),
        const SizedBox(height: 30),
        const Text(
          'مرحباً بك في تطبيق المصلي',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
            color: Color(0xFF1B5E20),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'سنقوم بمساعدتك في إعداد التطبيق لعرض مواقيت الصلاة الدقيقة حسب موقعك',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Amiri',
            color: Color(0xFF555555),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gps_fixed, color: Color(0xFF2E7D32)),
            const SizedBox(width: 10),
            const Text(
              'يمكنك أيضاً استخدام GPS للتحديد التلقائي',
              style: TextStyle(fontSize: 16, fontFamily: 'Amiri'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _detectLocationAutomatically,
          icon: const Icon(Icons.my_location),
          label: const Text('تحديد تلقائي عبر GPS'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر دولتك',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _countries.length,
            itemBuilder: (context, index) {
              final country = _countries[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: _selectedCountry == country 
                    ? const Color(0xFF2E7D32) 
                    : Colors.white,
                child: ListTile(
                  title: Text(
                    country,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Amiri',
                      color: _selectedCountry == country 
                          ? Colors.white 
                          : Colors.black,
                    ),
                  ),
                  trailing: _selectedCountry == country
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                  onTap: () => setState(() => _selectedCountry = country),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCityStep() {
    if (_selectedCountry == null) {
      return const Center(
        child: Text(
          'يرجى اختيار الدولة أولاً',
          style: TextStyle(fontSize: 18, fontFamily: 'Amiri'),
        ),
      );
    }

    final cities = _cities[_selectedCountry] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر مدينتك',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: _selectedCity == city 
                    ? const Color(0xFF2E7D32) 
                    : Colors.white,
                child: ListTile(
                  title: Text(
                    city,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Amiri',
                      color: _selectedCity == city 
                          ? Colors.white 
                          : Colors.black,
                    ),
                  ),
                  trailing: _selectedCity == city
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                  onTap: () => setState(() => _selectedCity = city),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _detectLocationAutomatically() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.detectCurrentLocation();
    
    if (locationProvider.isLocationSet && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _completeSetup() async {
    if (_selectedCountry == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار الدولة والمدينة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final coordinates = _cityCoordinates[_selectedCity];
    if (coordinates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('عذراً، لا تتوفر إحداثيات لهذه المدينة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.setLocation(
      coordinates['lat']!,
      coordinates['lng']!,
      _selectedCity,
      _selectedCountry,
    );

    final prayerTimesProvider = Provider.of<PrayerTimesProvider>(context, listen: false);
    await prayerTimesProvider.calculatePrayerTimes(locationProvider);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
