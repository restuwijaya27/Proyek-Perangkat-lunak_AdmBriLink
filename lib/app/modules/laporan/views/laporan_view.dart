import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:myapp/app/modules/transaksi/controllers/transaksi_controller.dart';
import 'package:myapp/app/modules/transaksi/views/transaksi_update_view.dart';
import 'package:intl/intl.dart'; // Add this for date formatting

class LaporanView extends GetView<LaporanController> {
  void showOption(String id) async {
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005DAA), Color(0xFF00A3E1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pilih Aksi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildOptionTile(
                icon: Icons.edit,
                title: 'Update',
                onTap: () {
                  Get.back();
                  Get.to(
                    TransaksiUpdateView(),
                    arguments: id,
                  );
                },
              ),
              _buildOptionTile(
                icon: Icons.delete,
                title: 'Delete',
                onTap: () {
                  Get.back();
                  controller.delete(id);
                },
              ),
              _buildOptionTile(
                icon: Icons.close,
                title: 'Close',
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot<Object?>>(
        stream: Get.put(TransaksiController()).streamData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var listAllDocs = snapshot.data?.docs ?? [];
            return listAllDocs.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE6F2FF), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: listAllDocs.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        var data =
                            listAllDocs[index].data() as Map<String, dynamic>;

                        // Format the date if it's a Timestamp
                        String formattedDate = data["tanggal"] != null
                            ? DateFormat('dd MMM yyyy')
                                .format((data["tanggal"] as Timestamp).toDate())
                            : 'N/A';

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ExpansionTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF005DAA),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              data["nama"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF005DAA),
                              ),
                            ),
                            subtitle: Text(
                              "nomer_rekening: ${data["nomer_rekening"]}",
                              style: TextStyle(
                                color: Colors.blue.shade700,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Color(0xFF005DAA),
                              ),
                              onPressed: () =>
                                  showOption(listAllDocs[index].id),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow(
                                      'Jenis Transaksi',
                                      data["jenis_transaksi"] ?? 'N/A',
                                    ),
                                    _buildDetailRow(
                                      'Nominal',
                                      data["nominal"] ?? 'N/A',
                                    ),
                                    _buildDetailRow(
                                      'Tanggal',
                                      formattedDate,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty_state.png',
                          width: 200,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Tidak ada data",
                          style: TextStyle(
                            color: Color(0xFF005DAA),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF005DAA),
            ),
          );
        },
      ),
    );
  }

  // Helper method to create consistent detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF005DAA),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
