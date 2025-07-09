import 'package:flutter/material.dart';
import 'store_login_page.dart'; // Sesuaikan dengan path yang benar

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    
    // Set timer untuk 4 detik
    Future.delayed(const Duration(seconds: 4), () {
      // Navigasi ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StoreLoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo aplikasi (ganti dengan logo asli)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset('assets/icons/icon.png'),
            ),
            const SizedBox(height: 30),
            // Nama aplikasi
            const Text(
              'Laporan Akhir Shift',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            // Tagline
            const Text(
              'Solusi Laporan Harian Toko',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 50),
            // Loading indicator
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}