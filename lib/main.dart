import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = "";
  String result = "";
  bool justEvaluated = false;   // <-- NEW FLAG

  void onButtonPress(String value) {
    setState(() {
      if (value == "C") {
        expression = "";
        result = "";
        justEvaluated = false;
        return;
      }

      if (justEvaluated && value != "=") {
        expression = "";
        result = "";
        justEvaluated = false;
      }

      if (value == "=") {
        try {
          final exp = Expression.parse(expression);
          final evaluator = const ExpressionEvaluator();
          final evalResult = evaluator.eval(exp, {});
          result = evalResult.toString();
          expression = "$expression = $result";
        } catch (e) {
          result = "Error";
        }

        justEvaluated = true;   // <-- MARK evaluation happened
        return;
      }

      expression += value;
    });
  }

  Widget buildButton(String text, {Color color = Colors.blue}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => onButtonPress(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 22),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swag's Calculator"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  expression,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  result,
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildButton("/", color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildButton("*", color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildButton("-", color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton("0"),
                    buildButton("^2", color: Colors.purple),   // <-- NEW BUTTON
                    buildButton("=", color: Colors.green),
                    buildButton("+", color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}