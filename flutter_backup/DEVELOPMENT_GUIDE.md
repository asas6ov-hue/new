# تطبيق المصلي - دليل التطوير السريع

## هيكل المشروع الحالي

```
almosaly/
├── lib/
│   ├── main.dart                    # نقطة البداية للتطبيق
│   ├── providers/                   # مزودي البيانات (State Management)
│   │   ├── location_provider.dart   # إدارة الموقع الجغرافي
│   │   ├── prayer_times_provider.dart # إدارة مواقيت الصلاة
│   │   └── settings_provider.dart   # إدارة الإعدادات
│   ├── screens/                     # الشاشات الرئيسية
│   │   ├── splash_screen.dart       # شاشة البداية
│   │   ├── setup_wizard_screen.dart # معالج الإعداد الأولي
│   │   └── home_screen.dart         # الشاشة الرئيسية
│   ├── widgets/                     # المكونات القابلة لإعادة الاستخدام
│   ├── services/                    # الخدمات
│   └── models/                      # نماذج البيانات
├── assets/
│   ├── fonts/                       # الخطوط العربية
│   ├── audio/                       # ملفات الصوت
│   └── images/                      # الصور والزخارف
├── pubspec.yaml                     # تكوين المشروع والمكتبات
└── README.md                        # وثائق المشروع
```

## المكتبات المستخدمة

تم تثبيت المكتبات التالية في `pubspec.yaml`:

- **provider**: لإدارة الحالة
- **adhan**: لحساب مواقيت الصلاة
- **geolocator**: لتحديد الموقع الجغرافي
- **hijri_calendar**: للتاريخ الهجري
- **audioplayers**: لتشغيل الأصوات
- **shared_preferences**: لحفظ الإعدادات
- **flutter_compass**: للبوصلة والقبلة
- **google_fonts**: للخطوط
- **permission_handler**: للأذونات

## الخطوات التالية للتطوير

### 1. تثبيت Flutter SDK

يجب تثبيت Flutter SDK على جهازك:
```bash
# تحميل Flutter من https://flutter.dev/docs/get-started/install
# ثم تشغيل:
flutter doctor
```

### 2. تثبيت المكتبات

```bash
cd /workspace
flutter pub get
```

### 3. إضافة الخطوط

قم بتنزيل خط Amيري من Google Fonts وضعه في `assets/fonts/`:
- Amiri-Regular.ttf
- Amiri-Bold.ttf

### 4. الملفات المطلوبة إضافتها

#### أ. شاشات إضافية (في lib/screens/):
- `quran_screen.dart` - شاشة القرآن الكريم
- `adhkar_screen.dart` - شاشة الأذكار
- `qibla_screen.dart` - شاشة القبلة
- `hadith_screen.dart` - شاشة الأحاديث

#### ب. مكونات UI (في lib/widgets/):
- `prayer_time_card.dart` - بطاقة وقت الصلاة
- `dhikr_counter.dart` - عداد الذكر
- `compass_widget.dart` --widget البوصلة
- `surah_list.dart` - قائمة السور

#### ج. خدمات (في lib/services/):
- `audio_service.dart` - خدمة التشغيل الصوتي
- `notification_service.dart` - خدمة الإشعارات
- `quran_api_service.dart` - خدمة جلب القرآن
- `hadith_api_service.dart` - خدمة جلب الأحاديث

#### د. نماذج بيانات (في lib/models/):
- `surah.dart` - نموذج السورة
- `ayah.dart` - نموذج الآية
- `dhikr.dart` - نموذج الذكر
- `hadith.dart` - نموذج الحديث

### 5. تكوين Android

في `android/app/src/main/AndroidManifest.xml`، أضف الأذونات:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### 6. تكوين iOS

في `ios/Runner/Info.plist`، أضف:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج إلى موقعك لحساب مواقيت الصلاة الدقيقة</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>نحتاج إلى موقعك لحساب مواقيت الصلاة الدقيقة</string>
```

## الميزات المكتملة حالياً

✅ هيكل المشروع الأساسي
✅ نظام التنقل بين الشاشات
✅ شاشة بداية جميلة
✅ معالج إعداد أولي لتحديد الموقع
✅ شاشة رئيسية بعرض مواقيت الصلاة
✅ إدارة الحالة باستخدام Provider
✅ حساب مواقيت الصلاة باستخدام adhan
✅ حفظ الإعدادات باستخدام SharedPreferences

## الميزات قيد التطوير

🔄 شاشة القرآن الكريم
🔄 شاشة الأذكار مع العداد
🔄 شاشة القبلة بالبوصلة
🔄 شاشة الأحاديث النبوية
🔄 تشغيل أصوات الأذان
🔄 إشعارات مواقيت الصلاة
🔄 الصامت التلقائي أثناء الصلاة

## نصائح للتطوير

1. استخدم `flutter run` لتشغيل التطبيق أثناء التطوير
2. استخدم `flutter build apk` لبناء APK للإصدار
3. استخدم `flutter build ios` لبناء نسخة iOS
4. اختبر التطبيق على أجهزة حقيقية للحصول على أفضل نتائج GPS والبوصلة

---

**ملاحظة:** بسبب قيود المساحة في البيئة الحالية، لم نتمكن من تثبيت Flutter SDK. 
يجب نقل المشروع إلى بيئة تطوير محلية تحتوي على Flutter مكتمل للتشغيل والبناء.
