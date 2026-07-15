import 'package:flutter/material.dart';

void main() {
  runApp(const GreetingApp());
}

class GreetingApp extends StatelessWidget {
  const GreetingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Greeting App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GreetingHomePage(),
    );
  }
}

class GreetingHomePage extends StatefulWidget {
  const GreetingHomePage({super.key});

  @override
  State<GreetingHomePage> createState() => _GreetingHomePageState();
}

class _GreetingHomePageState extends State<GreetingHomePage> {
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
  }

  String _greetingFor(DateTime time) {
    final hour = time.hour;
    if (hour < 12) return 'Good Morning';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _greetingFor(_now);

    return Scaffold(
      appBar: AppBar(title: const Text('Android Greeting App')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Current time: ${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => setState(() => _now = DateTime.now()),
              child: const Text('Refresh Greeting'),
            ),
          ],
        ),
      ),
    );
  }
}
