import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'irvans2731@gmail.com',
      queryParameters: {'subject': 'Bantuan Aplikasi Toko'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }

  void _launchWhatsApp() async {
    const url = 'https://wa.me/6282123048478';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bantuan'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kontak', icon: Icon(Icons.contact_support)),
              Tab(text: 'Panduan', icon: Icon(Icons.help)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Kontak
            _buildContactTab(),
            // Tab Panduan
            _buildGuideTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Butuh Bantuan?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tim support kami siap membantu Anda. '
            'Silakan hubungi melalui salah satu cara berikut:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          _buildContactCard(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'Irvans2731@gmail.com',
            color: Colors.red,
            onTap: _launchEmail,
          ),
          const SizedBox(height: 20),
          _buildContactCard(
            icon: Icons.phone,
            title: 'WhatsApp',
            subtitle: '+62 821-2304-8478',
            color: Colors.green,
            onTap: _launchWhatsApp,
          ),
          const SizedBox(height: 20),
          _buildContactCard(
            icon: Icons.access_time,
            title: 'Jam Operasional',
            subtitle: 'Senin-Jumat: 08.00-17.00 WIB',
            color: Colors.orange,
          ),
          const Spacer(),
          const Center(
            child: Text(
              '© 2025 Irvans Studio\nVersi 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panduan Penggunaan Aplikasi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          _buildGuideStep(
            step: 1,
            title: 'Membuat Akun Toko',
            content: '1. Buka menu "Pengaturan Akun"\n'
                '2. Isi Nama Toko, Kode Masuk, dan Password\n'
                '3. Klik "Simpan Akun" untuk menyimpan data',
          ),
          const SizedBox(height: 20),
          _buildGuideStep(
            step: 2,
            title: 'Berbagi Akses Shift',
            content: '1. Berikan Nama Toko, Kode Masuk, dan Password ke shift berikutnya\n'
                '2. Shift baru harus login dengan kredensial yang sama\n'
                '3. Semua perubahan data akan tersinkronisasi',
          ),
          const SizedBox(height: 20),
          _buildGuideStep(
            step: 3,
            title: 'Tambah/Hapus Kategori',
            content: '1. Buka menu "Kelola Kategori"\n'
                '2. Untuk tambah kategori: Klik "+", isi nama kategori\n'
                '3. Untuk hapus kategori: Geser ke kiri pada kategori, lalu pilih hapus',
          ),
          const SizedBox(height: 20),
          _buildGuideStep(
            step: 4,
            title: 'Mengisi Laporan Harian',
            content: '1. Buka menu "Laporan Harian"\n'
                '2. Isi semua data transaksi sesuai shift\n'
                '3. Pastikan semua kolom terisi dengan benar',
          ),
          const SizedBox(height: 20),
          _buildGuideStep(
            step: 5,
            title: 'Generate Laporan',
            content: '1. Setelah selesai mengisi, klik "Simpan Sementara"\n'
                '2. Klik "Generate Laporan" untuk membuat ringkasan\n'
                '⚠️ PERINGATAN: Pastikan sudah klik simpan sebelum pindah user, '
                'jika tidak data akan hilang!',
            warning: true,
          ),
          const SizedBox(height: 20),
          _buildGuideStep(
            step: 6,
            title: 'Salin & Atur Shift',
            content: '1. Setelah generate, klik "Salin Laporan" untuk menyalin ke clipboard\n'
                '2. Jika tidak ada transaksi shift 3: '
                'Klik tombol "3s" di pojok kanan atas untuk menghilangkan kolom shift 3',
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '© 2025 Irvans Studio\nVersi 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideStep({
    required int step,
    required String title,
    required String content,
    bool warning = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: Text(step.toString()),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: warning ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}