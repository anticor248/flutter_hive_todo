import 'package:flutter/material.dart';
import 'package:flutter_todo_hive/data/local_storage.dart';
import 'package:flutter_todo_hive/home_screen.dart';
import 'package:flutter_todo_hive/models/task_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//With this code, it is easy to change storage type
final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

//setup metod for hive
Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  //Hive.openBox<Task>('tasks');

  //await is important for openBox, do not forget that
  var taskBox = await Hive.openBox<Task>('tasks');
}

void main() async {
  //Hive initialized and setup
  WidgetsFlutterBinding.ensureInitialized();
  //
  await setupHive();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO Hive',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const HomeScreen(),
    );
  }
}
