import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase('comercial',
        version: 1, onCreate: (sql.Database database, int version) async {});
  }

  static Future<String> createTablesScript(String script) async {
    final db = await SQLHelper.db();
    if (script != '') {
      await db.rawQuery(script);
    }
    return 'migracion desde script ok';
  }

  static Future<List<Map<String, dynamic>>> busquedaNombre(
      String tipo, String condicion) async {
    final db = await SQLHelper.db();
    if (tipo == 'nombre') {
      return db.query('TBL_CLIENTE',
          where: "nombre LIKE ?",
          whereArgs: [condicion],
          orderBy: 'nombre asc');
    } else {
      return db.query('TBL_CLIENTE',
          where: "doc_cliente LIKE ?",
          whereArgs: [condicion],
          orderBy: 'nombre asc');
    }
  }

  static Future<List<Map<String, dynamic>>> buscaDireccion(int id) async {
    final db = await SQLHelper.db();
    return db.query('TBL_DIRECCION', where: "PKCliente = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> detalleDireccion(int id) async {
    final db = await SQLHelper.db();
    return db.query('TBL_DIRECCION',
        where: "iddireccionEnvio = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> buscarPrecios(int id) async {
    final db = await SQLHelper.db();
    return db.query('TBL_PRECIO',
        where: "codigoProducto = ?",
        whereArgs: [id],
        orderBy: "codigoProducto asc");
  }

  static Future<List<Map<String, dynamic>>> busquedaProducto(
      String tipo, String condicion) async {
    final db = await SQLHelper.db();
    if (tipo == 'nombre') {
      //return db.rawQuery(
      //  "SELECT tp.nombreProducto, tpr.precioProducto FROM TBL_PRODUCTO tp LEFT JOIN TBL_PRECIO tpr on tpr.codigoProducto = tp.codigo WHERE nombreProducto LIKE '${condicion}' order by nombreProducto GROUP BY tp.nombreProducto");
      //print(chamaquito);

      return db.query('TBL_PRODUCTO',
          where: "nombreProducto LIKE ?",
          whereArgs: [condicion],
          orderBy: 'nombreProducto asc');
    } else {
      return db.query('TBL_PRODUCTO',
          where: "codigo LIKE ?",
          whereArgs: [condicion],
          orderBy: 'nombreProducto asc');
    }
  }

  static Future<List<Map<String, dynamic>>> pimerPrecio(
      int codigoProducto, int idListaPrecio) async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        'SELECT * FROM TBL_PRECIO WHERE codigoProducto = ? AND idListaPrecio = ?',
        [codigoProducto, idListaPrecio]);
    /*return db.query('TBL_PRECIO',
        where: "codigoProducto = ?", whereArgs: [id], limit: 1);*/
  }

  static Future<List<Map<String, dynamic>>> igv() async {
    final db = await SQLHelper.db();
    return db.query('TBL_PARAMETRO');
  }

  static Future<List<Map<String, dynamic>>> buscarGeneral(idTipoPedido) async {
    final db = await SQLHelper.db();
    return db
        .query('TBL_GENERAL', where: "codigo = ?", whereArgs: [idTipoPedido]);
  }

  static Future<List<Map<String, dynamic>>> obtenerMetodos() async {
    final db = await SQLHelper.db();
    return db.query('TBL_GENERAL', where: "grupo = ?", whereArgs: ['MR']);
  }

  static Future<List<Map<String, dynamic>>> obtenerCuentas(int id) async {
    final db = await SQLHelper.db();
    return db.query('TBL_GENERAL',
        where: "grupo = ? AND atributo1 = ?", whereArgs: ['MRCU', id]);
  }

  static Future<int> insertarPedido(
    String codigoServidor,
    int fechaPedido,
    String fechaPedidoStr,
    String codigoCliente,
    String subcliente,
    String idTipoPedido,
    String descTipoPedido,
    String tipoPedido,
    String idListaPrecio,
    String idFormaPago,
    String ordenCompra,
    String idAlmacenVenta,
    String idDireccionEnvio,
    String direccionEnvio,
    String idDireccionFacturacion,
    String direccionFacturacion,
    String idEmpresa,
    String montoTotal,
    String codigoUsuario,
    String latitud,
    String longitud,
    String celdaGPS,
    String prioridad,
    String estadoPedido,
  ) async {
    final db = await SQLHelper.db();
    Map<String, dynamic> row = {
      'codigoServidor': codigoServidor,
      'fechaPedido': fechaPedido,
      'fechaPedidoStr': fechaPedidoStr,
      'codigoCliente': codigoCliente,
      'subcliente': subcliente,
      'idTipoPedido': idTipoPedido,
      'descTipoPedido': descTipoPedido,
      'tipoPedido': tipoPedido,
      'idListaPrecio': idListaPrecio,
      'idFormaPago': idFormaPago,
      'ordenCompra': ordenCompra,
      'idAlmacenVenta': idAlmacenVenta,
      'idDireccionEnvio': idDireccionEnvio,
      'direccionEnvio': direccionEnvio,
      'idDireccionFacturacion': idDireccionFacturacion,
      'direccionFacturacion': direccionFacturacion,
      'idEmpresa': idEmpresa,
      'montoTotal': montoTotal,
      'codigoUsuario': codigoUsuario,
      'latitud': latitud,
      'longitud': longitud,
      'celdaGPS': celdaGPS,
      'prioridad': prioridad,
      'estadoPedido': estadoPedido,
    };
    final insertedId = await db.insert(
      'TBL_PEDIDO',
      row,
    );
    print('insertedId: $insertedId');
    return insertedId;
  }

  static Future<String> agregarDetallePedido(
      int idPedido,
      String codigoArticulo,
      String codigoOEBS,
      String idTipoLinea,
      String nombreArticulo,
      String cantidadKGS,
      String cantidadUND,
      String cantidadUNDXJaba,
      String cantidadJabas,
      String factorConversion,
      String precioUnitario,
      String factorConversionV,
      String precioUnitarioV,
      String monto,
      String comentario,
      String rango_minimo,
      String rango_maximo) async {
    final db = await SQLHelper.db();
    await db.rawQuery(
        "INSERT INTO TBL_PEDIDO_DETALLE(idPedido, codigoArticulo, codigoOEBS, idTipoLinea, nombreArticulo, cantidadKGS, cantidadUND, cantidadUNDXJaba, cantidadJabas, factorConversion, precioUnitario, factorConversionV, precioUnitarioV, monto, comentario, rango_minimo, rango_maximo) VALUES ('${idPedido}','${codigoArticulo}','${codigoOEBS}','${idTipoLinea}','${nombreArticulo}','${cantidadKGS}','${cantidadUND}', '${cantidadUNDXJaba}', '${cantidadJabas}', '${factorConversion}', ${precioUnitario}, '${factorConversionV}', '${precioUnitarioV}', '${monto}', '${comentario}', '${rango_minimo}', '${rango_maximo}');");
    return 'se inserto ok';
  }

  static Future<List<Map<String, dynamic>>> precioConfig(int codigo) async {
    final db = await SQLHelper.db();
    return db
        .query('TBL_PRODUCTO_CONFIG', where: "codigo = ?", whereArgs: [codigo]);
  }

  static Future<String> createTables(sql.Database database) async {
    await database.execute(
      'CREATE TABLE cliente(customer_id INTEGER NOT NULL, customer_number VARCHAR(11) NOT NULL, customer_name VARCHAR(250) NOT NULL); CREATE TABLE direccion(customer_id INTEGER NOT NULL, bill_to_address TEXT NOT NULL, ship_to_address TEXT NOT NULL);',
    );
    print('se concreto la migracion');
    return 'Base de datos creada, conectada y tablas creadas';
  }

  //limpiar
  static Future<String> eliminarTablas() async {
    final db = await SQLHelper.db();
    await db.execute('DELETE FROM cliente');
    await db.execute('DELETE FROM direccion');
    return 'tablas eliminadas';
  }

  static Future<void> limpiarCliente() async {
    final db = await SQLHelper.db();

    try {
      await db.execute('DELETE FROM cliente');
    } catch (err) {
      debugPrint("el error es : $err");
    }
  }

  static Future<void> limpiarDireccion() async {
    final db = await SQLHelper.db();
    try {
      await db.execute('DELETE FROM direccion');
    } catch (err) {
      debugPrint("el error es : $err");
    }
  }

  //insertar
  static Future<int> createCliente(
      int customer_id, String customer_number, String customer_name) async {
    final db = await SQLHelper.db();
    final data = {
      'customer_id': customer_id,
      'customer_number': customer_number,
      'customer_name': customer_name
    };
    final id = await db.insert('cliente', data);
    return id;
  }

  static Future<int> createDireccion(
      int customer_id, String bill_to_address, String ship_to_address) async {
    final db = await SQLHelper.db();
    final data = {
      'customer_id': customer_id,
      'bill_to_address': bill_to_address,
      'ship_to_address': ship_to_address
    };
    final id = await db.insert('direccion', data);
    return id;
  }

  static Future<int> createPedido() async {
    final db = await SQLHelper.db();
    final data = {'id': 1};
    final id = await db.insert('pedidos', data);
    return id;
  }

  //listar
  static Future<List<Map<String, dynamic>>> getPedidos() async {
    final db = await SQLHelper.db();
    return db.query('pedidos', orderBy: "id");
  }

  //leer un item
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('pedidos', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //actualizar
  static Future<int> updateItem(int id) async {
    final db = await SQLHelper.db();
    final data = {
      'id': 1,
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //eliminar
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('items', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("el error es : $err");
    }
  }
}
