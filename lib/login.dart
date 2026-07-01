import 'package:app_travel/db_helper.dart';
import 'package:app_travel/main_page.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Flag untuk switch antara Login & Register
  bool isLogin = true;

  // controller
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _konfirmasiPassword = TextEditingController();

  // variabel warna 
  static const Color primaryTeal = Color.fromARGB(255, 2, 132, 132);
  static const Color deepTeal = Color.fromARGB(255, 1, 90, 90);
  static const Color accentCoral = Color.fromARGB(255, 255, 138, 101);
  static const Color softBg = Color.fromARGB(255, 247, 250, 250);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryTeal,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryTeal, primaryTeal],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: deepTeal.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: primaryTeal,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TravelLog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isLogin
                        ? 'Masuk untuk mulai mencatat perjalananmu'
                        : 'Daftar dan mulai kelola catatan perjalananmu',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                    ),
                  ),
                   const SizedBox(height: 6),
                ],
              ),
            ),

            // container form 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 40, right: 40),
              decoration: const BoxDecoration(
                color: softBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),

              // transform
              transform: Matrix4.translationValues(0, 0, 0),

              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // USERNAME
                  TextField(
                    controller: _username,
                    decoration:
                        _inputDecoration('Username', Icons.person_outline),
                  ),
                  const SizedBox(height: 18),
                  // PASSWORD
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration:
                        _inputDecoration('Password', Icons.lock_outline),
                  ),
                  if (!isLogin) ...[
                    const SizedBox(height: 18),
                    TextField(
                      controller: _konfirmasiPassword,
                      obscureText: true,
                      decoration: _inputDecoration(
                          'Konfirmasi Password', Icons.lock_outline),
                    ),
                  ],
                  const SizedBox(height: 26),
                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {
                        DbHelper db = DbHelper();
                        if (isLogin) {
                          bool loginSukses = await db.checkLogin(
                              _username.text, _password.text);
                          if (loginSukses) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Username/Password salah'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          if (_password.text == _konfirmasiPassword.text && _username.text.isNotEmpty) {
                            await db.register(
                                _username.text, _password.text);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registrasi berhasil'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            setState(() {
                              isLogin = true;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Registrasi gagal'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        isLogin ? 'Login' : 'Registrasi',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 246, 248, 249),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // SWITCH
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'Belum punya akun? Daftar'
                          : 'Sudah punya akun? Login',
                      style: const TextStyle(color: primaryTeal),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // DIVIDER
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'atau lanjutkan dengan',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // SOCIAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _social(Icons.g_mobiledata_rounded, Colors.red),
                      const SizedBox(width: 15),
                      _social(Icons.facebook_rounded, Colors.blue),
                      const SizedBox(width: 15),
                      _social(Icons.camera_alt_outlined, accentCoral),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INPUT STYLE =================
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryTeal),
      filled: true,
      fillColor: softBg,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 156, 156, 156),
          width: 1,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: primaryTeal,
          width: 1.5,
        ),
      ),
    );
  }

  // ================= SOCIAL BUTTON =================
  Widget _social(IconData icon, Color color) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(icon, color: color),
    );
  }
}