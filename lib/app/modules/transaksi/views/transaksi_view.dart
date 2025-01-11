import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/transaksi/controllers/transaksi_controller.dart';
import 'package:myapp/app/modules/transaksi/views/transaksi_add_view.dart';
import 'package:myapp/app/modules/transaksi/views/transaksi_update_view.dart';

class TransaksiView extends StatelessWidget {
  final TransaksiController controller = Get.put(TransaksiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 35, 126),
     appBar: AppBar(
  elevation: 0,
  backgroundColor: Colors.transparent, // Membuat AppBar transparan
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white), // Warna ikon sesuai
    onPressed: () {
      Get.offAll(() => HomeView());
    },
  ),
),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3F51B5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeaderSection(),
              Expanded(
                child: _buildTransactionList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAddTransactionButton(),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 500),
            tween: Tween(begin: 0, end: 1),
            builder: (context, opacity, child) {
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - opacity)),
                  child: child,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaksi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Kelola Transaksi Anda dengan Mudah',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.streamData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500),
              tween: Tween(begin: 0, end: 1),
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - opacity)),
                    child: child,
                  ),
                );
              },
              child: _buildTransactionCard(data, snapshot.data!.docs[index].id),
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> data, String docId) {
    return GestureDetector(
      onTap: () => _showTransactionDetails(data),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Icon(
              _getIconForTransactionType(data["jenis_transaksi"]),
              color: Colors.white,
            ),
          ),
          title: Text(
            data["nama"],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            _formatCurrency(data["nominal"]),
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showTransactionOptions(docId),
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> data) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Transaksi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              SizedBox(height: 20),
              _buildDetailRow('Nama', data['nama']),
              _buildDetailRow('Nomor Rekening', data['nomer_rekening']),
              _buildDetailRow('Jenis Transaksi', data['jenis_transaksi']),
              _buildDetailRow('Kode Struk', data['kode_struk']),
              _buildDetailRow('Nominal', _formatCurrency(data['nominal'])),
              _buildDetailRow(
                  'Tanggal',
                  DateFormat('dd MMM yyyy')
                      .format((data['tanggal'] as Timestamp).toDate())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 100,
            color: Colors.white54,
          ),
          SizedBox(height: 20),
          Text(
            'Tidak Ada Transaksi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tambahkan transaksi pertama Anda',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTransactionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.to(() => TransaksiAddView()),
      backgroundColor: Colors.white,
      icon: Icon(Icons.add, color: Color(0xFF1A237E)),
      label: Text(
        'Tambah Transaksi',
        style: TextStyle(
          color: Color(0xFF1A237E),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showTransactionOptions(String docId) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Update'),
              onTap: () {
                Get.back();
                Get.to(() => TransaksiUpdateView(), arguments: docId);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
              onTap: () {
                Get.back();
                controller.delete(docId);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(String value) {
    // Remove any non-numeric characters
    String cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse the cleaned string to an integer
    int? parsedValue = int.tryParse(cleanedValue);

    // Return formatted currency or original value if parsing fails
    return parsedValue != null
        ? NumberFormat.currency(
                locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(parsedValue)
        : value;
  }

  IconData _getIconForTransactionType(String type) {
    switch (type?.toLowerCase()) {
      case 'pemasukan':
        return Icons.arrow_upward;
      case 'pengeluaran':
        return Icons.arrow_downward;
      default:
        return Icons.swap_horiz;
    }
  }
}
