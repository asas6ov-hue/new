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

data class DhikrItem(val text: String, val count: Int, val reward: String)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DhikrScreen(
    onNavigateBack: () -> Unit
) {
    val adhkar = remember {
        listOf(
            DhikrItem("سبحان الله", 33, "غرس شجرة في الجنة"),
            DhikrItem("الحمد لله", 33, "تملأ الميزان"),
            DhikrItem("الله أكبر", 33, "أكبر من كل شيء"),
            DhikrItem("لا إله إلا الله وحده لا شريك له", 10, "كتب له عشر حسنات"),
            DhikrItem("أستغفر الله العظيم وأتوب إليه", 100, "مغفرة الذنوب"),
            DhikrItem("اللهم صلِّ على محمد وعلى آل محمد", 10, "صلاة الله عليك عشرا"),
            DhikrItem("لا حول ولا قوة إلا بالله", 50, "كنز من كنوز الجنة"),
            DhikrItem("سبحان الله وبحمده", 100, "حطت خطاياه وإن كانت مثل زبد البحر")
        )
    }

    var activeDhikr by remember { mutableStateOf<DhikrItem?>(null) }
    var currentCount by remember { mutableStateOf(0) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("الأذكار") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = "رجوع")
                    }
                }
            )
        }
    ) { paddingValues ->
        Box(modifier = Modifier.padding(paddingValues)) {
            if (activeDhikr == null) {
                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    contentPadding = PaddingValues(16.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(adhkar) { dhikr ->
                        Card(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clickable { 
                                    activeDhikr = dhikr
                                    currentCount = 0
                                },
                            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
                        ) {
                            Column(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(16.dp)
                            ) {
                                Text(
                                    text = dhikr.text,
                                    style = MaterialTheme.typography.titleMedium,
                                    modifier = Modifier.padding(bottom = 8.dp)
                                )
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween
                                ) {
                                    Text(
                                        text = "العدد المطلوب: ${dhikr.count}",
                                        style = MaterialTheme.typography.bodySmall
                                    )
                                    Text(
                                        text = dhikr.reward,
                                        style = MaterialTheme.typography.bodySmall,
                                        color = MaterialTheme.colorScheme.primary
                                    )
                                }
                            }
                        }
                    }
                }
            } else {
                // شاشة التسبيح النشط
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Text(
                        text = activeDhikr!!.text,
                        style = MaterialTheme.typography.headlineMedium,
                        modifier = Modifier.padding(bottom = 32.dp),
                        maxLines = 3
                    )

                    Text(
                        text = "$currentCount / ${activeDhikr!!.count}",
                        style = MaterialTheme.typography.displayLarge,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.padding(bottom = 32.dp)
                    )

                    Button(
                        onClick = {
                            if (currentCount < activeDhikr!!.count) {
                                currentCount++
                            }
                        },
                        modifier = Modifier
                            .size(200.dp)
                            .padding(bottom = 16.dp),
                        enabled = currentCount < activeDhikr!!.count
                    ) {
                        Text("سبّح", style = MaterialTheme.typography.titleLarge)
                    }

                    if (currentCount >= activeDhikr!!.count) {
                        Text(
                            text = "تم الانتهاء! تقبل الله منك",
                            style = MaterialTheme.typography.titleMedium,
                            color = MaterialTheme.colorScheme.tertiary,
                            modifier = Modifier.padding(bottom = 16.dp)
                        )
                    }

                    OutlinedButton(onClick = { activeDhikr = null }) {
                        Text("اختيار ذكر آخر")
                    }
                }
            }
        }
    }
}
