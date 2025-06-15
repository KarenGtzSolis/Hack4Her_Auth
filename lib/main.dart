// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services/product_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUALI OTP Auth',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Lexend Deca',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = '';
  }

  void _sendOTP() async {
    if (_phoneController.text.length < 10) {
      _showSnackBar('Por favor ingresa un número válido', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String fullPhone = '+52${_phoneController.text}';
      print('🚀 Enviando OTP a: $fullPhone');
      
      final response = await http.post(
        Uri.parse('http://localhost:5274/api/auth/send-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': fullPhone,
        }),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _showSnackBar('¡Código enviado! Revisa tus mensajes', Colors.green);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                phoneNumber: fullPhone,
              ),
            ),
          );
        } else {
          _showSnackBar('Error al enviar código: ${data['message']}', Colors.red);
        }
      } else {
        _showSnackBar('Error de servidor: ${response.statusCode}', Colors.red);
      }
    } catch (e) {
      print('❌ Error: $e');
      _showSnackBar('Error de conexión: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Layout base con Column
              Column(
                children: [
                  // Top section with grid only
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                        decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: CustomPaint(
                        painter: GridPainter(),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                  
                  // Bottom white section
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Logo túali en la sección blanca
                            SizedBox(
                              width: 120,
                              height: 60,
                              child: Image.asset(
                                'assets/images/tuali_logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'túali',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC31F39),
                                      fontFamily: 'Lexend Deca',
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            const Text(
                              'Inicia Sesión',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Lexend Deca',
                              ),
                            ),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ingresa tu número telefónico:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontFamily: 'Lexend Deca',
                                  ),
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Phone input container
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Mexico flag and +52 section
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC31F39),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                              child: Image.network(
                                                'https://flagcdn.com/w40/mx.png',
                                                width: 24,
                                                height: 16,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    width: 24,
                                                    height: 16,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(2),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'MX',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '+52',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Lexend Deca',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Phone number input
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: TextField(
                                            controller: _phoneController,
                                            decoration: InputDecoration(
                                              hintText: '55 1234 5678',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Lexend Deca',
                                                color: Colors.grey.shade400,
                                                fontSize: 16,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: TextInputType.phone,
                                            style: const TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Texto centrado correctamente
                                Center(
                                  child: Text(
                                    'Te enviaremos un código de acceso por SMS o\nWhatsApp.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Lexend Deca',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Send button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _sendOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC31F39),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 3,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Enviar Código',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'Lexend Deca',
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // CARPA SUPERPUESTA CON Z-INDEX ALTO
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4 - 120,
                left: 0,
                right: 0,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.asset(
                    'assets/images/carpa.png',
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 1.5,
                      );
                    },
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

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (index == 5 && value.isNotEmpty) {
      _verifyOTP();
    }
  }

  void _verifyOTP() async {
    String otp = _controllers.map((controller) => controller.text).join();
    
    if (otp.length != 6) {
      _showSnackBar('Por favor ingresa el código completo', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔍 Verificando OTP: $otp para ${widget.phoneNumber}');
      
      final response = await http.post(
        Uri.parse('http://localhost:5274/api/auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': widget.phoneNumber,
          'otp': otp,
        }),
      );

      print('📡 Verification response: ${response.statusCode}');
      print('📡 Verification body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _showSnackBar('¡Verificación exitosa!', Colors.green);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TualiHomeScreen(token: data['token'] ?? 'demo_token'),
            ),
          );
        } else {
          _showSnackBar('Código incorrecto', Colors.red);
          _clearOTP();
        }
      } else {
        _showSnackBar('Error de servidor: ${response.statusCode}', Colors.red);
      }
    } catch (e) {
      print('❌ Error verificando: $e');
      _showSnackBar('Error de conexión: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Layout base con Column
              Column(
                children: [
                  // Top section with grid only
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: CustomPaint(
                        painter: GridPainter(),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                  
                  // Bottom white section
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Logo túali en la sección blanca
                            SizedBox(
                              width: 120,
                              height: 60,
                              child: Image.asset(
                                'assets/images/tuali_logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    'túali',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC31F39),
                                      fontFamily: 'Lexend Deca',
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            const Text(
                              'Ingresa el código de\nverificación',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Lexend Deca',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            // OTP input container
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(6, (index) {
                                  return Container(
                                    width: 35,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: _controllers[index].text.isNotEmpty 
                                              ? const Color(0xFFC31F39)
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.black,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) => _onDigitChanged(index, value),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            
                            Column(
                              children: [
                                Text(
                                  '¿No recibiste el código?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Lexend Deca',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _showSnackBar('Código reenviado', Colors.green);
                                  },
                                  child: const Text(
                                    'Reenviar el código.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFC31F39),
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Lexend Deca',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            // Verify button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _verifyOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC31F39),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 3,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Verificar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'Lexend Deca',
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // CARPA SUPERPUESTA CON Z-INDEX ALTO
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4 - 120,
                left: 0,
                right: 0,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.asset(
                    'assets/images/carpa.png',
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 1.5,
                      );
                    },
                  ),
                ),
              ),
              
              // Back button positioned over everything
              SafeArea(
                child: Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54, size: 28),
                    onPressed: () => Navigator.pop(context),
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

class TualiHomeScreen extends StatefulWidget {
  final String token;

  const TualiHomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  _TualiHomeScreenState createState() => _TualiHomeScreenState();
}

class _TualiHomeScreenState extends State<TualiHomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'Todos';
  bool _isLoading = true;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await ProductService.getProducts();
      final categories = await ProductService.getCategories();

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _categories = ['Todos', ...categories];
        _isLoading = false;
      });

      print('✅ Cargados ${products.length} productos');
    } catch (e) {
      print('❌ Error cargando productos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'Todos') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) => product.category == category).toList();
      }
    });
  }

  Future<void> _addToCart(Product product) async {
    try {
      String phoneNumber = '+528120730053';
      
      final success = await ProductService.addToCart(product.id, 1, phoneNumber);
      
      if (success) {
        setState(() {
          _cartItemCount++;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} agregado al carrito'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error agregando producto al carrito'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error agregando al carrito: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header rojo con categorías - EXACTO COMO FIGMA
          Container(
            height: 210,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFC31F39),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    // Logo túali
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: Image.asset(
                        'assets/images/tuali_logo_white.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'túali',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Lexend Deca',
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Tres categorías en círculos como Figma
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCategoryItem(
                          icon: Icons.local_drink,
                          label: 'Refrescos',
                          isSelected: _selectedCategory == 'Refrescos' || _selectedCategory == 'Todos',
                          onTap: () => _filterByCategory('Refrescos'),
                        ),
                        _buildCategoryItem(
                          icon: Icons.local_drink_outlined,
                          label: 'Jugos',
                          isSelected: _selectedCategory == 'Jugos',
                          onTap: () => _filterByCategory('Jugos'),
                        ),
                        _buildCategoryItem(
                          icon: Icons.water_drop,
                          label: 'Agua',
                          isSelected: _selectedCategory == 'Agua',
                          onTap: () => _filterByCategory('Agua'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido con productos
          Expanded(

            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Promo Coca Cola - EXACTA COMO FIGMA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Comparte\nuna Coca',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Realiza tu pedido\nahora mismo',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Imágenes de productos como en Figma
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 70,
                              child: Image.asset(
                                'assets/images/products/coca_bottle.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC31F39).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.local_drink,
                                      color: Color(0xFFC31F39),
                                      size: 30,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 50,
                              height: 70,
                              child: Image.asset(
                                'assets/images/products/coca_can.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC31F39).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.local_drink,
                                      color: Color(0xFFC31F39),
                                      size: 30,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Título "Productos"
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Lexend Deca',
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Grid de productos - EXACTO COMO FIGMA
                  Expanded(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFC31F39),
                            ),
                          )
                        : _filteredProducts.isEmpty
                            ? Center(
                                child: Text(
                                  'No hay productos en esta categoría',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontFamily: 'Lexend Deca',
                                  ),
                                ),
                              )
                            : GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.85,
                                ),
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = _filteredProducts[index];
                                  return _buildProductCard(product);
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom navigation - EXACTO COMO FIGMA
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: Color(0xFFC31F39),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 'Inicio', true, () {}),
              _buildNavItem(Icons.apps, 'Productos', false, () {}),
              _buildNavItem(Icons.shopping_cart, 'Carrito', false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(
                      phoneNumber: '+528120730053',
                    ),
                  ),
                );
              }),
              _buildNavItem(Icons.shopping_bag, 'Pedidos', false, () {}),
              _buildNavItem(Icons.menu, 'Menú', false, () {}),
            ],
          ),
        ),
      ),
    );
  }
  
  // Widget para categorías en círculos como Figma
  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/categories/${label.toLowerCase()}.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    icon,
                    color: Color(0xFFC31F39),
                    size: 32,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Lexend Deca',
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget para productos - EXACTO COMO FIGMA
  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Círculo de fondo con imagen del producto
            Expanded(
              flex: 3,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getProductBackgroundColor(product.name),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    _getProductImagePath(product),
                    width: 50,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.local_drink,
                        color: _getProductColor(product.name),
                        size: 35,
                      );
                    },
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Información del producto
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre del producto
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Precio
                  Text(
                    '\$ ${product.price.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                  ),
                  
                  // Botón agregar - círculo rojo con +
                  Container(
                    width: 32,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC31F39),
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                        elevation: 2,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
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
  
  Color _getProductBackgroundColor(String productName) {
    if (productName.toLowerCase().contains('powerade')) return Color(0xFFE3F2FD);
    if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Color(0xFFFFF3E0);
    return Color(0xFFF3E5F5);
  }
  
  Color _getProductColor(String productName) {
    if (productName.toLowerCase().contains('powerade')) return Colors.blue;
    if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Colors.orange;
    return Color(0xFFC31F39);
  }
  
  String _getProductImagePath(Product product) {
    return 'assets/images/products/${product.imageUrl}';
  }
  
  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Colors.white : Colors.white70,
                fontFamily: 'Lexend Deca',
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final String phoneNumber;

  const CartScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? _cart;
  bool _isLoading = true;
  bool _isUpdating = false;
  List<Product> _allProducts = []; 

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cart = await ProductService.getCart(widget.phoneNumber);
      final products = await ProductService.getProducts(); // ← AGREGAR ESTA LÍNEA
      setState(() {
        _cart = cart;
        _allProducts = products; // ← AGREGAR ESTA LÍNEA
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error cargando carrito: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(int productId, int newQuantity) async {
    if (_isUpdating) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final success = await ProductService.updateCartItemQuantity(
        productId, 
        newQuantity, 
        widget.phoneNumber
      );

      if (success) {
        await _loadCart();
      }
    } catch (e) {
      print('❌ Error actualizando cantidad: $e');
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header rojo igual que home - EXACTO COMO FIGMA
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFC31F39),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    // Logo túali
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: Image.asset(
                        'assets/images/tuali_logo_white.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'túali',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Lexend Deca',
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Título "Mi carrito"
                    Text(
                      'Mi carrito',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Lexend Deca',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido del carrito
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFC31F39),
                    ),
                  )
                : _cart == null || _cart!.items.isEmpty
                    ? _buildEmptyCart()
                    : _buildCartContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'Lexend Deca',
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFC31F39),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Explorar Productos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Lexend Deca',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Lista de productos - EXACTA COMO FIGMA
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(_cart!.items.length, (index) {
                  final item = _cart!.items[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Círculo con imagen del producto
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _getCartItemBackgroundColor(item.productName),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              _getCartItemImagePath(item),
                              width: 35,
                              height: 40,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.local_drink,
                                  color: _getCartItemColor(item.productName),
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Información del producto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.productName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$ ${item.price.toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Controles de cantidad - círculos rojos como Figma
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              child: ElevatedButton(
                                onPressed: () => _updateQuantity(item.productId, item.quantity - 1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC31F39),
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              child: Text(
                                '${item.quantity}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lexend Deca',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              child: ElevatedButton(
                                onPressed: () => _updateQuantity(item.productId, item.quantity + 1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC31F39),
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          
          // Botón "Realizar Pedido" - EXACTO COMO FIGMA
          Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(cart: _cart!),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC31F39),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 3,
              ),
              child: Text(
                'Realizar Pedido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Lexend Deca',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getCartItemBackgroundColor(String productName) {
    if (productName.toLowerCase().contains('powerade')) return Color(0xFFE3F2FD);
    if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Color(0xFFFFF3E0);
    return Color(0xFFF3E5F5);
  }
  
  Color _getCartItemColor(String productName) {
    if (productName.toLowerCase().contains('powerade')) return Colors.blue;
    if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Colors.orange;
    return Color(0xFFC31F39);
  }
  
  String _getCartItemImagePath(CartItem item) {
    // Buscar el producto en la lista para obtener su imageUrl
    final product = _allProducts.firstWhere(
      (p) => p.id == item.productId,
      orElse: () => Product(
        id: 0,
        name: '',
        description: '',
        price: 0.0,
        category: '',
        imageUrl: 'default.png',
        available: false,
      ),
    );
    return 'assets/images/products/${product.imageUrl}';
  }
}

// Nueva pantalla de detalles del pedido - EXACTA COMO FIGMA
class OrderDetailsScreen extends StatelessWidget {
  final Cart cart;

  const OrderDetailsScreen({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header rojo - EXACTO COMO FIGMA
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFC31F39),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    // Logo túali
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: Image.asset(
                        'assets/images/tuali_logo_white.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            'túali',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Lexend Deca',
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Título "Detalles del pedido"
                    Text(
                      'Detalles del pedido',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Lexend Deca',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Card con información del pedido - EXACTA COMO FIGMA
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Ícono de entrega
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFFFCE4EC),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_shipping,
                            color: Color(0xFFC31F39),
                            size: 30,
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pedido del 13 de junio',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total    \$${cart.total.toStringAsFixed(0)}.00 MXN',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${cart.itemCount} Unidades',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Lista de productos del pedido
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Lista de productos
                          ...cart.items.map((item) => Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item.quantity} x ${item.productName}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Lexend Deca',
                                  ),
                                ),
                                Text(
                                  '\$${item.total.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Lexend Deca',
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                          
                          Divider(height: 24),
                          
                          // Total a pagar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total a pagar:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                              Text(
                                '\$${cart.total.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFC31F39),
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón "Proceder al Pago" - EXACTO COMO FIGMA
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Procesando pedido...'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC31F39),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        'Proceder al Pago',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Lexend Deca',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Grid painter for background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC31F39)
      ..strokeWidth = 1;

    const spacing = 40.0;
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}