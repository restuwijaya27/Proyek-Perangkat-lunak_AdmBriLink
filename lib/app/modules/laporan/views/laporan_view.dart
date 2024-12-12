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

class _LaporanViewState extends State<LaporanView>
    with SingleTickerProviderStateMixin {
  double _parseNominal(dynamic nominalValue) {
    if (nominalValue == null) return 0;
    String nominalString =
        nominalValue.toString().replaceAll('.', '').replaceAll('Rp', '').trim();
    return double.tryParse(nominalString) ?? 0;
  }

  DateTime? selectedMonth;
  final TransaksiController transaksiController =
      Get.put(TransaksiController());
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
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectMonth(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        int selectedYear = selectedMonth?.year ?? DateTime.now().year;
        int selectedMonthIndex = selectedMonth?.month ?? DateTime.now().month;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pilih Periode Laporan',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005DAA)),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<int>(
                        value: selectedYear,
                        hint: Text('Tahun'),
                        items: List.generate(
                          11,
                          (index) => DropdownMenuItem(
                            value: 2020 + index,
                            child: Text('${2020 + index}'),
                          ),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => selectedYear = value);
                          }
                        },
                      ),
                      DropdownButton<int>(
                        value: selectedMonthIndex,
                        hint: Text('Bulan'),
                        items: [
                          for (int i = 1; i <= 12; i++)
                            DropdownMenuItem(
                                value: i,
                                child: Text(
                                    DateFormat('MMMM').format(DateTime(0, i)))),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => selectedMonthIndex = value);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tombol Batal dengan efek animate dan desain modern
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.red.shade300, width: 1.5),
                          color: Colors.transparent,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.red.shade50,
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Tombol Pilih Periode dengan desain elevated dan modern
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Color(0xFF005DAA), Color(0xFF0077CC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF005DAA).withOpacity(0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            splashColor: Colors.white24,
                            onTap: () {
                              setState(() => selectedMonth =
                                  DateTime(selectedYear, selectedMonthIndex));
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              child: Text(
                                'Pilih Periode',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    Query query = FirebaseFirestore.instance.collection('transaksi');
    if (selectedMonth != null) {
      query = query
          .where('tanggal',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                  DateTime(selectedMonth!.year, selectedMonth!.month, 1)))
          .where('tanggal',
              isLessThan: Timestamp.fromDate(
                  DateTime(selectedMonth!.year, selectedMonth!.month + 1, 1)));
    }
    return query.snapshots();
  }

  Future<Map<String, dynamic>> _calculateMonthlyTotal() async {
    if (selectedMonth == null) return {'total': 0, 'count': 0};

    final querySnapshot = await FirebaseFirestore.instance
        .collection('transaksi')
        .where('tanggal',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTime(selectedMonth!.year, selectedMonth!.month, 1)))
        .where('tanggal',
            isLessThan: Timestamp.fromDate(
                DateTime(selectedMonth!.year, selectedMonth!.month + 1, 1)))
        .get();

    double totalNominal = 0;
    querySnapshot.docs.forEach((doc) {
      var data = doc.data();
      totalNominal += _parseNominal(data['nominal']);
    });

    return {
      'total': totalNominal,
      'count': querySnapshot.docs.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF005DAA)),
          onPressed: () => Get.offAll(() => HomeView()),
        ),
        title: Text(
          'Laporan Transaksi',
          style:
              TextStyle(color: Color(0xFF005DAA), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: Color(0xFF005DAA)),
            onPressed: () => _selectMonth(context),
            tooltip: 'Pilih Periode',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedMonth != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan ${DateFormat('MMMM yyyy').format(selectedMonth!)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005DAA)),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.red),
                      onPressed: () => setState(() => selectedMonth = null),
                    ),
                  ],
                ),
              ),
            FutureBuilder<Map<String, dynamic>>(
              future: _calculateMonthlyTotal(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF005DAA)));
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
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
                          Row(
                            children: [
                              Icon(Icons.calculate_outlined,
                                  color: Colors.white, size: 30),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Transaksi',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                  Text(
                                    'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(data['total'])}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${data['count']} Data',
                              style: TextStyle(
                                  color: Color(0xFF005DAA),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getFilteredStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF005DAA)));
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Terjadi kesalahan: ${snapshot.error}'));
                  }
                  final documents = snapshot.data?.docs ?? [];
                  if (documents.isEmpty) {
                    return Center(
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
                    ));
                  }
                  return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      final timestamp = data['tanggal'] as Timestamp?;
                      final nominal = _parseNominal(data['nominal']);
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          title: Text(
                            data['nama'] ?? 'Nama tidak tersedia',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kode Struk: ${data['kode_struk'] ?? 'N/A'}',
                              ),
                              Text(
                                  'Nomor Rekening: ${data['nomer_rekening'] ?? 'N/A'}'),
                              Text(
                                'Tanggal: ${timestamp != null ? DateFormat('d MMM yyyy').format(timestamp.toDate()) : 'N/A'}',
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Jenis Transaksi: ${data['jenis_transaksi'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '').format(nominal)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
