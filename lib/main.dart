import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list1/data/data.dart';
import 'package:task_list1/data/repo/repository.dart';
import 'package:task_list1/data/source/hive_task_source.dart';
import 'package:task_list1/screens/home/home.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryFixedColor));
  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) =>
          Repository<TaskEntity>(HiveTaskDtatSource(Hive.box(taskBoxName))),
      child: const MyApp()));
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryFixedColor = Color(0xff5C0AFF);
const secondryTextColor = Color(0xffAFBED0);
const normalPriority = Color(0xffF09890);
const highPriority = primaryColor;
const lowPriority = Color(0xff3BE1F1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        textTheme: GoogleFonts.poppinsTextTheme(
            TextTheme(headlineSmall: TextStyle(fontWeight: FontWeight.bold))),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: secondryTextColor),
          border: InputBorder.none,
          prefixIconColor: secondryTextColor,
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          primaryFixed: primaryFixedColor,
          background: Color(0xffF3F5F8),
          onSurface: primaryTextColor,
          onPrimary: Colors.white,
          onBackground: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
