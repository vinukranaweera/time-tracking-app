import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'provider/project_task_provider.dart';
import 'provider/time_entry_provider.dart';
import 'screens/home_screen.dart';
import 'screens/project_management_screen.dart';
import 'screens/task_management_screen.dart';

// void main() {
//   runApp(MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({Key? key, required this.localStorage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
        ChangeNotifierProvider(
          create: (_) => ProjectTaskProvider(localStorage),
        ),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          datePickerTheme: DatePickerThemeData(
            backgroundColor:
                Colors.white, // Global background color for date pickers
            headerBackgroundColor: Colors.teal, // Header background
            headerForegroundColor: Colors.white, // Header text color
            dayOverlayColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return Colors.teal; // Color for selected day
              }
              if (states.contains(MaterialState.hovered)) {
                return Colors.teal; // Color for hovered day
              }
              return null; // Use default for other states
            }),
            confirmButtonStyle: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                Colors.teal,
              ), // OK button text color
            ),
            cancelButtonStyle: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
                Colors.teal,
              ), // Cancel button text color
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        // home: HomeScreen(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Main entry point, HomeScreen
          '/manage_projects': (context) =>
              ProjectManagementScreen(), // Route for managing categories
          '/manage_tasks': (context) =>
              TaskManagementScreen(), // Route for managing tags
        },
      ),
    );
  }
}
