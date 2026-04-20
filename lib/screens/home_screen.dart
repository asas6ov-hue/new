import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../providers/prayer_times_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PrayerTimesScreen(),
    const Center(child: Text('القرآن الكريم', style: TextStyle(fontSize: 24, fontFamily: 'Amiri'))),
    const Center(child: Text('الأذكار', style: TextStyle(fontSize: 24, fontFamily: 'Amiri'))),
    const Center(child: Text('القبلة', style: TextStyle(fontSize: 24, fontFamily: 'Amiri'))),
    const Center(child: Text('الحديث', style: TextStyle(fontSize: 24, fontFamily: 'Amiri'))),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail for larger screens
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 600,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            backgroundColor: const Color(0xFF2E7D32),
            indicatorColor: Colors.green.withOpacity(0.5),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            selectedLabelTextStyle: const TextStyle(color: Colors.white),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('الرئيسية'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu_book),
                label: Text('القرآن'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_balance),
                label: Text('الأذكار'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.explore),
                label: Text('القبلة'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.auto_stories),
                label: Text('الحديث'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('الإعدادات'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      // Bottom Navigation for mobile
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              backgroundColor: const Color(0xFF2E7D32),
              indicatorColor: Colors.green.withOpacity(0.5),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home, color: Colors.white70),
                  selectedIcon: Icon(Icons.home, color: Colors.white),
                  label: 'الرئيسية',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu_book, color: Colors.white70),
                  selectedIcon: Icon(Icons.menu_book, color: Colors.white),
                  label: 'القرآن',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance, color: Colors.white70),
                  selectedIcon: Icon(Icons.account_balance, color: Colors.white),
                  label: 'الأذكار',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore, color: Colors.white70),
                  selectedIcon: Icon(Icons.explore, color: Colors.white),
                  label: 'القبلة',
                ),
                NavigationDestination(
                  icon: Icon(Icons.auto_stories, color: Colors.white70),
                  selectedIcon: Icon(Icons.auto_stories, color: Colors.white),
                  label: 'الحديث',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings, color: Colors.white70),
                  selectedIcon: Icon(Icons.settings, color: Colors.white),
                  label: 'الإعدادات',
                ),
              ],
            )
          : null,
    );
  }
}

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final prayerTimesProvider = Provider.of<PrayerTimesProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFF5F5F5),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      locationProvider.city ?? 'لم يتم تحديد الموقع',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    if (locationProvider.country != null)
                      Text(
                        locationProvider.country!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Amiri',
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Next Prayer Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text(
                      'الصلاة القادمة',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      prayerTimesProvider.getPrayerName(prayerTimesProvider.getNextPrayer()),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatDuration(prayerTimesProvider.getTimeUntilNextPrayer()),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withOpacity(0.9),
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Prayer Times List
            const Text(
              'مواقيت الصلاة لليوم',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 10),
            _buildPrayerTimeRow('الفجر', prayerTimesProvider.getFajrTime(), Icons.nightlight),
            _buildPrayerTimeRow('الشروق', prayerTimesProvider.getSunriseTime(), Icons.wb_sunny),
            _buildPrayerTimeRow('الظهر', prayerTimesProvider.getDhuhrTime(), Icons.sunny),
            _buildPrayerTimeRow('العصر', prayerTimesProvider.getAsrTime(), Icons.wb_twilight),
            _buildPrayerTimeRow('المغرب', prayerTimesProvider.getMaghribTime(), Icons.nights_stay),
            _buildPrayerTimeRow('العشاء', prayerTimesProvider.getIshaTime(), Icons.nightlight_round),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(String name, String time, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E7D32), size: 30),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Amiri',
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'الإعدادات',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 20),
        const ListTile(
          leading: Icon(Icons.person, color: Color(0xFF2E7D32)),
          title: Text('حساباتي', style: TextStyle(fontFamily: 'Amiri', fontSize: 18)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const ListTile(
          leading: Icon(Icons.notifications, color: Color(0xFF2E7D32)),
          title: Text('الإشعارات', style: TextStyle(fontFamily: 'Amiri', fontSize: 18)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const ListTile(
          leading: Icon(Icons.volume_up, color: Color(0xFF2E7D32)),
          title: Text('أصوات الأذان', style: TextStyle(fontFamily: 'Amiri', fontSize: 18)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const ListTile(
          leading: Icon(Icons.info, color: Color(0xFF2E7D32)),
          title: Text('عن التطبيق', style: TextStyle(fontFamily: 'Amiri', fontSize: 18)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }
}
