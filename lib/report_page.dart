import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // Tambahkan package share_plus
import 'package:url_launcher/url_launcher.dart'; // Tambahkan package url_launcher
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportPage extends StatefulWidget {
  final String report;

  const ReportPage({super.key, required this.report});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late String _modifiedReport;
  bool _showShift3 = true;
  int _rating = 0; // Untuk menyimpan rating bintang

  @override
  void initState() {
    super.initState();
    _modifiedReport = widget.report;
    _updateReport();
  }

  void _updateReport() {
    if (!_showShift3) {
      // Hapus semua baris yang mengandung "Shift 3"
      final lines = widget.report.split('\n');
      final filteredLines = lines.where((line) => 
          !line.startsWith('-Shift 3') && 
          !line.contains('Shift 3 :') &&
          !line.trim().startsWith('Shift 3')).toList();
      _modifiedReport = filteredLines.join('\n');
    } else {
      _modifiedReport = widget.report;
    }
  }

  void _toggleShift3() {
    setState(() {
      _showShift3 = !_showShift3;
      _updateReport();
    });
  }

  // Fungsi untuk berbagi laporan
  void _shareReport() async {
  final result = await SharePlus.instance.share(
    ShareParams(
      text: _modifiedReport,
      subject: 'Laporan Akhir Shift',
    ),
  );

  if (result.status == ShareResultStatus.success) {
    print('Berhasil membagikan laporan!');
  } else {
    print('User batal membagikan.');
  }
}

  // Fungsi untuk membuka halaman rating
  void _openRatingPage() async {
    const url = 'https://play.google.com/store/apps/details?id=com.andriirv.laporan_akhir_shift'; // Ganti dengan URL aplikasi Anda
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka halaman rating'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    final fullDateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan Toko',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[800]!, Colors.blue[600]!],
            ),
          ),
        ),
        actions: [
          // Tombol toggle Shift 3
          IconButton(
            icon: Icon(
              _showShift3 ? Icons.timer_3 : Icons.timer_3_outlined,
              color: Colors.white,
            ),
            tooltip: _showShift3 ? 'Sembunyikan Shift 3' : 'Tampilkan Shift 3',
            onPressed: _toggleShift3,
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            tooltip: 'Salin laporan',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _modifiedReport));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan disalin ke clipboard'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header dengan tanggal dan info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        dateFormat.format(now),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        timeFormat.format(now),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Konten laporan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header laporan
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'LAPORAN AKHIR SHIFT',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 3,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Status Shift 3
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _showShift3 ? Colors.green[50] : Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _showShift3 ? Colors.green[200]! : Colors.blue[200]!,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _showShift3 ? Icons.visibility : Icons.visibility_off,
                                color: _showShift3 ? Colors.green[700] : Colors.blue[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _showShift3 ? 'Shift 3 Ditampilkan' : 'Shift 3 Disembunyikan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _showShift3 ? Colors.green[700] : Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Isi laporan
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: SelectableText(
                            _modifiedReport,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                        
                        // Footer
                        const SizedBox(height: 24),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Dibuat pada: ${fullDateFormat.format(now)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Share ke teman Tokomu',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  
                                  color: Colors.blueGrey,
                                ),
                              ),
                        const SizedBox(height: 16),
                              
                              // Tombol berbagi ke media sosial
                              Wrap(
                                spacing: 12,
                                children: [
                                  _buildShareButton(
                                      icon: FontAwesomeIcons.whatsapp,
                                      color: const Color(0xFF25D366),
                                      onPressed: () {
                                        // Implementasi khusus WhatsApp bisa ditambahkan di sini
                                        _shareReport();
                                      },
                                    ),
                                  _buildShareButton(
                                    icon: Icons.facebook,
                                    color: const Color(0xFF1877F2),
                                    onPressed: () => _shareReport(),
                                  ),
                                  _buildShareButton(
                                    icon: Icons.email,
                                    color: Colors.blue[800]!,
                                    onPressed: () => _shareReport(),
                                  ),
                                  _buildShareButton(
                                    icon: Icons.more_horiz,
                                    color: Colors.grey[600]!,
                                    onPressed: () => _shareReport(),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              const Text(
                                'Beri rating aplikasi kami:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Rating bintang
                              GestureDetector(
                                onTap: _openRatingPage,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < _rating ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 36,
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ketuk bintang untuk memberi rating',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareApp() {
  SharePlus.instance.share(
    ShareParams(
      text: '''
🚀 *ShiftKu: Laporan Akhir Shift!*

Aplikasi pintar untuk karyawan retail dalam mencatat *penjualan*, *target harian*, hingga *laporan akhir shift* — semua langsung dari HP 📱

✨ *Keuntungan Pakai ShiftKu:*
✅ Tidak perlu lagi bolak - balik hitung kalkulator
✅ Data tersimpan rapi dan bisa diakses kapan saja
✅ Hitung target vs realisasi secara otomatis
✅ Efisiensi waktu
✅ Aman! Bisa diproteksi dengan kode masuk + password
✅ Gratis digunakan dan ringan dipakai!

📲 Download aplikasinya sekarang dan nikmati cara baru tutup shift:

https://play.google.com/store/apps/details?id=com.andriirv.laporan_akhir_shift
''',
    ),
  );
}


  // Widget untuk tombol berbagi
  Widget _buildShareButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 28,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {
    _shareApp();
  },
      ),
    );
  }
}

