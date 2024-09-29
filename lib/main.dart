import 'pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/status.dart';
import 'services/socket_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomePage(),
          'status': (context) => const StatusPage(),
          // 'about': (context) => AboutPage(),
        },
      ),
    );
  }
}
