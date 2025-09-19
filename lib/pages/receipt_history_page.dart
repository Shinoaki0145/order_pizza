import 'package:flutter/material.dart';
import 'package:order_pizza/models/receipt_history.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReceiptHistoryPage extends StatelessWidget{
  const ReceiptHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt History"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [Consumer<ReceiptHistory>(builder: (context, history, child) {
          if (history.items.isEmpty) {
            return Expanded(child: Center(child: Text("No receipts")));
          }
          return Expanded(child: ListView.builder(
              itemCount: history.items.length,
              itemBuilder: (context, index) {
                final item = history.items[index];
                final datetime = item['DateTime'].toDate();
                return GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text("Date", style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("${datetime.day}/${datetime.month}/${datetime.year}"),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Total Items", style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("${item['Total-Items']}"),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Total Price", style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("\$${item['Total-Price'].toStringAsFixed(2)}"),
                            ],
                          ),
                          Icon(
                            Icons.more_horiz
                          ),
                        ],
                      )
                  ),
                  onTap: () {
                    final receiptDetail = StringBuffer();
                    receiptDetail.writeln(DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime));
                    receiptDetail.writeln();
                    receiptDetail.writeln("--------------");
                    for (final food in item['items']) {
                      receiptDetail.writeln("${food['quantity']}x ${food['food-name']} - \$${food['food-price']}");
                      if (food.containsKey('add-on')) {
                        receiptDetail.writeln("  Add ons: ${food['add-on']
                            .map((addon) => "${addon['name']} (\$${addon['price']})")
                            .join(", ")}");
                      }
                      receiptDetail.writeln();
                    }
                    receiptDetail.writeln("--------------");
                    receiptDetail.writeln();
                    receiptDetail.writeln("Total Items: ${item['Total-Items']}");
                    receiptDetail.writeln("Shipping Fee: \$${item['Shipping Fee']}");
                    receiptDetail.writeln("Total Price: \$${item['Total-Price'].toStringAsFixed(2)}");

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Center(child: Text("Receipt Details")),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
                          )
                        ],
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Text("$receiptDetail"),
                              Text(""),
                              Text(""),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.person),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Thien Nhan",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        "Shipper",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 5),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () => launchUrlString("sms:+84-0814313950"),
                                          icon: const Icon(Icons.message),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () => launchUrlString("tel:+84-0814313950"),
                                          icon: const Icon(Icons.phone),
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ),
                      )
                    );
                  }
                );
              }));
        })],
      ),
    );
  }
}