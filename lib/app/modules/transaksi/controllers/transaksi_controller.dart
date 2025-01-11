import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  late TextEditingController cNama;
  late TextEditingController cNomer_rekening;
  late TextEditingController cJenis_transaksi;
  late TextEditingController cNominal;
  late TextEditingController cTanggal;
  late TextEditingController cKode_struk;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> GetData() async {
    CollectionReference transaksi = firestore.collection('transaksi');

    return transaksi.get();
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference transaksi = firestore.collection('transaksi');
    return transaksi.snapshots();
  }

  void add(String nama, String nomer_rekening, String jenis_transaksi,
      String nominal, String tanggal, String kode_struk) async {
    CollectionReference transaksi = firestore.collection("transaksi");

    try {
      await transaksi.add({
        "nama": nama,
        "nomer_rekening": nomer_rekening,
        "jenis_transaksi": jenis_transaksi,
        "nominal": nominal,
        "tanggal": DateTime.now(),
        "kode_struk": kode_struk,
      });
      Get.defaultDialog(
          title: "Berhasil",
          middleText: "Berhasil menyimpan data transaksi",
          onConfirm: () {
            cNama.clear();
            cNomer_rekening.clear();
            cJenis_transaksi.clear();
            cNominal.clear();
            cTanggal.clear();
            cKode_struk.clear();
            Get.back();
            Get.back();
            textConfirm:
            "OK";
          });
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Transaksi.",
      );
    }
  }

  Future<DocumentSnapshot<Object?>> GetDataById(String id) async {
    DocumentReference docRef = firestore.collection("transaksi").doc(id);

    return docRef.get();
  }

  void Update(String nama, String nomer_rekening, String jenis_transaksi,
      String nominal, String kode_struk, String id) async {
    DocumentReference transaksiById = firestore.collection("transaksi").doc(id);

    try {
      await transaksiById.update({
        "nama": nama,
        "nomer_rekening": nomer_rekening,
        "jenis_transaksi": jenis_transaksi,
        "nominal": nominal,
        "kode_struk": kode_struk,
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil mengubah data Transaksi.",
        onConfirm: () {
          cNama.clear();
          cNomer_rekening.clear();
          cJenis_transaksi.clear();
          cNominal.clear();
          cKode_struk.clear();
          Get.back();
          Get.back();
        },
        textConfirm: "OK",
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Transaksi.",
      );
    }
  }

  void delete(String id) {
    DocumentReference docRef = firestore.collection("transaksi").doc(id);

    try {
      Get.defaultDialog(
        title: "Info",
        middleText: "Apakah anda yakin menghapus data ini ?",
        onConfirm: () {
          docRef.delete();
          Get.back();
          Get.defaultDialog(
            title: "Sukses",
            middleText: "Berhasil menghapus data",
          );
        },
        textConfirm: "Ya",
        textCancel: "Batal",
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: "Tidak berhasil menghapus data",
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    cNama = TextEditingController();
    cNomer_rekening = TextEditingController();
    cJenis_transaksi = TextEditingController();
    cNominal = TextEditingController();
    cTanggal = TextEditingController();
    cKode_struk = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    cNama.dispose();
    cNomer_rekening.dispose();
    cJenis_transaksi.dispose();
    cNominal.dispose();
    cTanggal.dispose();
    cKode_struk.dispose();
    super.onClose();
  }
}
