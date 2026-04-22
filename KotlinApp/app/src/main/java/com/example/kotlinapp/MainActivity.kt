package com.example.kotlinapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.kotlinapp.screens.DhikrScreen
import com.example.kotlinapp.screens.PrayerTimesScreen
import com.example.kotlinapp.screens.QiblaScreen
import com.example.kotlinapp.screens.QuranScreen
import com.example.kotlinapp.ui.theme.KotlinAppTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            KotlinAppTheme {
                IslamicApp()
            }
        }
    }
}

data class AppMenuItem(
    val title: String,
    val icon: ImageVector,
    val screen: AppScreen
)

enum class AppScreen {
    HOME, QURAN, PRAYER_TIMES, QIBLA, DHIKR, SETTINGS, HADITH
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun IslamicApp() {
    var currentScreen by remember { mutableStateOf(AppScreen.HOME) }
    var drawerOpen by remember { mutableStateOf(false) }

    // تعريف عناصر القائمة الجانبية بالترتيب المطلوب
    val menuItems = listOf(
        AppMenuItem("الإعدادات", Icons.Filled.Settings, AppScreen.SETTINGS),
        AppMenuItem("المصحف الشريف", Icons.Filled.Book, AppScreen.QURAN),
        AppMenuItem("الأحاديث النبوية", Icons.Filled.MenuBook, AppScreen.HADITH),
        AppMenuItem("الأذكار", Icons.Filled.FormatListNumbered, AppScreen.DHIKR),
        AppMenuItem("اتجاه القبلة", Icons.Filled.Compass, AppScreen.QIBLA)
    )

    ModalNavigationDrawer(
        drawerContent = {
            ModalDrawerSheet {
                Spacer(Modifier.height(12.dp))
                Text(
                    text = "القائمة الرئيسية",
                    modifier = Modifier.padding(16.dp),
                    style = MaterialTheme.typography.titleLarge
                )
                Divider()
                menuItems.forEach { item ->
                    NavigationDrawerItem(
                        icon = { Icon(item.icon, contentDescription = null) },
                        label = { Text(item.title) },
                        selected = currentScreen == item.screen,
                        onClick = {
                            currentScreen = item.screen
                            drawerOpen = false
                        },
                        modifier = Modifier.padding(NavigationDrawerItemDefaults.ItemPadding)
                    )
                }
            }
        },
        gesturesEnabled = drawerOpen,
        drawerState = rememberDrawerState(DrawerValue.Closed),
        content = {
            Scaffold(
                topBar = {
                    TopAppBar(
                        title = { Text("التطبيق الإسلامي") },
                        navigationIcon = {
                            IconButton(onClick = { drawerOpen = true }) {
                                Icon(Icons.Filled.Menu, contentDescription = "فتح القائمة")
                            }
                        },
                        colors = TopAppBarDefaults.topAppBarColors(
                            containerColor = MaterialTheme.colorScheme.primaryContainer,
                            titleContentColor = MaterialTheme.colorScheme.onPrimaryContainer
                        )
                    )
                }
            ) { paddingValues ->
                Box(modifier = Modifier.fillMaxSize()) {
                    when (currentScreen) {
                        AppScreen.HOME -> HomeScreenContent(modifier = Modifier.padding(paddingValues))
                        AppScreen.QURAN -> QuranScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
                        AppScreen.PRAYER_TIMES -> PrayerTimesScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
                        AppScreen.QIBLA -> QiblaScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
                        AppScreen.DHIKR -> DhikrScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
                        AppScreen.SETTINGS -> SettingsScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
                        AppScreen.HADITH -> HadithScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
                    }
                }
            }
        }
    )
}

@Composable
fun HomeScreenContent(modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            imageVector = Icons.Filled.Mosque,
            contentDescription = null,
            modifier = Modifier.size(100.dp),
            tint = MaterialTheme.colorScheme.primary
        )
        Spacer(Modifier.height(24.dp))
        Text(
            text = "مرحباً بك في التطبيق الإسلامي",
            style = MaterialTheme.typography.headlineSmall,
            color = MaterialTheme.colorScheme.onSurface
        )
        Spacer(Modifier.height(8.dp))
        Text(
            text = "اختر من القائمة الجانبية للوصول إلى الأقسام",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
fun SettingsScreen(onNavigateBack: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text("شاشة الإعدادات", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(16.dp))
        Text("يمكن هنا إضافة خيارات تحديد الموقع وطريقة الحساب")
        Spacer(Modifier.height(32.dp))
        Button(onClick = onNavigateBack) {
            Text("عودة")
        }
    }
}

@Composable
fun HadithScreen(onNavigateBack: () -> Unit) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Text("الأحاديث النبوية", style = MaterialTheme.typography.headlineMedium)
        }
        item {
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("قال رسول الله صلى الله عليه وسلم:", style = MaterialTheme.typography.titleMedium)
                    Spacer(Modifier.height(8.dp))
                    Text("«خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ»")
                }
            }
        }
        item {
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("قال رسول الله صلى الله عليه وسلم:", style = MaterialTheme.typography.titleMedium)
                    Spacer(Modifier.height(8.dp))
                    Text("«مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ»")
                }
            }
        }
        item {
            Button(onClick = onNavigateBack, modifier = Modifier.align(Alignment.End)) {
                Text("عودة")
            }
        }
    }
}
