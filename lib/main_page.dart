import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'login.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // ================= API=================
  //alamat ip 
  final url = Uri.parse('http://192.168.1.13/app_travel_api/catatan_perjalanan.php');

  // ================= COLOR THEME =================
  static const Color primaryTeal = Color.fromARGB(255, 2, 132, 132);

  // ================= GET DATA (READ) =================
  // mengambil semua data dari server
  Future<List<dynamic>> getData() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // convert JSON → List
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  // ================= CREATE DATA (POST) =================
  // menambah catatan baru ke database
  Future<void> tambahData(
      String kategori, String biaya, String tanggal, String catatan) async {
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "kategori": kategori,
        "biaya": biaya,
        "tanggal": tanggal,
        "catatan": catatan,
      }),
    );
  }

  // ================= DELETE DATA =================
  // menghapus data berdasarkan id
  Future<void> deleteData(String id) async {
    await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );
  }

  // ================= INPUT STYLE =================
  // styling input biar konsisten dan lebih modern
  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF4F7F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  // ================= FORM TAMBAH DATA =================
  void showForm() {
    final biaya = TextEditingController();
    final tanggal = TextEditingController();
    final catatan = TextEditingController();

    List<String> kategoriList = [
      'Transportasi',
      'Akomodasi',
      'Konsumsi',
      'Tiket Wisata',
      'Sewa Alat',
      'Lainnya'
    ];

    String selectedKategori = kategoriList[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ================= TITLE =================
                  const Text(
                    'Tambah Catatan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= DROPDOWN KATEGORI =================
                  DropdownButtonFormField(
                    value: selectedKategori,
                    items: kategoriList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setStateModal(() {
                        selectedKategori = val!;
                      });
                    },
                    decoration: inputStyle('Kategori'),
                  ),

                  const SizedBox(height: 12),

                  // ================= INPUT BIAYA =================
                  TextField(
                    controller: biaya,
                    keyboardType: TextInputType.number,
                    decoration: inputStyle('Biaya'),
                  ),

                  const SizedBox(height: 12),

                  // ================= DATE PICKER =================
                  TextField(
                    controller: tanggal,
                    readOnly: true,
                    decoration: inputStyle('Tanggal').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        tanggal.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  // ================= INPUT CATATAN =================
                  TextField(
                    controller: catatan,
                    decoration: inputStyle('Catatan'),
                  ),

                  const SizedBox(height: 20),

                  // ================= BUTTON SIMPAN =================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        if (biaya.text.isEmpty) return;

                        // kirim data ke API
                        await tambahData(
                          selectedKategori,
                          biaya.text,
                          tanggal.text,
                          catatan.text,
                        );

                        Navigator.pop(context); // tutup bottom sheet
                        setState(() {}); // refresh UI
                      },
                      child: const Text('Simpan'),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================= MAIN UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryTeal,
        title: const Text(
          'Catatan Perjalanan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // logout ke halaman login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
              );
            },
          )
        ],
      ),

      // ================= LIST DATA =================
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data as List;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada catatan',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              var item = data[index];

              // ================= CARD ITEM =================
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // ICON
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.travel_explore,
                          color: primaryTeal),
                    ),

                    const SizedBox(width: 12),

                    // DETAIL DATA
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['kategori'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Rp ${item['biaya']}',
                            style: const TextStyle(
                              color: primaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            item['tanggal'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            item['catatan'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    // DELETE BUTTON
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await deleteData(item['id']);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      // ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryTeal,
        onPressed: showForm,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}