/*
  In-Class Activity 6 — Mission Control: Stateful Rocket Launch
  Author: Mohammed Irfan Ahmed
   Collaborator Name : [Safia Shaik]

  Features implemented according to assignment:
  1. Ignite button → increments counter by 1.
  2. Abort button → decrements counter by 1 (cannot go below 0).
  3. Reset button → sets counter back to 0.
  4. Visual status:
      - Red when counter = 0
      - Orange when 1–50
      - Green when >50
  5. Liftoff! → When counter = 100, show message on screen and prevent >100.
  6. Bonus → Congratulatory popup when Liftoff! is reached.
*/

import 'package:flutter/material.dart';

void main() => runApp(const RocketApp());

class RocketApp extends StatelessWidget {
  const RocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  bool _shownPopup = false;

  void _setCounter(int value) {
    final clamped = value.clamp(0, 100);
    final reachedLiftoff = (clamped == 100 && _counter != 100);
    setState(() {
      _counter = clamped;
    });
    if (reachedLiftoff) _onLiftoff();
  }

  void _ignite() => _setCounter(_counter + 1);
  void _abort() => _setCounter(_counter - 1);
  void _reset() {
    _shownPopup = false;
    _setCounter(0);
  }

  void _onLiftoff() {
    // Show "LIFTOFF!" popup
    if (!_shownPopup && mounted) {
      _shownPopup = true;
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('LIFTOFF! 🚀'),
            content: const Text('Fuel is full at 100. We have liftoff!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Color _getColor() {
    if (_counter == 0) return Colors.red;
    if (_counter <= 50) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display counter value
          Text(
            _counter == 100 ? "LIFTOFF!" : '$_counter',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 20),

          // Slider to adjust fuel
          Slider(
            min: 0,
            max: 100,
            divisions: 100,
            value: _counter.toDouble(),
            onChanged: (value) => _setCounter(value.toInt()),
            activeColor: color,
            inactiveColor: Colors.grey,
          ),
          const SizedBox(height: 20),

          // Ignite, Abort, Reset buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _ignite,
                child: const Text('Ignite +1'),
              ),
              ElevatedButton(
                onPressed: _abort,
                child: const Text('Abort -1'),
              ),
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 