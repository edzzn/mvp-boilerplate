import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/services/auth_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _counter = 0;
  bool loading = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void goToPayments() async {
    setState(() => loading = true);
    final authNotif = ref.read(authProvider.notifier);
    final url = await authNotif.getUserStripeLink();
    if (url != null) launchUrl(url);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authNotif = ref.watch(authProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: (loading) ? null : goToPayments,
            child: const Text("Payments"),
          ),
          TextButton(onPressed: authNotif.signOut, child: const Text("Logout")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
