import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/transaksi/controllers/transaksi_controller.dart';

class TransaksiAddView extends GetView<TransaksiController> {
  const TransaksiAddView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8), // Soft background color
      appBar: _buildCustomAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              shadowColor: Colors.blue.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderText(),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: controller.cNama,
                        label: "Nama Lengkap",
                        icon: Icons.person_outline,
                        validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        controller: controller.cNomer_rekening,
                        label: "Nomor Rekening",
                        icon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.length < 10 ? 'Nomor rekening tidak valid' : null,
                      ),
                      SizedBox(height: 15),
                      _buildTransactionTypeDropdown(),
                      SizedBox(height: 15),
                      _buildTextField(
                        controller: controller.cNominal,
                        label: "Nominal Transaksi",
                        icon: Icons.monetization_on_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) => double.tryParse(value!) == null ? 'Nominal tidak valid' : null,
                      ),
                      SizedBox(height: 15),
                      _buildTextField(
                        controller: controller.cKode_struk,
                        label: "Kode Struk",
                        icon: Icons.receipt_long_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 15),
                      _buildDateField(context),
                      SizedBox(height: 30),
                      _buildSubmitButton(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildCustomAppBar() {
    return AppBar(
      title: Text(
        'Input Transaksi BRI Link', 
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
      backgroundColor: Color(0xFF005FAE),
      centerTitle: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20)
        )
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      'Masukkan Detail Transaksi',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF005FAE)
      ),
    );
  }

  Widget _buildTransactionTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Jenis Transaksi',
        prefixIcon: Icon(Icons.swap_horiz, color: Color(0xFF005FAE)),
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
      items: [
        'Transfer', 
        'Pembayaran', 
        'Setoran', 
        'Penarikan'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        controller.cJenis_transaksi.text = newValue!;
      },
      validator: (value) => value == null ? 'Pilih jenis transaksi' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: controller.cTanggal,
      readOnly: true,
      validator: (value) => value!.isEmpty ? 'Tanggal harus dipilih' : null,
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

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (controller.formKey.currentState!.validate()) {
          controller.add(
            controller.cNama.text,
            controller.cNomer_rekening.text,
            controller.cJenis_transaksi.text,
            controller.cNominal.text,
            controller.cTanggal.text,
            controller.cKode_struk.text,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF005FAE),
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
              primary: Color(0xFF005FAE),
              onPrimary: Colors.white,
              onSurface: Colors.black,
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