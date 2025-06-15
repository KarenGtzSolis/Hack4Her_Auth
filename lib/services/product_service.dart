// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// Modelos para los datos
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool available;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.available,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: _parsePrice(json['price']),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      available: json['available'] ?? true,
    );
  }

  // Método helper para convertir el precio correctamente
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    return 0.0;
  }
}

class CartItem {
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double total;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    print('🔍 Parseando CartItem: $json');
    
    // Manejo robusto de cada campo
    int productId = 0;
    if (json['productId'] != null) {
      if (json['productId'] is int) {
        productId = json['productId'];
      } else if (json['productId'] is String) {
        productId = int.tryParse(json['productId']) ?? 0;
      }
    }

    String productName = '';
    if (json['productName'] != null) {
      productName = json['productName'].toString();
    }

    double price = Product._parsePrice(json['price']);
    
    int quantity = 0;
    if (json['quantity'] != null) {
      if (json['quantity'] is int) {
        quantity = json['quantity'];
      } else if (json['quantity'] is String) {
        quantity = int.tryParse(json['quantity']) ?? 0;
      }
    }

    double total = Product._parsePrice(json['total']);

    print('✅ CartItem parseado: ID=$productId, Name=$productName, Price=$price, Qty=$quantity, Total=$total');

    return CartItem(
      productId: productId,
      productName: productName,
      price: price,
      quantity: quantity,
      total: total,
    );
  }
}

class Cart {
  final List<CartItem> items;
  final double total;
  final int itemCount;

  Cart({
    required this.items,
    required this.total,
    required this.itemCount,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    print('🔍 Parseando Cart: $json');
    
    var itemsList = json['items'] as List? ?? [];
    List<CartItem> items = [];
    
    try {
      items = itemsList.map((item) {
        if (item is Map<String, dynamic>) {
          return CartItem.fromJson(item);
        } else {
          print('⚠️ Item inválido en carrito: $item');
          return null;
        }
      }).where((item) => item != null).cast<CartItem>().toList();
    } catch (e) {
      print('❌ Error parseando items del carrito: $e');
      items = [];
    }
    
    double total = Product._parsePrice(json['total']);
    int itemCount = json['itemCount'] ?? items.length;

    print('✅ Cart parseado: ${items.length} items, Total: $total');
    
    return Cart(
      items: items,
      total: total,
      itemCount: itemCount,
    );
  }
}

// Servicio para comunicarse con la API
class ProductService {
  // Cambia esta URL según tu configuración:
  // Para emulador Android: 'http://10.0.2.2:5274'
  // Para iOS/Web: 'http://localhost:5274'
  static const String baseUrl = 'http://10.0.2.2:5274/api';
  
  // Obtener todos los productos
  static Future<List<Product>> getProducts() async {
    try {
      print('🔍 Obteniendo productos desde: $baseUrl/products');
      
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          var productsList = data['products'] as List;
          List<Product> products = productsList.map((product) {
            print('🔍 Procesando producto: $product');
            return Product.fromJson(product);
          }).toList();
          
          print('✅ Productos procesados: ${products.length}');
          for (var product in products) {
            print('📦 ${product.name} - \$${product.price}');
          }
          
          return products;
        }
      }
      print('❌ Error en respuesta del servidor');
      return [];
    } catch (e) {
      print('❌ Error obteniendo productos: $e');
      return [];
    }
  }

  // Obtener productos por categoría
  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      print('🔍 Obteniendo productos de categoría: $category');
      
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          var productsList = data['products'] as List;
          return productsList.map((product) => Product.fromJson(product)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo productos por categoría: $e');
      return [];
    }
  }

  // Agregar producto al carrito
  static Future<bool> addToCart(int productId, int quantity, String phoneNumber) async {
    try {
      print('🛒 Agregando producto $productId al carrito (cantidad: $quantity)');
      
      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {
          'Content-Type': 'application/json',
          'phoneNumber': phoneNumber,
        },
        body: jsonEncode({
          'productId': productId,
          'quantity': quantity,
        }),
      );

      print('📡 Add to cart response: ${response.statusCode}');
      print('📡 Add to cart body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error agregando al carrito: $e');
      return false;
    }
  }

  // Obtener carrito del usuario
  static Future<Cart?> getCart(String phoneNumber) async {
    try {
      print('🛒 Obteniendo carrito para: $phoneNumber');
      
      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Content-Type': 'application/json',
          'phoneNumber': phoneNumber,
        },
      );

      print('📡 Get cart response: ${response.statusCode}');
      print('📡 Get cart body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['cart'] != null) {
          return Cart.fromJson(data['cart']);
        }
      }
      return Cart(items: [], total: 0.0, itemCount: 0); // Carrito vacío en lugar de null
    } catch (e) {
      print('❌ Error obteniendo carrito: $e');
      return Cart(items: [], total: 0.0, itemCount: 0); // Carrito vacío en caso de error
    }
  }

  // Obtener categorías disponibles
  static Future<List<String>> getCategories() async {
    try {
      final products = await getProducts();
      final categories = products.map((product) => product.category).toSet().toList();
      return categories;
    } catch (e) {
      print('❌ Error obteniendo categorías: $e');
      return [];
    }
  }

  // Actualizar cantidad de producto en carrito
  static Future<bool> updateCartItemQuantity(int productId, int quantity, String phoneNumber) async {
    try {
      print('📝 Actualizando cantidad del producto $productId a $quantity');
      
      final response = await http.put(
        Uri.parse('$baseUrl/cart/update'),
        headers: {
          'Content-Type': 'application/json',
          'phoneNumber': phoneNumber,
        },
        body: jsonEncode({
          'productId': productId,
          'quantity': quantity,
        }),
      );

      print('📡 Update cart response: ${response.statusCode}');
      print('📡 Update cart body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error actualizando carrito: $e');
      return false;
    }
  }

  // Eliminar producto del carrito
  static Future<bool> removeFromCart(int productId, String phoneNumber) async {
    try {
      print('🗑️ Eliminando producto $productId del carrito');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'phoneNumber': phoneNumber,
        },
      );

      print('📡 Remove from cart response: ${response.statusCode}');
      print('📡 Remove from cart body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error eliminando del carrito: $e');
      return false;
    }
  }

  // Limpiar todo el carrito
  static Future<bool> clearCart(String phoneNumber) async {
    try {
      print('🧹 Limpiando carrito completo');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/clear'),
        headers: {
          'Content-Type': 'application/json',
          'phoneNumber': phoneNumber,
        },
      );

      print('📡 Clear cart response: ${response.statusCode}');
      print('📡 Clear cart body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error limpiando carrito: $e');
      return false;
    }
  }
}