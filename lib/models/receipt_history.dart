import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptHistory extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  void fetchReceipts() {
    _items.clear();
    if (FirebaseAuth.instance.currentUser == null) return;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection("receipts").doc(userId);
    doc.get().then(
            (snapshot) {
          final data = snapshot.data();
          if (data == null) return;
          data.forEach((id, receipt) {
            _items.add(receipt);
          });
          _items.sort((a, b) => a['DateTime'].toDate().compareTo(b['DateTime'].toDate()));
        }
    );
  }
}