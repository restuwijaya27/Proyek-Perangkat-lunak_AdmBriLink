import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransaksiController extends GetxController {
  // Controllers for form fields
  final TextEditingController cNama = TextEditingController();
  final TextEditingController cNomerRekening = TextEditingController();
  final TextEditingController cJenisTransaksi = TextEditingController();
  final TextEditingController cNominal = TextEditingController();
  final TextEditingController cTanggal = TextEditingController();
  final TextEditingController cKodeStruk = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch all transactions
  Future<QuerySnapshot<Object?>> getData() async {
    return firestore.collection('transaksi').get();
  }

  // Stream of transactions data
  Stream<QuerySnapshot<Object?>> streamData() {
    return firestore.collection('transaksi').snapshots();
  }

  // Add a new transaction
  Future<void> addTransaction({
    required String nama,
    required String nomerRekening,
    required String jenisTransaksi,
    required String nominal,
    required String kodeStruk,
  }) async {
    try {
      await firestore.collection("transaksi").add({
        "nama": nama,
        "nomer_rekening": nomerRekening,
        "jenis_transaksi": jenisTransaksi,
        "nominal": nominal,
        "tanggal": DateTime.now(),
        "kode_struk": kodeStruk,
      });
      _showDialog(
        title: "Success",
        message: "Transaction data saved successfully",
        onConfirm: _clearFormFields,
      );
    } catch (e) {
      _showDialog(
        title: "Error",
        message: "Failed to add transaction: $e",
      );
    }
  }

  // Fetch transaction by ID
  Future<DocumentSnapshot<Object?>> getDataById(String id) async {
    return firestore.collection("transaksi").doc(id).get();
  }

  // Update transaction
  Future<void> updateTransaction({
    required String id,
    required String nama,
    required String nomerRekening,
    required String jenisTransaksi,
    required String nominal,
    required String kodeStruk,
  }) async {
    try {
      await firestore.collection("transaksi").doc(id).update({
        "nama": nama,
        "nomer_rekening": nomerRekening,
        "jenis_transaksi": jenisTransaksi,
        "nominal": nominal,
        "kode_struk": kodeStruk,
      });
      _showDialog(
        title: "Success",
        message: "Transaction data updated successfully",
        onConfirm: _clearFormFields,
      );
    } catch (e) {
      _showDialog(
        title: "Error",
        message: "Failed to update transaction: $e",
      );
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    try {
      Get.defaultDialog(
        title: "Confirmation",
        middleText: "Are you sure you want to delete this transaction?",
        textConfirm: "Yes",
        textCancel: "No",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        radius: 8,
        onConfirm: () async {
          await firestore.collection("transaksi").doc(id).delete();
          Get.back();
          _showDialog(title: "Success", message: "Transaction deleted successfully");
        },
      );
    } catch (e) {
      _showDialog(
        title: "Error",
        message: "Failed to delete transaction: $e",
      );
    }
  }

  // Clear form fields
  void _clearFormFields() {
    cNama.clear();
    cNomerRekening.clear();
    cJenisTransaksi.clear();
    cNominal.clear();
    cTanggal.clear();
    cKodeStruk.clear();
    Get.back();
  }

  // Show dialog utility
  void _showDialog({required String title, required String message, VoidCallback? onConfirm}) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      onConfirm: onConfirm,
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      radius: 8,
    );
  }

  @override
  void onClose() {
    cNama.dispose();
    cNomerRekening.dispose();
    cJenisTransaksi.dispose();
    cNominal.dispose();
    cTanggal.dispose();
    cKodeStruk.dispose();
    super.onClose();
  }

  String formatCurrency(String nominal) {
    try {
      int amount = int.parse(nominal.replaceAll(RegExp(r'[^0-9]'), ''));
      return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
    } catch (e) {
      return nominal;
    }
  }
}
