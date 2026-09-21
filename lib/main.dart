import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importa tus vistas de autenticación
import 'features/Inicio_de_sesion/views/login_view.dart';
import 'features/Registrarse/views/register_view.dart';
import 'features/Recuperar_contra/views/recover_password_view.dart';

// Importa tu vista de navegación principal de Eslabón
import 'features/navigation/views/main_navigation_view.dart';

//Dashboard
import 'features/Principal/Dashboard/Dashboard.dart';

//Empleados
import 'features/personal/empleados/views/empleados_view.dart';

//Ventas
import 'features/operaciones/ventas/views/ventas_view.dart';

// 1. Proveedor global para gestionar el estado del tema con persistencia
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Por defecto usa el del sistema

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme(); // Carga el tema guardado al iniciar la app
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners(); // Notifica a todos los módulos y vistas al instante

    // Guarda la selección para que no se pierda al reiniciar o recargar código
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('theme_mode');

    if (savedMode != null) {
      if (savedMode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedMode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    // 2. Envolvemos la app con el Provider para que esté disponible globalmente
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const EslabonApp(),
    ),
  );
}

class EslabonApp extends StatelessWidget {
  const EslabonApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Escuchamos los cambios del tema global
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Eslabón Mobile Taller CDS',
      debugShowCheckedModeBanner: false,

      // Conectamos el ThemeMode controlado globalmente
      themeMode: themeProvider.themeMode,

      // Tema Claro
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC9A227),
          brightness: Brightness.light,
        ),
      ),

      // Tema Oscuro
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC9A227),
          brightness: Brightness.dark,
        ),
      ),

      // 4. Definimos el Login como la pantalla inicial obligatoria
      initialRoute: '/login',

      // 5. Mapa de rutas para navegar entre autenticación y la app principal
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegistroEmpresaView(),
        '/recover': (context) => const RecoverPasswordView(),
        '/home': (context) =>
            const MainNavigationView(), // Tu menú principal de Eslabón
        '/dashboard': (context) => const DashboardPage(), // Ruta para el Dashboard
        '/empleados': (context) => const EmpleadosView(), // Ruta para la vista de empleados
        '/ventas': (context) => const VentasView(), // Ruta para la vista de ventas
      },
    );
  }
}
