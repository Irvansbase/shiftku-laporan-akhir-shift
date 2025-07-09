import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'store_login_page.dart';
import 'terms_privacy_page.dart';

class StoreRegisterPage extends StatefulWidget {
  const StoreRegisterPage({super.key});

  @override
  State<StoreRegisterPage> createState() => _StoreRegisterPageState();
}

class _StoreRegisterPageState extends State<StoreRegisterPage> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _registrationSuccess = false;
  String? _error;
  
  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;

  Future<bool> _registerStore() async {
    final supabase = Supabase.instance.client;

    try {
      // Check password strength
      if (_passwordStrength < 0.4) {
        setState(() => _error = 'Password terlalu lemah! Gunakan kombinasi huruf, angka, dan karakter khusus');
        return false;
      }
      
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _error = 'Password dan konfirmasi password tidak cocok');
        return false;
      }

      // Check if store code exists
      final exists = await supabase
          .from('store_accounts')
          .select()
          .eq('store_code', _storeCodeController.text.trim())
          .maybeSingle();

      if (exists != null) {
        setState(() => _error = 'Kode masuk sudah terdaftar');
        return false;
      }

      // Hash password
      final hashedPassword = BCrypt.hashpw(
        _passwordController.text.trim(),
        BCrypt.gensalt(),
      );

      // Create new store account
      final response = await supabase.from('store_accounts').insert({
        'store_name': _storeNameController.text.trim(),
        'store_code': _storeCodeController.text.trim(),
        'password': hashedPassword,
      }).select();

      return response.isNotEmpty;
    } catch (e) {
      setState(() => _error = 'Error: ${e.toString()}');
      return false;
    }
  }

  void _handleRegister() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Reset errors
    setState(() {
      _isLoading = true;
      _error = null;
      _registrationSuccess = false;
    });

    // Validate password length
    if (_passwordController.text.length < 6) {
      setState(() {
        _isLoading = false;
        _error = 'Password harus minimal 6 karakter';
      });
      return;
    }

    final success = await _registerStore();

    setState(() {
      _isLoading = false;
      _registrationSuccess = success;
    });

    if (success) {
      // Clear form after successful registration
      _storeNameController.clear();
      _storeCodeController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StoreLoginPage()),
    );
  }
  
  void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    double strength = 0.0;
    String text = '';
    Color color = Colors.red;

    // Check length
    if (value.length >= 8) strength += 0.3;
    
    // Check for numbers
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.2;
    
    // Check for uppercase
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    
    // Check for special characters
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.3;

    // Set text and color based on strength
    if (strength < 0.4) {
      text = 'Lemah';
      color = Colors.red;
    } else if (strength < 0.7) {
      text = 'Sedang';
      color = Colors.orange;
    } else {
      text = 'Kuat';
      color = Colors.green;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = text;
      _passwordStrengthColor = color;
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      _checkPasswordStrength(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Toko'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success message
              if (_registrationSuccess)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Registrasi Berhasil!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Toko ${_storeNameController.text} berhasil didaftarkan',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Store name field
              TextField(
                controller: _storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Store code field
              TextField(
                controller: _storeCodeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Masuk',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password (minimal 6 karakter)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              
              // Password strength indicator
              if (_passwordController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: Colors.grey[200],
                        color: _passwordStrengthColor,
                        minHeight: 6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kekuatan password: $_passwordStrengthText',
                        style: TextStyle(
                          fontSize: 12,
                          color: _passwordStrengthColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Confirm password field
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              
              // Password requirements
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password harus mengandung:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '• Minimal 8 karakter',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '• Angka (0-9)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '• Huruf besar (A-Z)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '• Karakter khusus (!@#\$%^&*)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              // Error message
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // Register button
              ElevatedButton(
  onPressed: _isLoading
      ? null
      : () async {
          final accepted = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Konfirmasi'),
              content: const Text(
                'Dengan menekan "Setuju dan Lanjutkan", Anda telah menyetujui Syarat & Ketentuan serta Kebijakan Privasi kami.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Setuju dan Lanjutkan'),
                ),
              ],
            ),
          );

          if (accepted == true) {
            _handleRegister();
          }
        },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    backgroundColor: Colors.blue[800],
  ),
  child: _isLoading
      ? const CircularProgressIndicator(color: Colors.white)
      : const Text(
          'DAFTAR',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsPrivacyPage()),
                  );
                },
                child: const Text("Syarat & Ketentuan | Kebijakan Privasi"),
              ),
              
              const SizedBox(height: 16),
              
              // Login button
              TextButton(
                onPressed: _navigateToLogin,
                child: const Text(
                  'Sudah punya akun? Masuk disini',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}