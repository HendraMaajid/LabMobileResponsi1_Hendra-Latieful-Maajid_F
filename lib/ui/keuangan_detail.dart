import 'package:flutter/material.dart';
import '../bloc/pengeluaran_bloc.dart';
import '../widget/warning_dialog.dart';
import '../model/pengeluaran.dart';
import 'keuangan_form.dart';
import 'keuangan_page.dart';


class KeuanganDetail extends StatefulWidget {
  Pengeluaran? pengeluaran;

  KeuanganDetail({super.key, this.pengeluaran});

  @override
  _KeuanganDetailState createState() => _KeuanganDetailState();
}

class _KeuanganDetailState extends State<KeuanganDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange[400]!,
              Colors.orange[300]!,
              Colors.yellow[200]!,
              Colors.yellow[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text('Detail Pengeluaran'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDetailItem("Pengeluaran", widget.pengeluaran!.expense!, 24),
                          const SizedBox(height: 16),
                          _buildDetailItem("Biaya", "Rp. ${widget.pengeluaran!.cost}", 20),
                          const SizedBox(height: 16),
                          _buildDetailItem("Kategori", widget.pengeluaran!.category!, 20),
                          const SizedBox(height: 24),
                          _tombolHapusEdit()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, double fontSize) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize - 4,
            fontWeight: FontWeight.bold,
            color: Colors.orange[700],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KeuanganForm(
                  pengeluaran: widget.pengeluaran!,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Hapus"),
            onPressed: () {
              PengeluaranBloc.deletePengeluaran(id: widget.pengeluaran!.id!).then(
                    (value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const PengeluaranPage()),
                        (Route<dynamic> route) => false,
                  )
                },
                onError: (error) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                      description: "Hapus gagal, silahkan coba lagi",
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}