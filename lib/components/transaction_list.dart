import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(int) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    transactions.sort(((t1, t2) => t1.date.compareTo(t2.date)));

    return transactions.isEmpty
        ? LayoutBuilder(builder: ((ctx, constraints) {
            return Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Nenhuma transação cadastrada!",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          }))
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final t = transactions[index];

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text("R\$${t.value.toStringAsFixed(2)}"),
                      ),
                    ),
                    backgroundColor: Theme.of(context).backgroundColor,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(
                    t.title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                    DateFormat("EEEE, dd MMM y", "pt_BR").format(t.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 480
                      ? TextButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text("Excluir"),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).errorColor,
                          ),
                          onPressed: () => onRemove(t.id),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => onRemove(t.id),
                        ),
                ),
              );

              // return Card(
              //   child: Row(children: <Widget>[
              //     Container(
              //       margin: const EdgeInsets.symmetric(
              //         horizontal: 15,
              //         vertical: 10,
              //       ),
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Theme.of(context).colorScheme.primary,
              //           width: 2,
              //         ),
              //       ),
              //       padding: const EdgeInsets.all(10),
              //       child: Text(
              //         "R\$ ${t.value.toStringAsFixed(2)}",
              //         style: Theme.of(context).textTheme.headline5,
              //       ),
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           t.title,
              //           style: const TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16,
              //           ),
              //         ),
              //         Text(
              //           DateFormat("EEEE, dd MMM y", "pt_BR").format(t.date),
              //           style: TextStyle(color: Colors.grey.shade600),
              //         )
              //       ],
              //     )
              //   ]),
              // );
            },
          );
  }
}
