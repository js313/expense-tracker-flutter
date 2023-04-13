import 'dart:io';
import 'dart:math';

import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/user_transactions.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

const String filePath = "expenses.txt";

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
  late Directory directory;
  late File file;

  final List<Transaction> _userTransactions = [];

  void populateTransactions() async {
    String fileContent = await file.readAsString();
    List<String> lines = fileContent.split('\n');
    for (int i = 0; i < lines.length; i++) {
      List<String> vals = lines[i].split(',');
      if (vals.length == 4) {
        setState(() {
          _userTransactions.add(Transaction(
            id: vals[0].toString(),
            title: vals[1].substring(1, vals[1].length - 1),
            amount: double.parse(vals[2]),
            date: DateTime.parse(vals[3]),
          ));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getExternalStorageDirectory().then((dir) {
      setState(() {
        if (dir == null) {
          exit(0);
        } else {
          directory = dir;
          file = File("${directory.path}/$filePath");
          if (!file.existsSync()) {
            file.create(recursive: true);
          } else {
            populateTransactions();
          }
        }
      });
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((element) => element.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  String generateRandomId() {
    Random rand = Random();
    return rand.hashCode.toString();
  }

  void writeToFile(String title, double amount, DateTime date) async {
    String id = generateRandomId();
    await file.writeAsString("$id,\"$title\",$amount,$date\n",
        mode: FileMode.append);
  }

  void _addNewTransaction(String title, double amount, DateTime date) async {
    writeToFile(title, amount, date);
    // final contents = await file.readAsString();
    // print(contents);

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
