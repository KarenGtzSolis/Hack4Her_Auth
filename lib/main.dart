// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// Elimina esta línea porque no existe el archivo y ya tienes la clase GridPainter definida al final de este archivo.
// import 'package:hack4her_auth/widgets/grid_painter.dart';

import 'services/product_service.dart';
// Asegúrate de que BusinessUnit esté exportado desde product_service.dart
// AGREGAR ESTAS LÍNEAS DESPUÉS DE LOS IMPORTS:
// Eliminar la definición duplicada de BusinessUnit y usar la del servicio.



void main() {
  runApp(const MyApp());
  // Copied from _TualiHomeScreenState for navigation bar items
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
        Uri.parse('http://10.0.2.2:5274/api/auth/send-otp'),
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
        Uri.parse('http://10.0.2.2:5274/api/auth/verify-otp'),
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
  List<BusinessUnit> _businessUnits = [];
  String _selectedBusinessUnit = 'Todos';
  int _selectedNavIndex = 0;
  PageController _pageController = PageController();

  Color _getCartItemBackgroundColor(String productName) {
    if (productName.toLowerCase().contains('powerade')) return Color(0xFFE3F2FD);
    if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Color(0xFFFFF3E0);
    return Color(0xFFF3E5F5);
  }
  

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // REEMPLAZAR todo el método _loadProducts con este:
// REEMPLAZA tu método _loadData() actual con este:
Future<void> _loadData() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Cargar productos y unidades de negocio
    final products = await ProductService.getProducts();
    final businessUnits = await ProductService.getBusinessUnits();
    final categories = await ProductService.getCategories();

    setState(() {
      _allProducts = products;
      _filteredProducts = products; // 🔥 IMPORTANTE: Inicializar con todos los productos
      _businessUnits = businessUnits;
      _categories = ['Todos', ...categories];
      _isLoading = false;
    });

    // DEBUG: Verificar que los datos lleguen correctamente
    print('✅ Cargados ${products.length} productos y ${businessUnits.length} unidades de negocio');
    print('🔍 DEBUG - Productos filtrados después de cargar: ${_filteredProducts.length}');
    
    // Llamar debug después de setState para verificar el estado
    _debugPrintProducts();
  } catch (e) {
    print('❌ Error cargando datos: $e');
    setState(() {
      _isLoading = false;
    });
  }
}

/// Agrega este método para depuración
void _debugPrintProducts() {
  print('🔎 Productos filtrados:');
  for (var product in _filteredProducts) {
    print(' - ${product.name} (${product.category}, ${product.businessUnit})');
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

  // AGREGAR este método después de _filterByCategory:
  void _filterByBusinessUnit(String businessUnit) {
    setState(() {
      _selectedBusinessUnit = businessUnit;
      _selectedCategory = 'Todos';
      if (businessUnit == 'Todos') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) => product.businessUnit == businessUnit).toList();
      }
    });
  }

  Future<void> _addToCart(Product product) async {
    try {
      String phoneNumber = '+528119606624';
      
      print('🛒 Agregando al carrito: ${product.name}');
      
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
            action: SnackBarAction(
              label: 'Ver Carrito',
              textColor: Colors.white,
              onPressed: () {
                // Cambiar a la pestaña del carrito
                _onNavItemTapped(2);
              },
            ),
          ),
        );
        
        print('✅ Producto agregado exitosamente al carrito');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error agregando producto al carrito'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        print('❌ Error agregando producto al carrito');
      }
    } catch (e) {
      print('❌ Error agregando al carrito: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // AGREGAR ESTOS 4 MÉTODOS:

Widget _buildBusinessUnitsSection() {
  return Container(
    height: 120,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Marcas Arca Continental',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Lexend Deca',
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _businessUnits.isEmpty
              ? Center(child: Text('Cargando marcas...'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _businessUnits.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildBusinessUnitCard(
                        name: 'Todos',
                        displayName: 'Ver Todo',
                        color: '#757575',
                        isSelected: _selectedBusinessUnit == 'Todos',
                        onTap: () => _filterByBusinessUnit('Todos'),
                      );
                    }
                    final businessUnit = _businessUnits[index - 1];
                    return _buildBusinessUnitCard(
                      name: businessUnit.name,
                      displayName: businessUnit.displayName,
                      color: businessUnit.color,
                      isSelected: _selectedBusinessUnit == businessUnit.name,
                      onTap: () => _filterByBusinessUnit(businessUnit.name),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

Widget _buildBusinessUnitCard({
  required String name,
  required String displayName,
  required String color,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  Color cardColor = Color(int.parse(color.replaceFirst('#', '0xFF')));
  
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 100,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? cardColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: name == 'Todos'
                  ? Icon(Icons.apps, color: cardColor, size: 28)
                  : Icon(_getBusinessUnitIcon(name), color: cardColor, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? cardColor : Colors.black87,
              fontFamily: 'Lexend Deca',
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    ),
  );
}

IconData _getBusinessUnitIcon(String businessUnit) {
  switch (businessUnit.toLowerCase()) {
    case 'coca-cola':
      return Icons.local_drink;
    case 'del valle':
      return Icons.local_drink_outlined;
    case 'aguas':
      return Icons.water_drop;
    case 'deportivas':
      return Icons.sports_gymnastics;
    default:
      return Icons.store;
  }
}

Widget _buildCategoriesSection() {
  return Container(
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCategoryItem(
          icon: Icons.local_drink,
          label: 'Refrescos',
          isSelected: _selectedCategory == 'Refrescos',
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
  );
}


  // Add this method to build product cards in the cart screen

  // Add missing _buildNavItem method

  // Add missing _buildNavItem method

  // Add missing _buildNavItem method

  // Add missing _buildNavItem method
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

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  Widget _buildPedidoEnCursoCard() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    margin: EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pedido en Curso',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Lexend Deca',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pedido #1234',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Lexend Deca',
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadoPedido(
                icon: Icons.check_circle,
                label: 'Pedido Listo',
                isCompleted: true,
                isActive: false,
              ),
              _buildEstadoPedido(
                icon: Icons.local_shipping,
                label: 'En camino',
                isCompleted: false,
                isActive: true,
              ),
              _buildEstadoPedido(
                icon: Icons.home,
                label: 'Entregado',
                isCompleted: false,
                isActive: false,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildEstadoPedido({
  required IconData icon,
  required String label,
  required bool isCompleted,
  required bool isActive,
}) {
  Color iconColor;
  Color backgroundColor;
  
  if (isCompleted) {
    iconColor = Colors.white;
    backgroundColor = Color(0xFFC31F39);
  } else if (isActive) {
    iconColor = Color(0xFFC31F39);
    backgroundColor = Colors.grey[200]!;
  } else {
    iconColor = Colors.grey[400]!;
    backgroundColor = Colors.grey[200]!;
  }
  
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: isActive && !isCompleted 
            ? Border.all(color: Color(0xFFC31F39), width: 2)
            : null,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
      ),
      SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isCompleted || isActive ? Colors.black87 : Colors.grey[600],
          fontFamily: 'Lexend Deca',
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
        children: [
          // Página 0: Home (tu contenido actual)
          _buildHomePage(),
          
          // Página 1: Productos  
          _buildProductsPage(),
          
          // Página 2: Pedidos
          CartScreen(phoneNumber: '+528119606624'),
          
          // Página 3: Menú
          _buildMenuPage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xFFC31F39),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Inicio', _selectedNavIndex == 0, () => _onNavItemTapped(0)),
              _buildNavItem(Icons.apps, 'Productos', _selectedNavIndex == 1, () => _onNavItemTapped(1)),
              _buildNavItem(Icons.shopping_bag, 'Pedidos', _selectedNavIndex == 2, () => _onNavItemTapped(2)),
              _buildNavItem(Icons.menu, 'Menú', _selectedNavIndex == 3, () => _onNavItemTapped(3)),
            ],
          ),
        ),
      ),
    );
  }

  
  // REEMPLAZA el método _buildHomePage() completo con este:
  Widget _buildHomePage() {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header rojo fijo
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Text(
                      'Nuestras Marcas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Lexend Deca',
                      ),
                    ),
                    SizedBox(width: 80),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido scrollable - ESTA ES LA PARTE CLAVE
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Unidades de negocio
                  _buildBusinessUnitsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Categorías
                  _buildCategoriesSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Pedido en curso
                  _buildPedidoEnCursoCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Título dinámico
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _selectedBusinessUnit != 'Todos' 
                        ? 'Productos $_selectedBusinessUnit'
                        : _selectedCategory != 'Todos'
                          ? 'Productos $_selectedCategory'
                          : 'Productos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Lexend Deca',
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 🔥 AQUÍ ESTÁ EL CAMBIO PRINCIPAL - SizedBox con altura fija
                  SizedBox(
                    height: 600, // Altura fija suficiente para mostrar productos
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFC31F39),
                            ),
                          )
                        : _filteredProducts.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No hay productos en esta categoría',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontFamily: 'Lexend Deca',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                itemCount: _filteredProducts.length,
                                padding: const EdgeInsets.all(8),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.8, // Ajustado para mejor proporción
                                ),
                                itemBuilder: (context, index) {
                                  final product = _filteredProducts[index];
                                  return _buildProductCard(product);
                                },
                              ),
                  ),
                  
                  // Espacio adicional al final para scroll
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsPage() {
    return Center(
      child: Text(
        'Página de Productos',
        style: TextStyle(fontSize: 24, fontFamily: 'Lexend Deca'),
      ),
    );
  }

  Widget _buildMenuPage() {
    return Center(
      child: Text(
        'Página de Menú',
        style: TextStyle(fontSize: 24, fontFamily: 'Lexend Deca'),
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFC31F39) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xFFC31F39),
              size: 20,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Color(0xFFC31F39),
                fontFamily: 'Lexend Deca',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widget para productos - EXACTO COMO FIGMA
  // REEMPLAZAR el método _buildProductCard completo
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
        padding: EdgeInsets.all(12), // Reducido de 16 a 12
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Círculo de fondo con imagen del producto - TAMAÑO FIJO
            Container(
              width: 70, // Tamaño fijo
              height: 70, // Tamaño fijo
              decoration: BoxDecoration(
                color: _getProductBackgroundColor(product.name),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  _getProductImagePath(product),
                  width: 45, // Reducido
                  height: 50, // Reducido
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.local_drink,
                      color: _getProductColor(product.name),
                      size: 32, // Reducido
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 8), // Reducido de 12 a 8
            
            // Información del producto - SIN EXPANDED/FLEXIBLE
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nombre del producto - ALTURA FIJA
                SizedBox(
                  height: 32, // Altura fija para 2 líneas
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 12, // Reducido de 14 a 12
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2, // Máximo 2 líneas
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // Precio - ALTURA FIJA
                SizedBox(
                  height: 20, // Altura fija
                  child: Text(
                    '\$ ${product.price.toStringAsFixed(0)}', // Sin decimales
                    style: TextStyle(
                      fontSize: 14, // Reducido de 16 a 14
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Botón agregar - TAMAÑO FIJO
                SizedBox(
                  width: 28, // Tamaño fijo
                  height: 28, // Tamaño fijo
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
                      size: 16, // Reducido de 18 a 16
                    ),
                  ),
                ),
              ],
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

  // Added missing method to fix compile error
  Color _getCartItemColor(String productName) {
    if (productName.toLowerCase().contains('powerade')) return Colors.blue;
    if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Colors.orange;
    return Color(0xFFC31F39);
  }
  
  String _getProductImagePath(Product product) {
    return 'assets/images/products/${product.imageUrl}';
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
  List<BusinessUnit> _businessUnits = [];
  String _selectedBusinessUnit = 'Todos';
  List<String> _categories = [];
  String _selectedCategory = 'Todos';
  List<Product> _filteredProducts = [];

  // Added to fix missing method error




  String _getCartItemImagePath(CartItem item) {
  // Ejemplo simple:
  if (item.productName.toLowerCase().contains('coca')) {
    return 'assets/images/coca.png';
  } else if (item.productName.toLowerCase().contains('valle')) {
    return 'assets/images/valle.png';
  }
  return 'assets/images/default.png';
}

Widget _buildNavItem(IconData icon, String label, bool selected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: selected ? Colors.white : Colors.white60),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white60,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            fontFamily: 'Lexend Deca',
          ),
        ),
      ],
    ),
  );
}




  // Add this method to fix the missing _buildProductCard error
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
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product image in a circle
            // TEMPORAL: Container de debug super visible
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red, width: 5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'AQUÍ ESTÁ LA CARD!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 32,
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 20,
                  child: Text(
                    '\$ ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      // Optionally implement add to cart for cart screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC31F39),
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                      elevation: 2,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Add missing _buildCategoriesSection method
  Widget _buildCategoriesSection() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryItem(
            icon: Icons.local_drink,
            label: 'Refrescos',
            isSelected: _selectedCategory == 'Refrescos',
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
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFC31F39) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xFFC31F39),
              size: 20,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Color(0xFFC31F39),
                fontFamily: 'Lexend Deca',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCart();
    _loadBusinessUnitsAndCategories();
  }

  Future<void> _loadBusinessUnitsAndCategories() async {
    try {
      final businessUnits = await ProductService.getBusinessUnits();
      final categories = await ProductService.getCategories();
      setState(() {
        _businessUnits = businessUnits;
        _categories = ['Todos', ...categories];
      });
    } catch (e) {
      print('❌ Error cargando unidades/categorías: $e');
    }
  }

  void _filterByBusinessUnit(String businessUnit) {
    setState(() {
      _selectedBusinessUnit = businessUnit;
      _selectedCategory = 'Todos';
      if (businessUnit == 'Todos') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) => product.businessUnit == businessUnit).toList();
      }
    });
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

  Widget _buildBusinessUnitsSection() {
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Marcas Arca Continental',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Lexend Deca',
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _businessUnits.isEmpty
                ? Center(child: Text('Cargando marcas...'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _businessUnits.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildBusinessUnitCard(
                          name: 'Todos',
                          displayName: 'Ver Todo',
                          color: '#757575',
                          isSelected: _selectedBusinessUnit == 'Todos',
                          onTap: () => _filterByBusinessUnit('Todos'),
                        );
                      }
                      final businessUnit = _businessUnits[index - 1];
                      return _buildBusinessUnitCard(
                        name: businessUnit.name,
                        displayName: businessUnit.displayName,
                        color: businessUnit.color,
                        isSelected: _selectedBusinessUnit == businessUnit.name,
                        onTap: () => _filterByBusinessUnit(businessUnit.name),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessUnitCard({
    required String name,
    required String displayName,
    required String color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color cardColor = Color(int.parse(color.replaceFirst('#', '0xFF')));
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? cardColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: name == 'Todos'
                    ? Icon(Icons.apps, color: cardColor, size: 28)
                    : Icon(_getBusinessUnitIcon(name), color: cardColor, size: 28),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? cardColor : Colors.black87,
                fontFamily: 'Lexend Deca',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getBusinessUnitIcon(String businessUnit) {
    switch (businessUnit.toLowerCase()) {
      case 'coca-cola':
        return Icons.local_drink;
      case 'del valle':
        return Icons.local_drink_outlined;
      case 'aguas':
        return Icons.water_drop;
      case 'deportivas':
        return Icons.sports_gymnastics;
      default:
        return Icons.store;
    }
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
Widget _buildPedidoEnCursoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido en Curso',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Lexend Deca',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pedido #1234',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Lexend Deca',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEstadoPedido(
                  icon: Icons.check_circle,
                  label: 'Pedido Listo',
                  isCompleted: true,
                  isActive: false,
                ),
                _buildEstadoPedido(
                  icon: Icons.local_shipping,
                  label: 'En camino',
                  isCompleted: false,
                  isActive: true,
                ),
                _buildEstadoPedido(
                  icon: Icons.home,
                  label: 'Entregado',
                  isCompleted: false,
                  isActive: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoPedido({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    Color iconColor;
    Color backgroundColor;
    
    if (isCompleted) {
      iconColor = Colors.white;
      backgroundColor = Color(0xFFC31F39);
    } else if (isActive) {
      iconColor = Color(0xFFC31F39);
      backgroundColor = Colors.grey[200]!;
    } else {
      iconColor = Colors.grey[400]!;
      backgroundColor = Colors.grey[200]!;
    }
    
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: isActive && !isCompleted 
              ? Border.all(color: Color(0xFFC31F39), width: 2)
              : null,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted || isActive ? Colors.black87 : Colors.grey[600],
            fontFamily: 'Lexend Deca',
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // AGREGAR ESTOS MÉTODOS EN _TualiHomeScreenState ANTES DEL BUILD():

Color _getProductBackgroundColor(String productName) {
  if (productName.toLowerCase().contains('powerade')) return Color(0xFFE3F2FD);
  if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Color(0xFFFFF3E0);
  if (productName.toLowerCase().contains('coca')) return Color(0xFFFFEBEE);
  return Color(0xFFF3E5F5);
}

Color _getProductColor(String productName) {
  if (productName.toLowerCase().contains('powerade')) return Colors.blue;
  if (productName.toLowerCase().contains('valle') || productName.toLowerCase().contains('jugo')) return Colors.orange;
  if (productName.toLowerCase().contains('coca')) return Color(0xFFC31F39);
  return Color(0xFFC31F39);
}

String _getProductImagePath(Product product) {
  // Por ahora usaremos iconos, ya que no tienes las imágenes físicas
  return 'assets/images/products/${product.imageUrl}';
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      // Header rojo igual que las otras pantallas
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Text(
                  'Mi Carrito',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Lexend Deca',
                  ),
                ),
                // Badge del carrito con contador
                Container(
                  width: 80,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 28,
                      ),
                      if (_cart != null && _cart!.items.isNotEmpty)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${_cart!.items.length}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lexend Deca',
                              ),
                            ),
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

  Widget _buildCartSummary() {
  if (_cart == null || _cart!.items.isEmpty) return SizedBox.shrink();
  
  double total = _cart!.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  int totalItems = _cart!.items.fold(0, (sum, item) => sum + item.quantity);
  
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total ($totalItems productos)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend Deca',
              ),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC31F39),
                fontFamily: 'Lexend Deca',
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implementar funcionalidad de pedido
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Funcionalidad de pedido en desarrollo'),
                  backgroundColor: Colors.orange,
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

  Widget _buildCartContent() {
    return Column(
      children: [
        // Lista de productos del carrito
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Información del carrito
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tienes ${_cart!.items.length} productos en tu carrito',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontFamily: 'Lexend Deca',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Lista de productos
                ...List.generate(_cart!.items.length, (index) {
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
                                '\$${item.price.toStringAsFixed(1)} c/u',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                              Text(
                                'Subtotal: \$${(item.price * item.quantity).toStringAsFixed(1)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFC31F39),
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Controles de cantidad
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              child: ElevatedButton(
                                onPressed: _isUpdating ? null : () => _updateQuantity(item.productId, item.quantity - 1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC31F39),
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            Container(
                              width: 50,
                              child: Text(
                                '${item.quantity}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lexend Deca',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              child: ElevatedButton(
                                onPressed: _isUpdating ? null : () => _updateQuantity(item.productId, item.quantity + 1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC31F39),
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        
        // Resumen y botón de pedido
        _buildCartSummary(),
      ],
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
  


// Nueva pantalla de detalles del pedido - EXACTA COMO FIGMA
/* Pantalla de detalles del pedido eliminada por solicitud del usuario */

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