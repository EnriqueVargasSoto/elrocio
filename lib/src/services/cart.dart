import 'dart:ffi';

import 'package:flutter/foundation.dart';

class Cart {
  static double total = 0.0;
  static double subtotal = 0.0;
  static double igv = 0.0;
  int items = 0;
  static List<dynamic> carrito = [];

  static List<dynamic> getProductos() {
    return carrito;
  }

  static void agregarProducto(
      String codigo,
      String codigoOEBS,
      String nombreProducto,
      String kilos,
      String cantPollos,
      String pollosxjaba,
      String jabas,
      String factorConversion,
      String valorInicial,
      String factorConversionV,
      String valorFinal,
      String total,
      String idTipoLinea,
      String comentario,
      String rangoMinimo,
      String rangoMaximo,
      String montoSubtotal,
      String montoIgv) {
    var product = {
      //'idPedidoDetalle': 0,
      //'codigoServidor': '',
      'codigoArticulo': codigo,
      'codigoEBS': codigoOEBS, //'',
      'nombreArticulo': nombreProducto,
      'cantidadKGS': kilos,
      'cantidadUND': cantPollos,
      'cantidadUNDXJaba': pollosxjaba,
      'cantidadJabas': jabas,
      'factorConversion': factorConversion,
      'precioUnitario': valorInicial,
      'factorConversionV': factorConversionV,
      'precioUnitarioV': valorFinal,
      'monto': total,
      'idTipoLinea': idTipoLinea,
      'comentario': comentario,
      'rango_minimo': rangoMinimo,
      'rango_maximo': rangoMaximo,

      'montoSubtotal': montoSubtotal,
      'montoIgv': montoIgv,
    };
    print(product);
    //se busca si es repetido
    bool estado = false;
    /*for (var i = 0; i < carrito.length; i++) {
      if (carrito[i]['codigoArticulo'] == codigo && carrito[i]['cantidadUNDXJaba'] == pollosxjaba) {
        int auxValorcito = int.parse(carrito[i]['cantidadKGS']) + int.parse(kilos);
        carrito[i]['cantidadKGS'] = auxValorcito.toString();
        estado = true;
      }
    }*/
    List<dynamic> auxArrCar = [];

    carrito.forEach((element) {
      if (element['codigoArticulo'] == codigo &&
          element['cantidadUNDXJaba'] == pollosxjaba) {
        double auxValorcito =
            double.parse(element['cantidadKGS']) + double.parse(kilos);

        int auxJabas = int.parse(element['cantidadJabas']) + int.parse(jabas);

        int auxCant = int.parse(element['cantidadUND']) + int.parse(cantPollos);

        double auxMonto = double.parse(element['monto']) + double.parse(total);

        double auxMontoSubtotal = double.parse(element['montoSubtotal']) +
            double.parse(montoSubtotal);

        double auxMontoIgv =
            double.parse(element['montoIgv']) + double.parse(montoIgv);

        var auxProduct = {
          'codigoArticulo': element['codigoArticulo'].toString(),
          'codigoEBS': element['codigoEBS'].toString(), //'',
          'nombreArticulo': element['nombreArticulo'].toString(),
          'cantidadKGS': auxValorcito.toStringAsFixed(2),
          'cantidadUND': auxCant.toString(), //['cantidadUND'].toString(),
          'cantidadUNDXJaba': element['cantidadUNDXJaba'].toString(),
          'cantidadJabas': auxJabas.toString(), //['cantidadJabas'].toString(),
          'factorConversion': element['factorConversion'].toString(),
          'precioUnitario': element['precioUnitario'].toString(),
          'factorConversionV': element['factorConversionV'].toString(),
          'precioUnitarioV': element['precioUnitarioV'].toString(),
          'monto': auxMonto.toStringAsFixed(2), //element['monto'].toString(),
          'idTipoLinea': element['idTipoLinea'].toString(),
          'comentario': element['comentario'].toString(),
          'rango_minimo': element['rango_minimo'].toString(),
          'rango_maximo': element['rango_maximo'].toString(),

          'montoSubtotal': auxMontoSubtotal
              .toStringAsFixed(2), //element['montoSubtotal'].toString(),
          'montoIgv':
              auxMontoIgv.toStringAsFixed(2), //element['montoIgv'].toString(),
        };
        auxArrCar.add(auxProduct);
        estado = true;
      } else {
        auxArrCar.add(element);
        print('estoy en el else');
      }
    });
    print(estado);
    print(estado == false);
    if (estado == false) {
      carrito.add(product);
    } else {
      carrito = auxArrCar;
    }
    //return 'se agrego al carrito';
  }

  static String obtenerCantidad() {
    var count = 0;
    for (var i = 0; i < carrito.length; i++) {
      count++;
    }
    return count.toString();
  }

  static String getTotal() {
    double count = 0.0;
    for (var i = 0; i < carrito.length; i++) {
      count += double.parse(carrito[i]['monto']);
    }
    return count.toStringAsFixed(2);
  }

  static void eliminarProducto(int id) {
    print('el is es : ${id}');
    var indice = 0;
    for (var i = 0; i < carrito.length; i++) {
      if (carrito[i]['codigo'] == id) {
        print('el codigo es ${carrito[i]['codigo']}');
        indice = i;
        carrito.remove(carrito[i]);
      }
    }
  }

  static void vaciarCarrito() {
    carrito = [];
  }

  static String getSubtotal() {
    double subtotal = 0.0;
    for (var i = 0; i < carrito.length; i++) {
      subtotal += double.parse(carrito[i]['montoSubtotal']);
    }
    return subtotal.toStringAsFixed(2);
  }

  static String getIgv() {
    double igv = 0.0;
    for (var i = 0; i < carrito.length; i++) {
      igv += double.parse(carrito[i]['montoIgv']);
    }
    return igv.toStringAsFixed(2);
  }

  static void actualizaCarrito(
      String codEmpresa,
      String codigo,
      String codigoOEBS,
      String nombreProducto,
      int pollosxjaba,
      int jabas,
      int cantPoollos,
      double kilos,
      double total,
      int id) {
    carrito[id]['codigo'] = 000;
  }

  /*void addProduct(
      String codEmpresa,
      String codigo,
      String codigoOEBS,
      String nombreProducto,
      int pollosxjaba,
      int jabas,
      int cantPoollos,
      double kilos,
      double total) {
    var product = {
      'codEmpresa': codEmpresa,
      'codigo': codigo,
      'codigoOEBS': codigoOEBS,
      'nombreProducto': nombreProducto,
      'pollosxjaba': pollosxjaba,
      'jabas': jabas,
      'cantPoollos': cantPoollos,
      'kilos': kilos,
      'total': total
    };
    carrito.add(product);
  }*/
}
