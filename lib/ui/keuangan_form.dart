import 'package:flutter/material.dart';
import '../bloc/pengeluaran_bloc.dart';
import '../widget/warning_dialog.dart';
import '../model/pengeluaran.dart';
import 'keuangan_page.dart';


class KeuanganForm extends StatefulWidget {
  Pengeluaran? pengeluaran;
  KeuanganForm({super.key, this.pengeluaran});
  @override
  _KeuanganFormState createState() => _KeuanganFormState();
}

class _KeuanganFormState extends State<KeuanganForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PENGELUARAN";
  String tombolSubmit = "SIMPAN";
  final _expenseTextboxController = TextEditingController();
  final _costTextboxController = TextEditingController();
  final _categoryTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.pengeluaran != null) {
      setState(() {
        judul = "UBAH PENGELUARAN";
        tombolSubmit = "UBAH";
        _expenseTextboxController.text = widget.pengeluaran!.expense!;
        _costTextboxController.text = widget.pengeluaran!.cost.toString();
        _categoryTextboxController.text = widget.pengeluaran!.category!;
      });
    } else {
      judul = "TAMBAH PENGELUARAN";
      tombolSubmit = "SIMPAN";
    }
  }

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
                title: Text(judul),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildCard(_expenseTextField()),
                          const SizedBox(height: 16),
                          _buildCard(_costTextField()),
                          const SizedBox(height: 16),
                          _buildCard(_categoryTextField()),
                          const SizedBox(height: 24),
                          _buttonSubmit()
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

  Widget _buildCard(Widget child) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _expenseTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nama Pengeluaran",
        labelStyle: TextStyle(color: Colors.orange[700]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]!),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _expenseTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Pengeluaran harus diisi";
        }
        return null;
      },
    );
  }

  Widget _costTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Biaya",
        labelStyle: TextStyle(color: Colors.orange[700]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]!),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _costTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Biaya harus diisi";
        }
        return null;
      },
    );
  }

  Widget _categoryTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Kategori",
        labelStyle: TextStyle(color: Colors.orange[700]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]!),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _categoryTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kategori harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        tombolSubmit,
        style: const TextStyle(fontSize: 18),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.pengeluaran != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Pengeluaran createPengeluaran = Pengeluaran(id: null);
    createPengeluaran.expense = _expenseTextboxController.text;
    createPengeluaran.cost = int.parse(_costTextboxController.text);
    createPengeluaran.category = _categoryTextboxController.text;

    PengeluaranBloc.addPengeluaran(pengeluaran: createPengeluaran).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const PengeluaranPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
          ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Pengeluaran updatePengeluaran = Pengeluaran(id: widget.pengeluaran!.id!);
    updatePengeluaran.expense = _expenseTextboxController.text;
    updatePengeluaran.cost = int.parse(_costTextboxController.text);
    updatePengeluaran.category = _categoryTextboxController.text;

    PengeluaranBloc.updatePengeluaran(pengeluaran: updatePengeluaran).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const PengeluaranPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}