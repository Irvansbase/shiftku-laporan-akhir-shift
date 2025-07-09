import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'models.dart';

class CategoryCard extends StatefulWidget {
  final int index;
  final Category category;
  final VoidCallback onRemove;

  const CategoryCard({
    required Key key,
    required this.index,
    required this.category,
    required this.onRemove,
  }) : super(key: key);

  @override
  CategoryCardState createState() => CategoryCardState();
}

class CategoryCardState extends State<CategoryCard> {
  late TextEditingController _nameController;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _nameController.addListener(() {
      widget.category.name = _nameController.text;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shiftNames = ['Shift 3', 'Shift 1', 'Shift 2'];
    final fieldNames = ['Target', 'Actual'];

    return Card(
      key: widget.key,
      margin: const EdgeInsets.only(bottom: 8), // Mengurangi margin bawah
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Mengurangi border radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan toggle expand
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Mengurangi padding
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.drag_handle, color: Colors.white, size: 20), // Mengurangi ukuran ikon
                  const SizedBox(width: 8), // Mengurangi jarak
                  Expanded(
                    child: TextField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start, // untuk rata kiri (default), ganti ke center kalau mau tengah horizontal
                textAlignVertical: TextAlignVertical.center, // supaya teks vertikalnya di tengah
                decoration: InputDecoration(
                  hintText: 'Nama Kategori',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    onPressed: () => _nameController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _nameController.text.length,
                    ),
                  ),
                ),
              ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                      size: 24, // Mengurangi ukuran ikon
                    ),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 24), // Mengurangi ukuran ikon
                    onPressed: widget.onRemove,
                    tooltip: 'Hapus Kategori',
                  ),
                ],
              ),
            ),
          ),
          
          if (_isExpanded) ...[
            // Toggle mata uang
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12, right: 12), // Mengurangi padding
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Mengurangi padding
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8), // Mengurangi border radius
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.currency_exchange, color: Colors.blue[800], size: 20), // Mengurangi ukuran ikon
                    const SizedBox(width: 8), // Mengurangi jarak
                    const Text('Format Mata Uang:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)), // Mengurangi ukuran font
                    const Spacer(),
                    Switch(
                      value: widget.category.isCurrency,
                      activeColor: Colors.blue[800],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Mengurangi ukuran switch
                      onChanged: (value) {
                        setState(() {
                          widget.category.isCurrency = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8), // Mengurangi jarak
            
            // Input shift
            for (int shiftIndex = 0; shiftIndex < 3; shiftIndex++)
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12), // Mengurangi padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.blue[800]), // Mengurangi ukuran ikon
                        const SizedBox(width: 4), // Mengurangi jarak
                        Text(
                          shiftNames[shiftIndex],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14, // Mengurangi ukuran font
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Mengurangi jarak
                    Row(
                      children: [
                        // Target
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8), // Mengurangi border radius
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: TextField(
                              controller: widget.category.controllers[shiftIndex * 2],
                              keyboardType: TextInputType.number,
                              inputFormatters: widget.category.isCurrency
                                  ? [CurrencyInputFormatter()]
                                  : [FilteringTextInputFormatter.digitsOnly],
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                                fontSize: 14, // Mengurangi ukuran font
                              ),
                              decoration: InputDecoration(
                                labelText: fieldNames[0],
                                labelStyle: TextStyle(color: Colors.blue[700], fontSize: 12), // Mengurangi ukuran font
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Mengurangi padding
                                prefixIcon: widget.category.isCurrency 
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 6, top: 10), // Mengurangi padding
                                        child: Text('Rp', style: TextStyle(
                                          fontSize: 14, // Mengurangi ukuran font
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                        )),
                                      )
                                    : Icon(Icons.flag, color: Colors.blue[700], size: 18), // Mengurangi ukuran ikon
                                suffixIcon: widget.category.isCurrency 
                                    ? null
                                    : Icon(Icons.numbers, color: Colors.blue[700], size: 18), // Mengurangi ukuran ikon
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8), // Mengurangi jarak
                        
                        // Actual
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8), // Mengurangi border radius
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: TextField(
                              controller: widget.category.controllers[shiftIndex * 2 + 1],
                              keyboardType: TextInputType.number,
                              inputFormatters: widget.category.isCurrency
                                  ? [CurrencyInputFormatter()]
                                  : [FilteringTextInputFormatter.digitsOnly],
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                                fontSize: 14, // Mengurangi ukuran font
                              ),
                              decoration: InputDecoration(
                                labelText: fieldNames[1],
                                labelStyle: TextStyle(color: Colors.blue[700], fontSize: 12), // Mengurangi ukuran font
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Mengurangi padding
                                prefixIcon: widget.category.isCurrency 
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 6, top: 10), // Mengurangi padding
                                        child: Text('Rp', style: TextStyle(
                                          fontSize: 14, // Mengurangi ukuran font
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                        )),
                                      )
                                    : Icon(Icons.check_circle, color: Colors.blue[700], size: 18), // Mengurangi ukuran ikon
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final numericValue = int.tryParse(newValue.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (numericValue == null) {
      return oldValue;
    }

    final formattedText = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    ).format(numericValue);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}