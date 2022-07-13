import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:elrocio/sql_helper.dart';

class SincronizacionPage extends StatefulWidget {
  SincronizacionPage({Key? key}) : super(key: key);

  @override
  State<SincronizacionPage> createState() => _SincronizacionPageState();
}

class _SincronizacionPageState extends State<SincronizacionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _textBtn = Colors.white;
  double _fontSize = 18.0;

  String _codigo = '';

  Future setearData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      _codigo = pref.getString('idOEBS').toString();
    });
  }

  Future<void> _cierreModal() async {
    Navigator.pop(context);
  }

  void _modalSincronizaTodo(BuildContext context) async {
    //Navigator.of(_scaffoldKey.currentContext!).pop();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: _colorBtn,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Sincronizando....')
                ],
              ),
            ),
          );
        });

    String urlSincroniza =
        "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=${_codigo}";
    await http.get(
      Uri.parse(urlSincroniza),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) async {
      String respuestitaString = value.body.toString();
      var bar = respuestitaString.split(";");

      await SQLHelper.createTablesScript('DROP TABLE IF EXISTS TBL_PEDIDO;');
      await SQLHelper.createTablesScript(
          'DROP TABLE IF EXISTS TBL_PEDIDO_DETALLE;');
      await SQLHelper.createTablesScript(
          'CREATE TABLE IF NOT EXISTS TBL_PEDIDO( _id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,codigoServidor VARCHAR(300), fechaPedido numeric,  fechaPedidoStr VARCHAR(300), codigoCliente VARCHAR(300), subcliente VARCHAR(300), idTipoPedido VARCHAR(300), descTipoPedido VARCHAR(300), tipoPedido VARCHAR(20), idListaPrecio VARCHAR(100), idFormaPago VARCHAR(100), ordenCompra VARCHAR(100), idAlmacenVenta VARCHAR(100), idDireccionEnvio VARCHAR(200), direccionEnvio VARCHAR(300), idDireccionFacturacion VARCHAR(200), direccionFacturacion VARCHAR(300), idEmpresa VARCHAR(100), montoTotal VARCHAR(200), codigoUsuario VARCHAR(100), latitud VARCHAR(200), longitud VARCHAR(200), celdaGPS VARCHAR(150), prioridad VARCHAR(100), estadoPedido VARCHAR(30));');
      await SQLHelper.createTablesScript(
          'CREATE TABLE IF NOT EXISTS TBL_PEDIDO_DETALLE( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,idPedido INTEGER, codigoArticulo VARCHAR(100), codigoOEBS VARCHAR(100), idTipoLinea VARCHAR(100), nombreArticulo VARCHAR(300), cantidadKGS VARCHAR(100), cantidadUND VARCHAR(100), cantidadUNDXJaba VARCHAR(100) NULL, cantidadJabas VARCHAR(100) NULL, factorConversion VARCHAR(100), precioUnitario VARCHAR(100), factorConversionV VARCHAR(100), precioUnitarioV VARCHAR(100), monto VARCHAR(100), comentario VARCHAR(100) null, rango_minimo VARCHAR(100) null, rango_maximo VARCHAR(100) null)');

      await ejecutaScript(bar).then((value2) {
        Fluttertoast.showToast(
          msg: 'Se sincronizó de manera correcta',
          //toastLength: Toast.LENGTH_SHORT,
          //gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          //backgroundColor: Colors.red,
          /*textColor: Colors.yellow*/
        );
      });
      /*await abcDef(bar).then((value1) async {
        await _cierreModal().then((value2) {
          print('aqui termino');
          Fluttertoast.showToast(
            msg: 'Se sincronizó de manera correcta',
            //toastLength: Toast.LENGTH_SHORT,
            //gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            //backgroundColor: Colors.red,
            /*textColor: Colors.yellow*/
          );
        });
      });*/
    });
  }

  Future<String> ejecutaScript(script) async {
    List<dynamic> asdf = await SQLHelper.leerScript(script);
    print(asdf);
    return 'ok';
  }

  Future<int> abcDef(bar) async {
    int resp = 0;
    print(bar.length);
    /*await bar.forEach((element) async {
      //print(element);
      await SQLHelper.createTablesScript(element);
      resp = 1;
    });*/

    for (var i = 0; i < bar.length; i++) {
      await SQLHelper.createTablesScript(bar[i]);

      if (i == (bar.length - 1)) {
        print('llego a su fin');
        resp = 1;
        return resp;
      }
    }
    return resp;
  }

  Future<void> _sincronizaTodo() async {
    String urlSincroniza =
        "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=${_codigo}";

    final http.Response responseSincroniza = await http.get(
      Uri.parse(urlSincroniza),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    int resp = 0;
    await SQLHelper.createTablesScript('DROP TABLE IF EXISTS TBL_PEDIDO;');
    await SQLHelper.createTablesScript(
        'DROP TABLE IF EXISTS TBL_PEDIDO_DETALLE;');
    await SQLHelper.createTablesScript(
        'CREATE TABLE IF NOT EXISTS TBL_PEDIDO( _id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,codigoServidor VARCHAR(300), fechaPedido numeric,  fechaPedidoStr VARCHAR(300), codigoCliente VARCHAR(300), subcliente VARCHAR(300), idTipoPedido VARCHAR(300), descTipoPedido VARCHAR(300), tipoPedido VARCHAR(20), idListaPrecio VARCHAR(100), idFormaPago VARCHAR(100), ordenCompra VARCHAR(100), idAlmacenVenta VARCHAR(100), idDireccionEnvio VARCHAR(200), direccionEnvio VARCHAR(300), idDireccionFacturacion VARCHAR(200), direccionFacturacion VARCHAR(300), idEmpresa VARCHAR(100), montoTotal VARCHAR(200), codigoUsuario VARCHAR(100), latitud VARCHAR(200), longitud VARCHAR(200), celdaGPS VARCHAR(150), prioridad VARCHAR(100), estadoPedido VARCHAR(30));');
    await SQLHelper.createTablesScript(
        'CREATE TABLE IF NOT EXISTS TBL_PEDIDO_DETALLE( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,idPedido INTEGER, codigoArticulo VARCHAR(100), codigoOEBS VARCHAR(100), idTipoLinea VARCHAR(100), nombreArticulo VARCHAR(300), cantidadKGS VARCHAR(100), cantidadUND VARCHAR(100), cantidadUNDXJaba VARCHAR(100) NULL, cantidadJabas VARCHAR(100) NULL, factorConversion VARCHAR(100), precioUnitario VARCHAR(100), factorConversionV VARCHAR(100), precioUnitarioV VARCHAR(100), monto VARCHAR(100), comentario VARCHAR(100) null, rango_minimo VARCHAR(100) null, rango_maximo VARCHAR(100) null)');
    String respuestitaString = responseSincroniza.body.toString();
    var bar = respuestitaString.split(";");
    bar.forEach((element) async {
      //print(element);
      await SQLHelper.createTablesScript(element);
      resp = 1;
    });
  }

  void _modalSincronizaDocumentos(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: _colorBtn,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Sincronizando....')
                ],
              ),
            ),
          );
        });

    String urlSincroniza =
        "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=${_codigo}";
    await http.get(
      Uri.parse(urlSincroniza),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((value) async {
      String respuestitaString = value.body.toString();
      var bar = respuestitaString.split(";");
      await ejecutaScript(bar).then((value2) {
        Fluttertoast.showToast(
          msg: 'Se sincronizó de manera correcta',
          //toastLength: Toast.LENGTH_SHORT,
          //gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          //backgroundColor: Colors.red,
          /*textColor: Colors.yellow*/
        );
      });
      /*await abcDef(bar).then((value1) async {
        await _cierreModal().then((value2) {
          print('aqui termino');
          Fluttertoast.showToast(
            msg: 'Se sincronizó de manera correcta',
            //toastLength: Toast.LENGTH_SHORT,
            //gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            //backgroundColor: Colors.red,
            /*textColor: Colors.yellow*/
          );
        });
      });*/
    });
  }

  void _sincronizarDocumento() async {
    String urlSincroniza =
        "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=${_codigo}";

    final http.Response responseSincroniza = await http.get(
      Uri.parse(urlSincroniza),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    int resp = 0;

    String respuestitaString = responseSincroniza.body.toString();
    var bar = respuestitaString.split(";");
    bar.forEach((element) async {
      //print(element);
      await SQLHelper.createTablesScript(element);
      resp = 1;
    });
  }

  void _limpiar() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: _colorBtn,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Limpiando....')
                ],
              ),
            ),
          );
        });

    await Future.delayed(
      Duration(seconds: 5),
      () async {
        SQLHelper.limpiarMemoria();
      },
    );

    Navigator.of(context).pop();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            scrollable: true,
            content: Column(
              children: [
                Center(
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 50.0,
                        color: Colors.green[400],
                      ),
                      Text('Limpieza Correcta',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17.0)),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text('¡ Se limpio la memoria !'),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: MaterialButton(
                            color: _colorBtn,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text(
                              'OK',
                              style: TextStyle(color: _textBtn),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              /*var ruta = MaterialPageRoute(
                                    builder: (context) => HomePage());
                                Navigator.push(context, ruta);*/
                            })),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    setearData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Sincronizacion'),
            centerTitle: true,
          ),
          body: _body()),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
      child: Column(
        children: [
          _btnSincronizaTodo(),
          _sideBox(),
          _btnSincronizaDocumentos(),
          _sideBox(),
          _btnLimpiarMemoria()
        ],
      ),
    );
  }

  Widget _sideBox() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget _icono() {
    return Icon(
      Icons.update,
      color: _textBtn,
      size: 30.0,
    );
  }

  Widget _btnSincronizaTodo() {
    return Container(
      height: 50.0,
      child: MaterialButton(
          color: _colorBtn,
          child: Row(
            children: [
              _icono(),
              Text(
                '   TODO',
                style: TextStyle(color: _textBtn, fontSize: _fontSize),
              ),
            ],
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      scrollable: true,
                      content: Column(
                        children: [
                          Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  size: 50.0,
                                  color: Colors.amber[700],
                                ),
                                Text('ATENCION',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17.0)),
                              ],
                            ),
                          ),
                          Divider(),
                          Text(
                              'ATENCION: Se actualizará la data maestra en el equipo. ¿Desea continuar?'),
                          Divider(),
                          Row(
                            children: [
                              Expanded(
                                  child: MaterialButton(
                                      color: _colorBtn,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Text(
                                        'SI',
                                        style: TextStyle(color: _textBtn),
                                      ),
                                      onPressed: () async {
                                        /*Future.delayed(Duration(seconds: 1),
                                            () {
                                          Navigator.pop(context);
                                        });*/
                                        //Navigator.pop(context);
                                        await _cierreModal().then((value) {
                                          _modalSincronizaTodo(context);
                                        });
                                        //Navigator.pop(context);
                                      })),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  child: MaterialButton(
                                      //color: Colors.red[200],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              color: _colorBtn, width: 2.0)),
                                      child: Text(
                                        'NO',
                                        style: TextStyle(color: _colorBtn),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }))
                            ],
                          )
                        ],
                      ));
                });
            /*var ruta =
                          MaterialPageRoute(builder: (context) => PedidoPage());
                      Navigator.push(context, ruta);*/
          }),
    );
  }

  Widget _btnSincronizaDocumentos() {
    return Container(
      //margin: EdgeInsets.only(top: 20.0),
      height: 50.0,
      child: MaterialButton(
          color: _colorBtn,
          child: Row(
            children: [
              _icono(),
              Text(
                '   DOCUMENTOS',
                style: TextStyle(color: _textBtn, fontSize: _fontSize),
              ),
            ],
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      scrollable: true,
                      content: Column(
                        children: [
                          Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  size: 50.0,
                                  color: Colors.amber[700],
                                ),
                                Text('ATENCION',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17.0)),
                              ],
                            ),
                          ),
                          Divider(),
                          Text(
                              'ATENCION: Se actualizará la data maestra de documentos de venta. ¿Desea continuar?'),
                          Divider(),
                          Row(
                            children: [
                              Expanded(
                                  child: MaterialButton(
                                      color: _colorBtn,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Text(
                                        'SI',
                                        style: TextStyle(color: _textBtn),
                                      ),
                                      onPressed: () async {
                                        /*Future.delayed(Duration(seconds: 1),
                                            () {
                                          Navigator.pop(context);
                                        });*/
                                        //Navigator.pop(context);
                                        //_modalSincronizaTodo(context);
                                        await _cierreModal().then((value) {
                                          _modalSincronizaDocumentos(context);
                                        });
                                      })),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  child: MaterialButton(
                                      //color: Colors.red[200],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              color: _colorBtn, width: 2.0)),
                                      child: Text(
                                        'NO',
                                        style: TextStyle(color: _colorBtn),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }))
                            ],
                          )
                        ],
                      ));
                });
          }),
    );
  }

  Widget _btnLimpiarMemoria() {
    return Container(
      //margin: EdgeInsets.only(top: 20.0),
      height: 50.0,
      child: MaterialButton(
          color: _colorBtn,
          child: Row(
            children: [
              _icono(),
              Text(
                '   LIMPIAR MEMORIA',
                style: TextStyle(color: _textBtn, fontSize: _fontSize),
              ),
            ],
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      scrollable: true,
                      content: Column(
                        children: [
                          Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  size: 50.0,
                                  color: Colors.amber[700],
                                ),
                                Text('ATENCION',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17.0)),
                              ],
                            ),
                          ),
                          Divider(),
                          Text('ATENCION: Se borrará los pedidos pendientes'),
                          Divider(),
                          Row(
                            children: [
                              Expanded(
                                  child: MaterialButton(
                                      color: _colorBtn,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Text(
                                        'SI',
                                        style: TextStyle(color: _textBtn),
                                      ),
                                      onPressed: () async {
                                        await SQLHelper.limpiarMemoria();
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                          msg:
                                              'Se eliminaron los pedidos/cobranzas almacenados en memoria',
                                          //toastLength: Toast.LENGTH_SHORT,
                                          //gravity: ToastGravity.BOTTOM,
                                          //timeInSecForIos: 1,
                                          //backgroundColor: Colors.red,
                                          /*textColor: Colors.yellow*/
                                        );
                                      })),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  child: MaterialButton(
                                      //color: Colors.red[200],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              color: _colorBtn, width: 2.0)),
                                      child: Text(
                                        'NO',
                                        style: TextStyle(color: _colorBtn),
                                      ),
                                      onPressed: () {}))
                            ],
                          )
                        ],
                      ));
                });
          }),
    );
  }
}
