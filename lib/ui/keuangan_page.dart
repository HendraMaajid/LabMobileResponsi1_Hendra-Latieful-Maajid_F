import 'package:flutter/material.dart';
import '../bloc/logout_bloc.dart';
import '../bloc/pengeluaran_bloc.dart';
import '/model/pengeluaran.dart';
import '/ui/keuangan_detail.dart';
import '/ui/keuangan_form.dart';
import 'login_page.dart';

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  _PengeluaranPageState createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  late int totalPengeluaran;

  @override
  void initState() {
    super.initState();
    totalPengeluaran = 0;
    _hitungTotalPengeluaran();
  }

  Future<void> _hitungTotalPengeluaran() async {
    try {
      final pengeluarans = await PengeluaranBloc.getPengeluarans();
      setState(() {
        totalPengeluaran = pengeluarans.fold(0, (sum, item) => sum + (item.cost ?? 0));
      });
    } catch (e) {
      print("Error menghitung total: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        title: const Text(
          'Beranda Keuangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout, color: Colors.orange),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                          (route) => false)
                });
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _hitungTotalPengeluaran,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                color: Colors.orange.shade100,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pantau dan kelola pengeluaranmu di sini.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Summary Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SummaryCard(
                          title: 'Total Pengeluaran',
                          value: 'Rp ${totalPengeluaran.toString()}',
                          icon: Icons.money_off,
                          color: Colors.orange.shade700,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QuickAccessCard(
                          title: 'Tambah Pengeluaran',
                          icon: Icons.add_circle_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KeuanganForm(),
                              ),
                            ).then((_) {
                              // Refresh data setelah kembali dari form
                              _hitungTotalPengeluaran();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Riwayat Pengeluaran',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              FutureBuilder<List<Pengeluaran>>(
                future: PengeluaranBloc.getPengeluarans(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error: ${snapshot.error}");
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        totalPengeluaran = snapshot.data!.fold(0, (sum, item) => sum + (item.cost ?? 0));
                      });
                    });
                    return ListPengeluaran(list: snapshot.data);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAccessCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAccessCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.orange.shade700),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListPengeluaran extends StatelessWidget {
  final List<Pengeluaran>? list;

  const ListPengeluaran({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list == null ? 0 : list!.length,
        itemBuilder: (context, i) {
          return ItemPengeluaran(pengeluaran: list![i]);
        },
      ),
    );
  }
}

class ItemPengeluaran extends StatelessWidget {
  final Pengeluaran pengeluaran;

  const ItemPengeluaran({super.key, required this.pengeluaran});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KeuanganDetail(
              pengeluaran: pengeluaran,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.yellow[100],
        shadowColor: Colors.orange[300],
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(
                Icons.output_rounded,
                color: Colors.orange.shade700,
                size: 40,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengeluaran.expense!,
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      pengeluaran.category!,
                      style: TextStyle(
                        color: Colors.orange.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Text(
                'Rp ${pengeluaran.cost.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.orange.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}