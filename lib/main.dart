import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(255,77,0,1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(255,77,0,1),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white, fontSize: 24),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MM'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentAmount = 0;
  String _input = "0";
  String _currency = "¥";
  final List<String> _transactionHistory = [];

  void _updateInput(String value) {
    setState(() {
      if (_input == "0") {
        _input = value;
      } else {
        _input += value;
      }
    });
  }

  void _incrementAmount() {
    setState(() {
      int amount = int.parse(_input);
      _currentAmount += amount;
      _transactionHistory.insert(0, "＋$_currency${NumberFormat.decimalPattern().format(amount)}");
      _input = "0";
    });
  }

  void _decrementAmount() {
    setState(() {
      int amount = int.parse(_input);
      _currentAmount -= amount;
      _transactionHistory.insert(0, "ー$_currency${NumberFormat.decimalPattern().format(amount)}");
      _input = "0";
    });
  }

  void _changeCurrency(String currency) {
    setState(() {
      if (_currency == "¥" && currency == "Rp") {
        _currentAmount = _currentAmount * 100;
      } else if (_currency == "Rp" && currency == "¥") {
        _currentAmount = _currentAmount / 100;
      }
      _currency = currency;
    });
  }


  void _deleteLastDigit() {
    setState(() {
      if (_input.length > 1) {
        _input = _input.substring(0, _input.length - 1);
      } else {
        _input = "0"; // Reset to default when empty
      }
    });
  }


  Widget buildNumpadButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero, // Ensures no extra padding
        ),
        child: Center( // Ensures text is centered
          child: Text(
            text,
            style: const TextStyle(fontSize: 28, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildIncrementButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 160,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero, // No extra padding
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 40, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildDecrementButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 160,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero, // No extra padding
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 40, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }


  Widget buildCurrencyButton(String symbol) {
    bool isSelected = _currency == symbol;
    return SizedBox(
      width: 70, // Increase width
      height: 200, // Adjust height
      child: ElevatedButton(
        onPressed: () => _changeCurrency(symbol),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.orange[700] : Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            symbol,
            style: const TextStyle(fontSize: 28, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16), // Adjust as needed
          child: Text(widget.title),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 16),
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(transactionHistory: _transactionHistory),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First Row: Money Amount Display
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Text(
              '$_currency ${NumberFormat.decimalPattern().format(_currentAmount)}',
              style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),

          // Second Row: Currency Buttons, Input Box, and Numpad
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  buildCurrencyButton("¥"),
                  const SizedBox(height: 10),
                  buildCurrencyButton("Rp"),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Container(
                    width: 240,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _input,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildNumpadButton('7', () => _updateInput('7')),
                          const SizedBox(width: 10),
                          buildNumpadButton('8', () => _updateInput('8')),
                          const SizedBox(width: 10),
                          buildNumpadButton('9', () => _updateInput('9')),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildNumpadButton('4', () => _updateInput('4')),
                          const SizedBox(width: 10),
                          buildNumpadButton('5', () => _updateInput('5')),
                          const SizedBox(width: 10),
                          buildNumpadButton('6', () => _updateInput('6')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildNumpadButton('1', () => _updateInput('1')),
                          const SizedBox(width: 10),
                          buildNumpadButton('2', () => _updateInput('2')),
                          const SizedBox(width: 10),
                          buildNumpadButton('3', () => _updateInput('3')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 70),
                          const SizedBox(width: 10),
                          buildNumpadButton('0', () => _updateInput('0')),
                          const SizedBox(width: 10),
                          buildNumpadButton('⌫', _deleteLastDigit),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Third Row: Increment and Decrement Buttons
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDecrementButton('ー', _decrementAmount),
              const SizedBox(width: 10),
              buildIncrementButton('＋', _incrementAmount),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> transactionHistory;

  const HistoryPage({super.key, required this.transactionHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction History")),
      body: transactionHistory.isEmpty
          ? const Center(child: Text("No history yet", style: TextStyle(fontSize: 20)))
          : ListView.builder(
        itemCount: transactionHistory.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(transactionHistory[index], style: const TextStyle(fontSize: 20, color: Colors.white)),
          );
        },
      ),
    );
  }
}
