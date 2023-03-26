import 'package:expense_tracker/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  const TransactionList(
      {super.key,
      required this.userTransactions,
      required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: userTransactions.isEmpty
          ? Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'No Transactions for this month.',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 200,
                  child: Image.asset('assets/images/waiting.png'),
                ),
              ],
            )
          : ListView.builder(
              itemCount: userTransactions.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text(
                            '\$ ${userTransactions[index].amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      userTransactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(userTransactions[index].date),
                      // DateFormat('yyyy/MM/dd').format(transaction.date),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        deleteTransaction(userTransactions[index].id);
                      },
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
