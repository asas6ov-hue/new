package com.example.kotlinapp.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

data class QuranSurah(val number: Int, val nameAr: String, val nameEn: String, val versesCount: Int)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuranScreen(
    onNavigateBack: () -> Unit
) {
    val surahs = remember {
        listOf(
            QuranSurah(1, "الفاتحة", "Al-Fatiha", 7),
            QuranSurah(2, "البقرة", "Al-Baqarah", 286),
            QuranSurah(3, "آل عمران", "Ali 'Imran", 200),
            QuranSurah(4, "النساء", "An-Nisa", 176),
            QuranSurah(5, "المائدة", "Al-Ma'idah", 120),
            QuranSurah(6, "الأنعام", "Al-An'am", 165),
            QuranSurah(7, "الأعراف", "Al-A'raf", 206),
            QuranSurah(18, "الكهف", "Al-Kahf", 110),
            QuranSurah(36, "يس", "Ya-Sin", 83),
            QuranSurah(55, "الرحمن", "Ar-Rahman", 78),
            QuranSurah(67, "الملك", "Al-Mulk", 30),
            QuranSurah(112, "الإخلاص", "Al-Ikhlas", 4),
            QuranSurah(113, "الفلق", "Al-Falaq", 5),
            QuranSurah(114, "الناس", "An-Nas", 6)
        )
    }

    var selectedSurah by remember { mutableStateOf<QuranSurah?>(null) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("القرآن الكريم") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = "رجوع")
                    }
                }
            )
        }
    ) { paddingValues ->
        Box(modifier = Modifier.padding(paddingValues)) {
            if (selectedSurah == null) {
                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    contentPadding = PaddingValues(16.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(surahs) { surah ->
                        Card(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clickable { selectedSurah = surah },
                            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
                        ) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(16.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Column(horizontalAlignment = Alignment.End) {
                                    Text(text = surah.nameAr, style = MaterialTheme.typography.titleMedium)
                                    Text(text = "${surah.versesCount} آية", style = MaterialTheme.typography.bodySmall)
                                }
                                Text(text = "${surah.number}", style = MaterialTheme.typography.titleLarge)
                            }
                        }
                    }
                }
            } else {
                // عرض تفاصيل السورة (مبسط)
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = selectedSurah!!.nameAr,
                        style = MaterialTheme.typography.headlineLarge,
                        modifier = Modifier.padding(bottom = 16.dp)
                    )
                    Text(
                        text = "عدد الآيات: ${selectedSurah!!.versesCount}",
                        style = MaterialTheme.typography.bodyLarge
                    )
                    Spacer(modifier = Modifier.height(32.dp))
                    Text(
                        text = "(محتوى السورة سيظهر هنا عند ربط API)",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(32.dp))
                    Button(onClick = { selectedSurah = null }) {
                        Text("عودة للقائمة")
                    }
                }
            }
        }
    }
}
