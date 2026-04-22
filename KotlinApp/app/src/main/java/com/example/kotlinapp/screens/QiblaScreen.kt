package com.example.kotlinapp.screens

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import kotlin.math.atan2
import kotlin.math.sqrt

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QiblaScreen(
    onNavigateBack: () -> Unit
) {
    val context = LocalContext.current
    var qiblaDirection by remember { mutableStateOf<Float?>(null) }
    var phoneDirection by remember { mutableStateOf<Float?>(null) }
    var hasPermission by remember { mutableStateOf(false) }
    var errorMessage by remember { mutableStateOf<String?>(null) }

    // مكة المكرمة الإحداثيات
    val meccaLat = 21.4225
    val meccaLon = 39.8262

    LaunchedEffect(Unit) {
        // التحقق من الصلاحيات (في التطبيق الحقيقي نحتاج طلب الصلاحيات)
        hasPermission = ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED

        if (!hasPermission) {
            errorMessage = "يرجى منح صلاحية الموقع لحساب القبلة بدقة"
        }
    }

    // محاكاة حساب اتجاه القبلة (في التطبيق الحقيقي نستخدم المستشعرات)
    LaunchedEffect(Unit) {
        // هنا نضع كود المستشعرات الحقيقي
        // هذا مثال مبسط للمحاكاة
        qiblaDirection = 115.0f // اتجاه القبلة التقريبي من معظم الدول العربية
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("اتجاه القبلة") },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(Icons.Filled.ArrowBack, contentDescription = "رجوع")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            if (errorMessage != null) {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 16.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.errorContainer
                    )
                ) {
                    Text(
                        text = errorMessage!!,
                        modifier = Modifier.padding(16.dp),
                        color = MaterialTheme.colorScheme.onErrorContainer
                    )
                }
            }

            // بوصلة القبلة
            Card(
                modifier = Modifier
                    .size(250.dp)
                    .padding(16.dp),
                elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
            ) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    // دائرة البوصلة
                    Surface(
                        modifier = Modifier.size(200.dp),
                        shape = androidx.compose.foundation.shape.CircleShape,
                        color = MaterialTheme.colorScheme.surfaceVariant
                    ) {
                        Box(contentAlignment = Alignment.TopCenter) {
                            Text(
                                text = "N",
                                modifier = Modifier.padding(top = 8.dp),
                                style = MaterialTheme.typography.titleLarge
                            )
                        }
                    }

                    // سهم القبلة
                    if (qiblaDirection != null) {
                        androidx.compose.foundation.Canvas(
                            modifier = Modifier.size(180.dp)
                        ) {
                            drawLine(
                                color = MaterialTheme.colorScheme.primary,
                                start = androidx.compose.ui.geometry.Offset(size.width / 2, size.height / 2),
                                end = androidx.compose.ui.geometry.Offset(
                                    size.width / 2,
                                    20f
                                ),
                                strokeWidth = 8f
                            )
                        }
                    }

                    Text(
                        text = "القبلة",
                        style = MaterialTheme.typography.titleMedium,
                        modifier = Modifier.align(Alignment.Center)
                    )
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            if (qiblaDirection != null) {
                Text(
                    text = "اتجاه القبلة: ${qiblaDirection!!.toInt()}°",
                    style = MaterialTheme.typography.headlineSmall,
                    color = MaterialTheme.colorScheme.primary
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "من الشمال",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            } else {
                CircularProgressIndicator()
            }

            Spacer(modifier = Modifier.height(32.dp))

            Text(
                text = "ملاحظة: هذا عرض تجريبي. في التطبيق الكامل سيتم استخدام مستشعر المغناطيسية والـ GPS لحساب الاتجاه الدقيق.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                modifier = Modifier.padding(horizontal = 16.dp)
            )
        }
    }
}

// فئة مساعدة لحساب اتجاه القبلة (للاستخدام المستقبلي مع المستشعرات)
class QiblaCalculator(private val context: Context) : SensorEventListener {
    private val sensorManager: SensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private val accelerometer: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    private val magnetometer: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

    private val gravity = FloatArray(3)
    private val geomagnetic = FloatArray(3)
    var qiblaDirection: Float? = null

    override fun onSensorChanged(event: SensorEvent?) {
        when (event?.sensor?.type) {
            Sensor.TYPE_ACCELEROMETER -> gravity.set(event.values)
            Sensor.TYPE_MAGNETIC_FIELD -> geomagnetic.set(event.values)
        }

        val R = FloatArray(9)
        val I = FloatArray(9)
        val success = SensorManager.getRotationMatrix(R, I, gravity, geomagnetic)

        if (success) {
            val orientation = FloatArray(3)
            SensorManager.getOrientation(R, orientation)
            val azimuth = Math.toDegrees(orientation[0].toDouble()).toFloat()

            // حساب اتجاه القبلة بناءً على الموقع الحالي
            // هذه معادلة مبسطة - تحتاج لتحسين باستخدام إحداثيات GPS الفعلية
            qiblaDirection = (115.0 - azimuth + 360) % 360
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    fun start() {
        sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_UI)
        sensorManager.registerListener(this, magnetometer, SensorManager.SENSOR_DELAY_UI)
    }

    fun stop() {
        sensorManager.unregisterListener(this)
    }
}
