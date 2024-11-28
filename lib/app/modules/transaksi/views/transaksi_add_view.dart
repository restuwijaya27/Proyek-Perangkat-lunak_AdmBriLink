import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/modules/transaksi/controllers/transaksi_controller.dart';

class TransaksiAddView extends GetView<TransaksiController> {
  const TransaksiAddView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: controller.cNama,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: controller.cNomer_rekening,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Nomer Rekening"),
            ),
            TextField(
              controller: controller.cJenis_transaksi,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Jenis Transaksi"),
            ),
            TextField(
              controller: controller.cNominal,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Nominal"),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => controller.add(
                controller.cNama.text,
                controller.cNomer_rekening.text,
                controller.cJenis_transaksi.text,
                controller.cNominal.text,
              ),
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
