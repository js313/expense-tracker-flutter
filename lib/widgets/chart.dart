import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalAmount = 0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalAmount += recentTransactions[i].amount;
        }
      }
      return {
        'day': weekDay,
        'amount': totalAmount,
      };
    });
  }

  double get weeklyTotalAmount {
    double amount = 0;
    for (int i = 0; i < recentTransactions.length; i++) {
      amount += recentTransactions[i].amount;
    }
    return amount;
  }

  const Chart({super.key, required this.recentTransactions});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.reversed.map((e) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: e['day'] as DateTime,
                  amount: e['amount'] as double,
                  totalAmount: weeklyTotalAmount),
            );
          }).toList(),
        ),
      ),
    );
  }
}
