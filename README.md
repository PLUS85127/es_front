¡Excelente! Llegó el momento de construir la **Feature de Historial (Reportes)**. 

Como ya dominas la Arquitectura Limpia, vamos a construir esta característica desde cero usando exactamente el mismo patrón que usamos para Autenticación y Lecciones. Lo haremos paso a paso para que no haya errores.

Lo primero es crear nuestras carpetas vacías para organizar la casa. Ve a `lib/features/reporting/` y asegúrate de tener estas 3 carpetas:
* `domain/`
* `data/`
* `presentation/`

---

### PASO 1: La Capa de Dominio (El Cerebro puro) 🧠
Vamos a crear las reglas de negocio sin tocar internet ni JSON. Crea estos 3 archivos dentro de la carpeta `lib/features/reporting/domain/`.

**1. La Entidad:** `domain/entities/stats_entity.dart`
```dart
class StatsEntity {
  final String quarterlyId;
  final String lessonId;
  final String weeklyLabel;
  final int weeklyCount;
  final String quarterlyPercentage;
  final int totalDaysStudied;

  StatsEntity({
    required this.quarterlyId,
    required this.lessonId,
    required this.weeklyLabel,
    required this.weeklyCount,
    required this.quarterlyPercentage,
    required this.totalDaysStudied,
  });
}
```

**2. El Contrato (Repositorio):** `domain/repositories/reporting_repository.dart`
```dart
import '../entities/stats_entity.dart';

abstract class ReportingRepository {
  // El contrato dice que debemos poder obtener las estadísticas
  // pidiendo el token, el trimestre y la lección.
  Future<StatsEntity> getMyStats(String token, String quarterlyId, String lessonId);
}
```

**3. El Caso de Uso (Mensajero):** `domain/use_cases/get_my_stats_usecase.dart`
```dart
import '../entities/stats_entity.dart';
import '../repositories/reporting_repository.dart';

class GetMyStatsUseCase {
  final ReportingRepository repository;

  GetMyStatsUseCase(this.repository);

  Future<StatsEntity> execute(String token, String quarterlyId, String lessonId) async {
    return await repository.getMyStats(token, quarterlyId, lessonId);
  }
}
```

¡Listo! Con estos 3 archivos chiquitos ya tenemos nuestro dominio protegido. 

Crea estos archivos, avísame cuando los tengas y te paso el **PASO 2 (La Capa de Datos)** donde sí nos conectamos a tu API.
-----------------------------------
¡Excelente! Sigamos con el **PASO 2: La Capa de Datos (El Motor ⚙️)**.

Aquí es donde nos conectamos a tu API. Lo genial es que tú **ya tenías** parte de este código hecho (tu `ReportingRemoteDataSource` y tu `StatsModel`), así que solo vamos a ajustarlos ligeramente para que respeten la Arquitectura Limpia y se conecten con tu nuevo Dominio.

Crea (o actualiza) estos 3 archivos dentro de tu carpeta `lib/features/reporting/data/`:

**1. El Modelo:** `data/models/stats_model.dart`
*(Nota: Este reemplaza a tu antiguo `stats_data.dart`. Ahora usa `extends StatsEntity` para que la UI lo pueda entender sin conocer el JSON).*
```dart
import '../../domain/entities/stats_entity.dart';

class StatsModel extends StatsEntity {
  StatsModel({
    required super.quarterlyId,
    required super.lessonId,
    required super.weeklyLabel,
    required super.weeklyCount,
    required super.quarterlyPercentage,
    required super.totalDaysStudied,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      quarterlyId: json['quarterlyId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      weeklyLabel: json['weeklyLabel'] ?? '',
      weeklyCount: json['weeklyCount'] ?? 0,
      quarterlyPercentage: json['quarterlyPercentage'] ?? '0%',
      totalDaysStudied: json['totalDaysStudied'] ?? 0,
    );
  }
}
```

**2. La Conexión a Internet:** `data/datasources/reporting_remote_data_source.dart`
*(Limpiamos un poco tu archivo anterior para que quede perfecto).*
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:es_control/core/network/api_conf.dart';
import '../models/stats_model.dart';

class ReportingRemoteDataSource {
  Future<StatsModel> getMyStats(String token, String quarterlyId, String lessonId) async {
    final finalUrl = '${ApiConfig.baseUrl}/progress/my-stats/$quarterlyId/$lessonId';

    final response = await http.get(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return StatsModel.fromJson(jsonResponse['stats']);
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(jsonResponse['message'] ?? 'Error al cargar las estadísticas');
    }
  }
}
```

**3. El Traductor (Repositorio Impl):** `data/repositories/reporting_repository_impl.dart`
*(Este es el que une la conexión a internet con el cerebro del Dominio).*
```dart
import '../../domain/entities/stats_entity.dart';
import '../../domain/repositories/reporting_repository.dart';
import '../datasources/reporting_remote_data_source.dart';

class ReportingRepositoryImpl implements ReportingRepository {
  final ReportingRemoteDataSource remoteDataSource;

  ReportingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StatsEntity> getMyStats(String token, String quarterlyId, String lessonId) async {
    // Llama al DataSource y devuelve la Entidad pura
    return await remoteDataSource.getMyStats(token, quarterlyId, lessonId);
  }
}
```

¡Con esto ya tenemos la tubería completa desde el internet hasta tu aplicación! 

Guarda estos cambios (borra tu antiguo `stats_data.dart` si aún lo tienes para no confundirte) y confírmame con un **"Listo"** para pasar al **PASO FINAL: El Inyector y tu pantalla visual `HistoryPage`**. 🚀


-----------------
¡Excelente! Has llegado a la recta final. Ya tienes el cerebro (Domain) y el motor (Data). Ahora solo falta el "cableado" y la "pintura" (UI).

Vamos a terminar tu pantalla de Historial en estos últimos 3 pasos:

---

### PASO 3: El Inyector (El Cableado 🔌)
Vamos a enseñarle a `GetIt` cómo armar esta nueva característica.

**1. Crea el inyector de reportes:**
Crea un nuevo archivo en **`lib/core/di/reporting_injection.dart`**:
```dart
import 'package:get_it/get_it.dart';
import '../../features/reporting/data/datasource/reporting_remote_data_source.dart';
import '../../features/reporting/data/repositories/reporting_repository_impl.dart';
import '../../features/reporting/domain/repositories/reporting_repository.dart';
import '../../features/reporting/domain/use_cases/get_my_stats_usecase.dart';
import '../../features/reporting/presentation/provider/stats_provider.dart';

void initReporting(GetIt sl) {
  //DataSources
  sl.registerLazySingleton<ReportingRemoteDataSource>(() => ReportingRemoteDataSource());
  
  //repositorio
  sl.registerLazySingleton<ReportingRepository>(
    () => ReportingRepositoryImpl(remoteDataSource: sl()),
  );
  
  //casos de uso
  sl.registerLazySingleton(() => GetMyStatsUseCase(sl()));
  
  sl.registerFactory(() => StatsProvider(getMyStatsUseCase: sl()));
}
```

**2. Actualiza al "Jefe" (`injection_container.dart`):**
Abre tu **`lib/core/di/injection_container.dart`** y agrega la nueva característica:
```dart
import 'package:get_it/get_it.dart';
import 'auth_injection.dart';
import 'lesson_injection.dart';
import 'reporting_injection.dart'; // <-- AGREGA ESTO

final sl = GetIt.instance;

Future<void> init() async {
  initAuth(sl);
  initLesson(sl);
  initReporting(sl); // <-- AGREGA ESTO
}
```

---

### PASO 4: El Provider (La Lógica de la Pantalla 🧠)
Tu antiguo provider se conectaba directo a internet. Vamos a actualizarlo para que use tu nuevo Caso de Uso (Arquitectura Limpia).

Reemplaza todo el contenido de **`lib/features/reporting/presentation/provider/stats_provider.dart`** con esto:
```dart
import 'package:flutter/material.dart';
import '../../domain/entities/stats_entity.dart';
import '../../domain/use_cases/get_my_stats_usecase.dart';

class StatsProvider extends ChangeNotifier {
  final GetMyStatsUseCase getMyStatsUseCase;

  StatsEntity? _currentStats;
  bool _isLoading = false; // Cambiado a false por defecto
  String? _errorMessage;

  StatsProvider({required this.getMyStatsUseCase});

  StatsEntity? get currentStats => _currentStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMyStats(String token, String quarterlyId, String lessonId) async {
    // Si ya estamos cargando, no hacemos nada
    if (_isLoading) return; 

    // Usamos microtask para no chocar con el renderizado de la UI
    Future.microtask(() {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    });

    try {
      // Usamos el Caso de Uso limpio
      _currentStats = await getMyStatsUseCase.execute(token, quarterlyId, lessonId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

### PASO FINAL: La Pantalla (HistoryPage 📊)
Tu antiguo `history_page.dart` estaba comentado. Aquí tienes el código completo y elegante para tu pantalla de estadísticas. 

Esta pantalla es muy inteligente: tomará el Token de Autenticación y la Lección Actual, y se los pasará a tu `StatsProvider`.

Reemplaza tu **`lib/features/reporting/presentation/page/history_page.dart`** con esto:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:es_control/features/lesson_study/presentation/providers/lesson_provider.dart';
import '../provider/stats_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStats());
  }

  void _loadStats() {
    final authProvider = context.read<AuthProvider>();
    final lessonProvider = context.read<LessonProvider>();
    final statsProvider = context.read<StatsProvider>();

    final token = authProvider.token;
    final currentQ = lessonProvider.currentQuarterly;
    final currentLesson = lessonProvider.currentLesson;

    // Solo pedimos las estadísticas si tenemos token y sabemos qué trimestre/lección es hoy
    if (token != null && currentQ != null && currentLesson != null) {
      statsProvider.fetchMyStats(token, currentQ.quarterlyId, currentLesson.lessonId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
            child: Text(
              "Tu Progreso",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.navyBlue,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<StatsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.navyBlue));
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                  );
                }

                final stats = provider.currentStats;

                if (stats == null) {
                  return Center(
                    child: Text(
                      "No hay estadísticas disponibles.",
                      style: GoogleFonts.poppins(color: Colors.black54),
                    ),
                  );
                }

                // Aquí pintamos los datos reales del backend
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      _buildStatCard(
                        "Progreso de la Semana",
                        "${stats.weeklyCount} de 7 días",
                        Icons.calendar_today_rounded,
                        Colors.orange,
                      ),
                      const SizedBox(height: 15),
                      _buildStatCard(
                        "Porcentaje del Trimestre",
                        stats.quarterlyPercentage,
                        Icons.pie_chart_rounded,
                        Colors.green,
                      ),
                      const SizedBox(height: 15),
                      _buildStatCard(
                        "Días Totales Estudiados",
                        "${stats.totalDaysStudied} días",
                        Icons.check_circle_outline_rounded,
                        AppTheme.navyBlue,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navyBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 🚀 El toque final en `main.dart` y `main_page.dart`
1. Descomenta el `HistoryPage` en tu **`lib/features/navigation/presentation/page/main_page.dart`**:
```dart
  final List<Widget> _pages = [
    const HomePage(), 
    const LessonsStudyPage(), 
    const HistoryPage(), // <-- ¡Quítale el // a esta línea!
    const ProfilePage(), 
  ];
```
2. Inyecta el provider en tu **`main.dart`** junto a los otros:
```dart
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
        ChangeNotifierProvider(create: (_) => di.sl<LessonProvider>()), 
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<StatsProvider>()), // <-- AGREGA ESTO
      ],
```

¡Has completado la Arquitectura Limpia de TODO el proyecto! Compila y abre la pestaña de estadísticas (el ícono de las barritas 📊). Debería cargar tus datos reales. ¡Cuéntame si funciona!