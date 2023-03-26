import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/user_transactions.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      //primarySwatch and colorScheme don't work together have to use this way
      //Or use this way instead https://stackoverflow.com/a/72560799/13103518
      primarySwatch: Colors.green,
      fontFamily: 'Quicksand',
      textTheme: const TextTheme(
        headline6: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return MaterialApp(
      title: 'Personal Expenses',
      theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(secondary: Colors.amber)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', title: "Shoes", amount: 643, date: DateTime(2023, 3, 11)),
    Transaction(id: 't2', title: "Food", amount: 300, date: DateTime.now()),
    Transaction(id: 't3', title: "Wallet", amount: 1099, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((element) => element.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final Transaction newTx =
        Transaction(id: uuid.v4(), title: title, amount: amount, date: date);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (builderCtx) {
          return NewTransaction(addNewTransaction: _addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
              onPressed: () {
                _startAddNewTransaction(context);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Chart(recentTransactions: _recentTransactions),
            ),
            UserTransactions(
              addNewTransaction: _addNewTransaction,
              deleteTransaction: _deleteTransaction,
              userTransactions: _userTransactions,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
