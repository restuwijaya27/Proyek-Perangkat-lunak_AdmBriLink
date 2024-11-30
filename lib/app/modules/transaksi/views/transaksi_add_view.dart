import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/transaksi/controllers/transaksi_controller.dart';

class TransaksiAddView extends GetView<TransaksiController> {
  const TransaksiAddView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.cTanggal.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Tambah Transaksi BRI Link', 
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Color(0xFF005FAE), // BRI Blue
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20)
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: controller.cNama,
                    label: "Nama Lengkap",
                    icon: Icons.person,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.cNomer_rekening,
                    label: "Nomor Rekening",
                    icon: Icons.credit_card,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.cJenis_transaksi,
                    label: "Jenis Transaksi",
                    icon: Icons.swap_horiz,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.cNominal,
                    label: "Nominal Transaksi",
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.cKode_struk,
                    label: "Kode Struk",
                    icon: Icons.description,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  _buildDateField(context),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () => controller.add(
                      controller.cNama.text,
                      controller.cNomer_rekening.text,
                      controller.cJenis_transaksi.text,
                      controller.cNominal.text,
                      controller.cTanggal.text,
                      controller.cKode_struk.text,
                    ),
                    style: ElevatedButton.styleFrom( // BRI Blue
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: Text(
                      "Simpan Transaksi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF005FAE)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[200]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF005FAE), width: 2),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextField(
      controller: controller.cTanggal,
      readOnly: true,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: "Tanggal Transaksi",
        prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF005FAE)),
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range, color: Color(0xFF005FAE)),
          onPressed: () => _selectDate(context),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[200]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF005FAE), width: 2),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF005FAE), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      controller.cTanggal.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}