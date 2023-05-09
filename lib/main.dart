import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workerr/screens/auth/login_screen.dart';
import 'package:workerr/screens/task_screen.dart';
import 'package:workerr/shared/local/cache_helper.dart';
import 'package:workerr/user_state.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initializedApp = Firebase.initializeApp();

  @override
  @override
  Widget build(
    BuildContext context,
  ) {
    final on = CacheHelper.getData(key: 'onBoarding');
    return FutureBuilder(
        future: _initializedApp,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: Text("Loading App")),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: Text("  An error has been ocured")),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: on != null ? TaskScreen() : Login(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const UserState(),
    );
  }
}
