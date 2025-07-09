import 'package:flutter/material.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syarat & Ketentuan'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Kebijakan Privasi'),
            _buildPrivacyPolicy(),
            const SizedBox(height: 30),
            _buildSectionHeader('Syarat & Ketentuan Penggunaan'),
            _buildTermsOfService(),
            const SizedBox(height: 30),
            _buildSectionHeader('Komitmen Kami'),
            _buildCommitment(),
            const SizedBox(height: 30),
            _buildContactInfo(),
            const SizedBox(height: 20),
            _buildAcceptButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kami sangat menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi yang Anda berikan kepada kami.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          '1. Data yang Kami Kumpulkan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Kami hanya mengumpulkan data yang diperlukan untuk menyediakan layanan kami, seperti informasi toko, kode masuk, dan informasi kontak. Kami tidak mengumpulkan data sensitif tanpa persetujuan eksplisit Anda.',
        ),
        SizedBox(height: 10),
        Text(
          '2. Penggunaan Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Data yang kami kumpulkan hanya digunakan untuk:',
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Menyediakan dan memelihara layanan kami'),
              Text('• Memproses transaksi Anda'),
              Text('• Memberikan dukungan pelanggan'),
              Text('• Mengirim pembaruan penting terkait layanan'),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          '3. Perlindungan Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Kami menerapkan langkah-langkah keamanan teknis dan organisasi yang sesuai untuk melindungi data Anda dari akses, pengungkapan, atau penggunaan yang tidak sah.',
        ),
      ],
    );
  }

  Widget _buildTermsOfService() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dengan menggunakan aplikasi TokoMu, Anda menyetujui syarat dan ketentuan berikut:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          '1. Penggunaan Layanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Anda setuju untuk menggunakan aplikasi ini sesuai dengan hukum yang berlaku dan tidak untuk tujuan yang melanggar hukum atau merugikan pihak lain.',
        ),
        SizedBox(height: 10),
        Text(
          '2. Akun Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Anda bertanggung jawab penuh atas kerahasiaan kode masuk dan password Anda. Segala aktivitas yang terjadi di bawah akun Anda menjadi tanggung jawab Anda.',
        ),
        SizedBox(height: 10),
        Text(
          '3. Pembatasan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Anda tidak diperbolehkan:',
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Menyalahgunakan sistem atau layanan kami'),
              Text('• Mencoba mengakses data pengguna lain tanpa izin'),
              Text('• Melakukan aktivitas yang dapat mengganggu layanan'),
              Text('• Menggunakan aplikasi untuk tujuan ilegal'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommitment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kami berkomitmen untuk:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 15),
        _buildCommitmentCard(
          icon: Icons.security,
          title: 'Tidak Menyalahgunakan Data',
          description: 'Kami tidak akan pernah menggunakan atau mengakses data Anda untuk kepentingan yang jahat, ilegal, atau tanpa persetujuan Anda.'
        ),
        const SizedBox(height: 15),
        _buildCommitmentCard(
          icon: Icons.visibility_off,
          title: 'Tidak Mengintip Aktivitas',
          description: 'Kami tidak mengintip atau memantau aktivitas toko Anda di luar yang diperlukan untuk menyediakan layanan.'
        ),
        const SizedBox(height: 15),
        _buildCommitmentCard(
          icon: Icons.business,
          title: 'Menghormati Bisnis Anda',
          description: 'Kami menghormati bahwa data toko Anda adalah milik Anda dan tidak akan digunakan untuk keuntungan kami tanpa izin.'
        ),
        const SizedBox(height: 15),
        _buildCommitmentCard(
          icon: Icons.gavel,
          title: 'Patuh Regulasi',
          description: 'Kami mematuhi semua peraturan perlindungan data yang berlaku, termasuk UU PDP Indonesia.'
        ),
      ],
    );
  }

  Widget _buildCommitmentCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(width: 15),
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
                  const SizedBox(height: 5),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      color: Colors.blue.shade50, // Fixed: using .shade50 instead of [50]
      elevation: 0,
      child: const Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertanyaan atau Kekhawatiran?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Jika Anda memiliki pertanyaan tentang kebijakan privasi atau syarat penggunaan kami, silakan hubungi:',
            ),
            SizedBox(height: 10),
            Text(
              'Email: Irvans2731@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Telepon: +62 851 6122 5409',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Jam Operasional: Senin-Jumat, 09.00-17.00 WIB',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Saya Mengerti',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}