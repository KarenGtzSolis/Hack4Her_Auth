import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUALI OTP Auth',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Lexend Deca',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
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
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Logo túali en la sección blanca
                            Container(
                              width: 120,
                              height: 60,
                              child: Image.asset(
                                'assets/images/tuali_logo.png', // CAMBIADO: removido /images/
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
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
                            
                            Text(
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
                                Text(
                                  'Ingresa tu número telefónico:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontFamily: 'Lexend Deca',
                                  ),
                                ),
                                
                                SizedBox(height: 16),
                                
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
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Mexico flag and +52 section
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFC31F39),
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
                                                    child: Center(
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
                                            SizedBox(width: 8),
                                            Text(
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
                                          padding: EdgeInsets.symmetric(horizontal: 16),
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
                                            style: TextStyle(
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
                                
                                SizedBox(height: 12),
                                
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
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _sendOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC31F39),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 3,
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
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
                top: MediaQuery.of(context).size.height * 0.4 - 120, // CAMBIADO: posición más visible
                left: 0,
                right: 0,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.asset(
                    'assets/images/carpa.png', // CAMBIADO: removido /images/
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
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
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Logo túali en la sección blanca
                            Container(
                              width: 120,
                              height: 60,
                              child: Image.asset(
                                'assets/images/tuali_logo.png', // CAMBIADO: removido /images/
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
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
                            
                            Text(
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
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
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
                                              ? Color(0xFFC31F39)
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
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      style: TextStyle(
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
                                  child: Text(
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
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _verifyOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFC31F39),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 3,
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
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
                top: MediaQuery.of(context).size.height * 0.4 - 120, // CAMBIADO: posición más visible
                left: 0,
                right: 0,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.asset(
                    'assets/images/carpa.png', // CAMBIADO: removido /images/
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
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
                    icon: Icon(Icons.arrow_back, color: Colors.black54, size: 28),
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

class TualiHomeScreen extends StatelessWidget {
  final String token;

  const TualiHomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header with wave shape
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFC31F39),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Logo and title
                      Container(
                        width: 100,
                        height: 60,
                        child: Image.asset(
                          'assets/images/tuali_logo_white.png', // CAMBIADO: removido /images/
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              'túali',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Lexend Deca',
                              ),
                            );
                          },
                        ),
                      ),
                      
                      SizedBox(height: 8),
                      
                      Text(
                        "let's start",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontFamily: 'Lexend Deca',
                        ),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Category circles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCategoryCircle('Refrescos', Icons.local_drink, Colors.white),
                          _buildCategoryCircle('Jugos', Icons.local_drink, Colors.white),
                          _buildCategoryCircle('Agua', Icons.water_drop, Colors.lightBlue.shade100),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coca Cola promo
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comparte\nuna Coca',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Lexend Deca',
                                ),
                              ),
                              SizedBox(height: 8),
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
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.local_drink,
                            color: Color(0xFFC31F39),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  Text(
                    'Productos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Products grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      children: [
                        _buildProductCard('Powerade', '\$ 25.0', Colors.blue),
                        _buildProductCard('Del Valle', '\$ 15.0', Colors.orange),
                        _buildProductCard('Coca Cola', '\$ 20.0', Color(0xFFC31F39)),
                        _buildProductCard('Sprite', '\$ 18.0', Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom navigation
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xFFC31F39),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Inicio', true),
            _buildNavItem(Icons.grid_view, 'Productos', false),
            _buildNavItem(Icons.shopping_bag, 'Pedidos', false),
            _buildNavItem(Icons.menu, 'Menú', false),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryCircle(String title, IconData icon, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: bgColor == Colors.white ? Color(0xFFC31F39) : Colors.blue,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Lexend Deca',
          ),
        ),
      ],
    );
  }
  
  Widget _buildProductCard(String name, String price, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_drink,
                color: color,
                size: 40,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontFamily: 'Lexend Deca',
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
  
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Container(
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
              fontSize: 12,
              color: isActive ? Colors.white : Colors.white70,
              fontFamily: 'Lexend Deca',
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
      ..color = Colors.grey.shade300
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

// Awning painter for carpa fallback
/*
class AwningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final awningPaint = Paint()..color = Color(0xFFC31F39);
    final awningWhitePaint = Paint()..color = Colors.white;
    
    double stripeWidth = size.width / 8;
    
    // Draw alternating red and white stripes
    for (int i = 0; i < 8; i++) {
      double left = i * stripeWidth;
      double right = (i + 1) * stripeWidth;
      
      // Create curved awning shape for each stripe
      Path stripePath = Path();
      stripePath.moveTo(left, 0);
      stripePath.lineTo(right, 0);
      stripePath.quadraticBezierTo(right - stripeWidth / 3, size.height * 0.7, right - stripeWidth / 4, size.height);
      stripePath.quadraticBezierTo(left - stripeWidth / 3, size.height * 0.7, left - stripeWidth / 4, size.height);
      stripePath.close();
      
      // Alternate colors
      canvas.drawPath(stripePath, i % 2 == 0 ? awningPaint : awningWhitePaint);
    }
    
    // Add shadow effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);
    
    Path shadowPath = Path();
    shadowPath.moveTo(0, size.height * 0.9);
    shadowPath.quadraticBezierTo(size.width / 2, size.height * 1.1, size.width, size.height * 0.9);
    shadowPath.lineTo(size.width, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.close();
    
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
*/

// Custom clipper for wave shape in home screen
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}