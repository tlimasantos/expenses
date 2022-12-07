import 'dart:io';
import 'dart:math';

import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'components/chart.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
        cardTheme: CardTheme(
          color: Colors.grey.shade100,
        ),
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        backgroundColor: Colors.purple,
        primaryColor: Colors.purple,
        textTheme: tema.textTheme.copyWith(
          bodyText2: TextStyle(
            fontFamily: 'Quicksand',
            color: Colors.grey.shade700,
          ),
          headline5: const TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.purple,
          ),
          headline6: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: 1,
    //   title: "Mercado",
    //   value: 432.95,
    //   date: DateTime.now().subtract(Duration(days: 5)),
    // ),
    // Transaction(
    //   id: 2,
    //   title: "Tênis",
    //   value: 199.99,
    //   date: DateTime.now().subtract(const Duration(days: 3)),
    // ),
  ];

  bool _displayChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((t) {
      return t.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final _newTransaction = Transaction(
      id: Random().nextInt(10000) + 1,
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(_newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(int id) {
    setState(() {
      _transactions.removeWhere((t) => t.id == id);
    });
  }

  _openAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final mediaQuery = MediaQuery.of(context);

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text("Despesas Pessoais"),
      actions: [
        if (isLandscape)
          IconButton(
            icon: Icon(_displayChart ? Icons.list : Icons.show_chart_rounded),
            onPressed: () {
              setState(() {
                _displayChart = !_displayChart;
              });
            },
          ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openAddTransactionModal(context),
        ),
      ],
    );
    final avaliableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // if (isLandscape)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text("Exibir Gráfico"),
              //       Switch.adaptive(
              //         value: _displayChart,
              //         activeColor: Colors.purple,
              //         onChanged: ((value) {
              //           setState(() {
              //             _displayChart = value;
              //           });
              //         }),
              //       )
              //     ],
              //   ),
              if (_displayChart || !isLandscape)
                Container(
                  height: avaliableHeight * (isLandscape ? 0.8 : 0.3),
                  child: Chart(_recentTransactions),
                ),
              if (!_displayChart || !isLandscape)
                Container(
                  height: avaliableHeight * (isLandscape ? 1 : 0.7),
                  child: TransactionList(_transactions, _removeTransaction),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: !isLandscape && Platform.isAndroid
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _openAddTransactionModal(context),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
