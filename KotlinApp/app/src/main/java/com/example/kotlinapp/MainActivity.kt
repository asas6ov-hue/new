package com.example.kotlinapp

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Book
import androidx.compose.material.icons.filled.Compass
import androidx.compose.material.icons.filled.FormatListNumbered
import androidx.compose.material.icons.filled.Mosque
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
    HOME, QURAN, PRAYER_TIMES, QIBLA, DHIKR
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun IslamicApp() {
    var currentScreen by remember { mutableStateOf(AppScreen.HOME) }

    when (currentScreen) {
        AppScreen.HOME -> HomeScreen(onNavigateTo = { currentScreen = it })
        AppScreen.QURAN -> QuranScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
        AppScreen.PRAYER_TIMES -> PrayerTimesScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
        AppScreen.QIBLA -> QiblaScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
        AppScreen.DHIKR -> DhikrScreen(onNavigateBack = { currentScreen = AppScreen.HOME })
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(onNavigateTo: (AppScreen) -> Unit) {
    val menuItems = listOf(
        AppMenuItem("القرآن الكريم", Icons.Filled.Book, AppScreen.QURAN),
        AppMenuItem("أوقات الصلاة", Icons.Filled.Mosque, AppScreen.PRAYER_TIMES),
        AppMenuItem("اتجاه القبلة", Icons.Filled.Compass, AppScreen.QIBLA),
        AppMenuItem("الأذكار", Icons.Filled.FormatListNumbered, AppScreen.DHIKR)
    )

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("التطبيق الإسلامي") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    titleContentColor = MaterialTheme.colorScheme.onPrimaryContainer
                )
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "مرحباً بك في التطبيق الإسلامي",
                style = MaterialTheme.typography.headlineSmall,
                modifier = Modifier.padding(bottom = 24.dp)
            )

            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(menuItems.size) { index ->
                    val item = menuItems[index]
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { onNavigateTo(item.screen) },
                        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(20.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(16.dp)
                        ) {
                            Icon(
                                imageVector = item.icon,
                                contentDescription = null,
                                modifier = Modifier.size(32.dp),
                                tint = MaterialTheme.colorScheme.primary
                            )
                            Text(
                                text = item.title,
                                style = MaterialTheme.typography.titleLarge
                            )
                        }
                    }
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun HomeScreenPreview() {
    KotlinAppTheme {
        HomeScreen(onNavigateTo = {})
    }
}
