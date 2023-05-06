import 'widgets/chart/chart.dart';
import 'package:flutter/material.dart';

import 'models/expense.dart';
import 'widgets/expenses_list/expenses_list.dart';
import 'widgets/new_expense.dart';

class ExpenseApp extends StatefulWidget {
  const ExpenseApp({super.key});

  @override
  State<ExpenseApp> createState() => _ExpenseAppState();
}

class _ExpenseAppState extends State<ExpenseApp> {
  final List<Expense> _expensesData = [
    Expense(
      title: "Flutter course",
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Javascript course",
      amount: 13.99,
      date: DateTime.now(),
      category: Category.work,
    )
  ];

  void _showModalExpense() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expensesData.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _expensesData.indexOf(expense);
    setState(() {
      _expensesData.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _expensesData.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some."),
    );

    if (_expensesData.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _expensesData,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Tracker",
        ),
        actions: [
          IconButton(
            onPressed: _showModalExpense,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _expensesData),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
