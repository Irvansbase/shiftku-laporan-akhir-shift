import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'category_card.dart';
import 'report_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _storeNameController = TextEditingController(text: 'RUKO ROYAL PALEM');
  final TextEditingController _storeCodeController = TextEditingController(text: 'TE24');
  bool _isLoading = true;
  bool _isSaving = false;
  String? _saveStatus; //

  List<Category> categories = [
    Category(name: 'Sales', isCurrency: true),
    Category(name: 'PSM'),
    Category(name: 'PWP'),
    Category(name: 'Serba Gratis'),
    Category(name: 'RTD'),
    Category(name: 'Telur'),
    Category(name: 'Voucher', isCurrency: true),
    Category(name: 'New Member'),
    Category(name: 'SUEGEER'),
  ];

  @override
  void initState() {
    super.initState();
    _loadLastSavedData();
    _setupAutoSaveListeners();
  }

  void _setupAutoSaveListeners() {
    // Listener untuk store name dan code
    _storeNameController.addListener(_autoSaveToSupabase);
    _storeCodeController.addListener(_autoSaveToSupabase);

    // Listener untuk semua controller kategori
    for (var category in categories) {
      for (var controller in category.controllers) {
        controller.addListener(_autoSaveToSupabase);
      }
    }
  }

  Future<void> _loadLastSavedData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeCode = prefs.getString('store_code');
      if (storeCode == null) return;

      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('store_reports')
          .select()
          .eq('store_code', storeCode)
          .order('report_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data != null && data['report_data'] != null) {
        final json = data['report_data'] as Map<String, dynamic>;
        
        // Update store info
        _storeNameController.text = json['store_name'] ?? 'RUKO ROYAL PALEM';
        _storeCodeController.text = json['store_code'] ?? 'TE24';

        // Update kategori
        final loadedCategories = json['categories'] as List;
        for (int i = 0; i < loadedCategories.length && i < categories.length; i++) {
          final categoryData = loadedCategories[i] as Map<String, dynamic>;
          final shifts = categoryData['shifts'] as List;
          
          for (int j = 0; j < shifts.length && j < 3; j++) {
            final shift = shifts[j] as Map<String, dynamic>;
            categories[i].controllers[j * 2].text = shift['target']?.toString() ?? '0';
            categories[i].controllers[j * 2 + 1].text = shift['actual']?.toString() ?? '0';
          }
        }
      }
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _storeNameController.removeListener(_autoSaveToSupabase);
    _storeCodeController.removeListener(_autoSaveToSupabase);
    
    for (var category in categories) {
      for (var controller in category.controllers) {
        controller.removeListener(_autoSaveToSupabase);
        controller.dispose();
      }
    }
    
    _storeNameController.dispose();
    _storeCodeController.dispose();
    super.dispose();
  }

  void _addCategory() {
    setState(() {
      final newCategory = Category(name: 'Kategori Baru');
      // Tambahkan listener untuk controller baru
      for (var controller in newCategory.controllers) {
        controller.addListener(_autoSaveToSupabase);
      }
      categories.add(newCategory);
    });
    _autoSaveToSupabase();
  }

  void _removeCategory(int index) {
    if (categories.length > 1) {
      setState(() {
        for (var controller in categories[index].controllers) {
          controller.dispose();
        }
        categories.removeAt(index);
      });
      _autoSaveToSupabase();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa menghapus, minimal harus ada 1 kategori')),
      );
    }
  }

  void _moveCategory(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    setState(() {
      final Category item = categories.removeAt(oldIndex);
      categories.insert(newIndex, item);
    });
    _autoSaveToSupabase();
  }

  Future<void> _autoSaveToSupabase() async {
  if (_isLoading) return;
  
  try {
    final supabase = Supabase.instance.client;
    final prefs = await SharedPreferences.getInstance();
    final storeCode = prefs.getString('store_code');
    if (storeCode == null) return;

    final reportData = _buildJsonFromControllers();

    // Cek apakah data sudah ada
    final existingData = await supabase
        .from('store_reports')
        .select()
        .eq('store_code', storeCode)
        .maybeSingle();

    if (existingData != null) {
      // Update data yang sudah ada
      await supabase
          .from('store_reports')
          .update({
            'report_date': DateTime.now().toIso8601String(),
            'report_data': reportData,
          })
          .eq('store_code', storeCode);
    } else {
      // Insert data baru
      await supabase
          .from('store_reports')
          .insert({
            'store_code': storeCode,
            'report_date': DateTime.now().toIso8601String(),
            'report_data': reportData,
          });
    }
    
    print('Data auto-saved to Supabase');
  } catch (e) {
    print('Error auto-saving: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan Toko',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addCategory,
            tooltip: 'Tambah Kategori',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadLastSavedData,
            tooltip: 'Muat Ulang Data',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStoreInfoCard(),
            const SizedBox(height: 10),
            _buildCategoryHeader(),
            const SizedBox(height: 6),
            Expanded(child: _buildCategoryList()), // Diubah menjadi Expanded
            const SizedBox(height: 8), // Mengurangi jarak
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreInfoCard() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16 * 0.8), // border radius 20% lebih kecil
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0 * 0.8), // padding dikurangi 20%
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _storeNameController,
                  style: TextStyle(
                    color: Colors.blue[900], 
                    fontWeight: FontWeight.w500, 
                    fontSize: 16 * 0.8, // font size diperkecil 20%
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nama Toko',
                    labelStyle: TextStyle(color: Colors.blue[700], fontSize: 14 * 0.8),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12 * 0.8, horizontal: 16 * 0.8),
                    prefixIcon: Icon(Icons.store, color: Colors.blue[700], size: 24 * 0.8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5 * 0.8), // size box 20% lebih kecil
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _storeCodeController,
                  style: TextStyle(
                    color: Colors.blue[900], 
                    fontWeight: FontWeight.w500,
                    fontSize: 16 * 0.8,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Kode',
                    labelStyle: TextStyle(color: Colors.blue[700], fontSize: 14 * 0.8),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12 * 0.8, horizontal: 16 * 0.8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * 0.8),
          Container(
            padding: const EdgeInsets.all(12 * 0.8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12 * 0.8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18 * 0.8, color: Colors.blue[700]),
                const SizedBox(width: 8 * 0.8),
                Text(
                  'Tanggal: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                  style: TextStyle(
                    fontSize: 16 * 0.8, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildCategoryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Kategori Laporan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          ),
          Text(
            'Drag untuk mengatur urutan',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Expanded(
      child: ReorderableListView.builder(
        itemCount: categories.length,
        onReorder: _moveCategory,
        itemBuilder: (context, index) {
          return CategoryCard(
            key: Key('$index'),
            index: index,
            category: categories[index],
            onRemove: () => _removeCategory(index),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _generateReport(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'GENERATE LAPORAN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
  onPressed: () async {
    // Hide keyboard
    FocusScope.of(context).unfocus();
    
    setState(() {
      _isSaving = true;
      _saveStatus = null;
    });
    
    try {
      await _autoSaveToSupabase();
      setState(() {
        _saveStatus = 'success';
      });
      
      // Reset success status after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _saveStatus = null;
          });
        }
      });
    } catch (e) {
      setState(() {
        _saveStatus = 'error';
      });
      
      // Show detailed error in snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  },
  icon: _isSaving
      ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          ),
        )
      : _saveStatus == 'success'
          ? const Icon(Icons.check, color: Colors.white)
          : const Icon(Icons.save, color: Colors.white),
  label: Text(
    _isSaving
        ? "Menyimpan..."
        : _saveStatus == 'success'
            ? "Tersimpan!"
            : "Simpan Data",
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: _saveStatus == 'success'
        ? Colors.green
        : _saveStatus == 'error'
            ? Colors.red
            : Colors.green,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 3,
    shadowColor: Colors.green.shade800,
  ),
),
        ],
      ),
    );
  }

  void _generateReport(BuildContext context) {
    final report = StringBuffer();
    report.writeln('LAPORAN TOKO ${_storeNameController.text} (${_storeCodeController.text})');
    report.writeln('Tanggal : ${DateFormat('dd/MM/yyyy').format(DateTime.now())}\n');

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      report.writeln('${i + 1}. ${category.name} = Target/Act/Acv%');

      final List<ShiftData> shifts = [];
      for (int j = 0; j < 3; j++) {
        final target = double.tryParse(category.controllers[j * 2].text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final actual = double.tryParse(category.controllers[j * 2 + 1].text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        shifts.add(ShiftData(target: target.toInt(), actual: actual.toInt()));
      }

      final totalTarget = shifts.fold(0, (sum, shift) => sum + shift.target);
      final totalActual = shifts.fold(0, (sum, shift) => sum + shift.actual);

      for (int j = 0; j < 3; j++) {
        final acv = shifts[j].target != 0 ? (shifts[j].actual / shifts[j].target * 100).round() : 0;
        report.write('-${['Shift 3', 'Shift 1', 'Shift 2'][j]} : ');
        if (category.isCurrency) {
          report.write('${_formatCurrency(shifts[j].target)}/');
          report.write('${_formatCurrency(shifts[j].actual)}/');
        } else {
          report.write('${shifts[j].target}/${shifts[j].actual}/');
        }
        report.writeln('$acv%');
      }

      final totalAcv = totalTarget != 0 ? (totalActual / totalTarget * 100).round() : 0;
      report.write('  Total: ');
      if (category.isCurrency) {
        report.write('${_formatCurrency(totalTarget)}/');
        report.write('${_formatCurrency(totalActual)}/');
      } else {
        report.write('$totalTarget/$totalActual/');
      }
      report.writeln('$totalAcv%\n');
    }

    report.writeln('Terimakasih');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(report: report.toString()),
      ),
    );
  }

  String _formatCurrency(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(value).replaceAll(',', '.');
  }

  Map<String, dynamic> _buildJsonFromControllers() {
    final data = <String, dynamic>{};
    data['store_name'] = _storeNameController.text;
    data['store_code'] = _storeCodeController.text;
    data['date'] = DateTime.now().toIso8601String();
    data['categories'] = categories.map((category) {
      final shiftData = [];
      for (int i = 0; i < 3; i++) {
        final target = int.tryParse(category.controllers[i * 2].text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final actual = int.tryParse(category.controllers[i * 2 + 1].text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        shiftData.add({
          'shift': ['Shift 3', 'Shift 1', 'Shift 2'][i],
          'target': target,
          'actual': actual,
        });
      }

      return {
        'name': category.name,
        'isCurrency': category.isCurrency,
        'shifts': shiftData,
      };
    }).toList();

    return data;
  }
}