import 'package:expense_tracker/models/transaction.dart';
// import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class UserTransactions extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function addNewTransaction;

  const UserTransactions(
      {super.key,
      required this.addNewTransaction,
      required this.userTransactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // NewTransaction(addNewTransaction: addNewTransaction),
        TransactionList(userTransactions: userTransactions),
      ],
    );
  }
}
