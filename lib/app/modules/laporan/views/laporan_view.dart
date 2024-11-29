import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:myapp/app/modules/transaksi/controllers/transaksi_controller.dart';

class LaporanView extends StatefulWidget {
  @override
  _LaporanViewState createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> with SingleTickerProviderStateMixin {
  double _parseNominal(dynamic nominalValue) {
    if (nominalValue == null) return 0;
    String nominalString = nominalValue.toString().replaceAll('.', '').replaceAll('Rp', '').trim();
    return double.tryParse(nominalString) ?? 0;
  }

  DateTime? selectedMonth;
  final TransaksiController transaksiController = Get.put(TransaksiController());
  final LaporanController laporanController = Get.put(LaporanController());
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectMonth(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int selectedYear = selectedMonth?.year ?? DateTime.now().year;
      int selectedMonthIndex = selectedMonth?.month ?? DateTime.now().month;

      return AlertDialog(
        title: Text(
          'Pilih Bulan dan Tahun',
          style: TextStyle(
            color: Color(0xFF005DAA),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Year Selection
            DropdownButtonFormField<int>(
              value: selectedYear,
              decoration: InputDecoration(
                labelText: 'Tahun',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF005DAA), width: 2),
                ),
              ),
              items: List.generate(
                11, // Generates years from 2020 to 2030
                (index) => DropdownMenuItem(
                  value: 2020 + index,
                  child: Text('${2020 + index}'),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  selectedYear = value;
                }
              },
            ),
            SizedBox(height: 16),
            
            // Month Selection
            DropdownButtonFormField<int>(
              value: selectedMonthIndex,
              decoration: InputDecoration(
                labelText: 'Bulan',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF005DAA), width: 2),
                ),
              ),
              items: [
                DropdownMenuItem(value: 1, child: Text('Januari')),
                DropdownMenuItem(value: 2, child: Text('Februari')),
                DropdownMenuItem(value: 3, child: Text('Maret')),
                DropdownMenuItem(value: 4, child: Text('April')),
                DropdownMenuItem(value: 5, child: Text('Mei')),
                DropdownMenuItem(value: 6, child: Text('Juni')),
                DropdownMenuItem(value: 7, child: Text('Juli')),
                DropdownMenuItem(value: 8, child: Text('Agustus')),
                DropdownMenuItem(value: 9, child: Text('September')),
                DropdownMenuItem(value: 10, child: Text('Oktober')),
                DropdownMenuItem(value: 11, child: Text('November')),
                DropdownMenuItem(value: 12, child: Text('Desember')),
              ],
              onChanged: (value) {
                if (value != null) {
                  selectedMonthIndex = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            onPressed: () {
              setState(() {
                selectedMonth = DateTime(selectedYear, selectedMonthIndex);
              });
              Navigator.of(context).pop();
            },
            child: Text('Pilih'),
          ),
        ],
      );
    },
  );
}

  Stream<QuerySnapshot> _getFilteredStream() {
    Query query = FirebaseFirestore.instance.collection('transaksi');

    if (selectedMonth != null) {
      query = query.where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(selectedMonth!.year, selectedMonth!.month, 1)))
          .where('tanggal', isLessThan: Timestamp.fromDate(DateTime(selectedMonth!.year, selectedMonth!.month + 1, 1)));
    }

    return query.snapshots();
  }

  Future<Map<String, dynamic>> _calculateMonthlyTotal() async {
    if (selectedMonth == null) return {'total': 0, 'count': 0};

    final querySnapshot = await FirebaseFirestore.instance.collection('transaksi')
        .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(selectedMonth!.year, selectedMonth!.month, 1)))
        .where('tanggal', isLessThan: Timestamp.fromDate(DateTime(selectedMonth!.year, selectedMonth!.month + 1, 1)))
        .get();

    double totalNominal = 0;
    querySnapshot.docs.forEach((doc) {
      var data = doc.data();
      totalNominal += _parseNominal(data['nominal']);
    });

    return {
      'total': totalNominal,
      'count': querySnapshot.docs.length
    };
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF005DAA)),
        onPressed: () {
          Get.offAll(() => HomeView());
        },
      ),
      title: Text(
        'Laporan Transaksi',
        style: TextStyle(
          color: Color(0xFF005DAA),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(Icons.calendar_month, color: Color(0xFF005DAA)),
          onPressed: () => _selectMonth(context),
        ),
      ],
    ),
      body: FadeTransition(
        opacity: _animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Filter Display
            if (selectedMonth != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan ${DateFormat('MMMM yyyy').format(selectedMonth!)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005DAA),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedMonth = null;
                        });
                      },
                      icon: Icon(Icons.clear, color: Colors.white, size: 18),
                      label: Text('Reset', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Monthly Total Summary
            FutureBuilder<Map<String, dynamic>>(
              future: _calculateMonthlyTotal(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF005DAA),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF005DAA), Color(0xFF1E90FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade200,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Transaksi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(snapshot.data!['total'])}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${snapshot.data!['count']} Transaksi',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),

            // Transaction List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getFilteredStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var listAllDocs = snapshot.data?.docs ?? [];
                    return listAllDocs.isNotEmpty
                        ? ListView.builder(
                            itemCount: listAllDocs.length,
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (context, index) {
                              var data = listAllDocs[index].data() as Map<String, dynamic>;

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
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xFF005DAA).withOpacity(0.1),
                                    child: Icon(
                                      Icons.account_balance_wallet,
                                      color: Color(0xFF005DAA),
                                    ),
                                  ),
                                  title: Text(
                                    data["nama"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF005DAA),
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Text(
                                        "Rekening: ${data["nomer_rekening"]}",
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Nominal: Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(_parseNominal(data["nominal"]))}",
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/bri.jpg',
                                  width: 200,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Tidak ada data untuk bulan ini",
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
            ),
          ],
        ),
      ),
    );
  }
}