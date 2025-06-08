import 'package:flutter/material.dart';
import 'package:flutter_platter/presentation/view/home/dashboard_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: DashboardView());
  }
}
