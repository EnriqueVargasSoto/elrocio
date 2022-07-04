import 'dart:convert';

import 'package:elrocio/sql_helper.dart';
import 'package:elrocio/src/pages/home.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:sql_conn/sql_conn.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _textBtn = Colors.white;

  final TextEditingController usuario = TextEditingController();
  final TextEditingController password = TextEditingController();

  String createTablePedido =
      'CREATE TABLE IF NOT EXISTS TBL_PEDIDO( _id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,codigoServidor varchar(250) null, fechaPedido varchar(250) null,  fechaPedidoStr VARCHAR(250), codigoCliente VARCHAR(50), subcliente varchar(150), idTipoPedido VARCHAR(150), descTipoPedido VARCHAR(150), tipoPedido varchar(2), idListaPrecio VARCHAR(300), idFormaPago varchar(250), ordenCompra VARCHAR(300), idAlmacenVenta varchar(150), terminoPago VARCHAR(30), idtipoPedido numeric, tipoPedido VARCHAR(200), idListaPrecio numeric, listaPrecio VARCHAR(100), idTerritorio numeric, territorio VARCHAR(100), vendedorid numeric, subCliente VARCHAR(250), numeroItems numeric, fechaPedido VARCHAR(100), subTotal VARCHAR(30), igv VARCHAR(30), total VARCHAR(30), prioridad numeric);';

  //String url =
  //"https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_LoginAndroid.ashx";
  String url = "http://18.232.18.100/wscomercial/handlers/SC_LoginAndroid.ashx";

  Future<void> validarUsuario(BuildContext contex) async {
    var postUsuario = usuario.text;
    var appleInBytes = utf8.encode(password.text);
    var postPassword = sha1.convert(appleInBytes);

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "idSalesperson": "0",
        "idUsuario": "0",
        "login": postUsuario.toString(),
        "password": postPassword.toString(),
        "nombres": "",
        "compania": "",
        "clase": "",
        "resultado": "",
        "idResultado": "0"
      }),
    );

    var usuarioResponse = json.decode(response.body);
    //print(usuarioResponse['idResultado'] == 1);
    if (usuarioResponse['idResultado'] == 1) {
      final SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('isLogged', '1');
      pref.setString('codigo', usuarioResponse['codigo'].toString());
      pref.setString('compania', usuarioResponse['compania'].toString());
      pref.setString('fechaCaja', usuarioResponse['fechaCaja'].toString());
      pref.setString('idCaja', usuarioResponse['idCaja'].toString());
      pref.setString('idOEBS', usuarioResponse['idOEBS'].toString());
      pref.setString('idResultado', usuarioResponse['idResultado'].toString());
      pref.setString('login', usuarioResponse['login'].toString());
      pref.setString('nombres', usuarioResponse['nombres'].toString());
      pref.setString('nroSerie', usuarioResponse['nroSerie'].toString());
      pref.setString('password', usuarioResponse['password'].toString());
      pref.setString('resultado', usuarioResponse['resultado'].toString());
      pref.setString('tipoPedido', usuarioResponse['tipoPedido'].toString());

      String urlSincroniza =
          "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=${usuarioResponse['idOEBS']}";
      //String urlSincroniza = "http://18.232.18.100/wscomercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=100000050";
      //print('la url es ${urlSincroniza}');
      final http.Response responseSincroniza = await http.get(
        Uri.parse(urlSincroniza),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

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
      });

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green[600],
                  size: 70.0,
                ),
              ),
              content: Container(
                height: 45.0,
                child: Column(
                  children: [
                    Text(
                      'Sincronización Correcta!.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Bienvenido ${usuarioResponse['nombres']}. ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              actions: [
                Center(
                  child: MaterialButton(
                    color: Colors.green[600],
                    onPressed: () {
                      var ruta =
                          MaterialPageRoute(builder: (context) => HomePage());
                      Navigator.push(context, ruta);
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          });

      /*var ruta = MaterialPageRoute(builder: (context) => HomePage());
      Navigator.push(context, ruta);*/
    } else {
      //throw Exception('Failed to load album');
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
                          color: Colors.red[700],
                        ),
                        Text('ATENCION',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 17.0)),
                      ],
                    ),
                  ),
                  Divider(),
                  Text('ATENCION: ¡Credenciales no encontradas!'),
                  Divider(),
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
                              onPressed: () {
                                Navigator.pop(context);
                              })),
                    ],
                  )
                ],
              ),
            );
          });
    }
  }

  Future<void> validar(BuildContext context) async {
    SQLHelper.db();
    if (usuario.text != '') {
      if (password.text != '') {
        validarUsuario(context);
      } else {
        return showDialog(
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
                                  fontWeight: FontWeight.w400, fontSize: 17.0)),
                        ],
                      ),
                    ),
                    Divider(),
                    Text('ATENCION: Se debe llenar el campo Password.'),
                    Divider(),
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
                                onPressed: () {
                                  Navigator.pop(context);
                                })),
                      ],
                    )
                  ],
                ),
              );
            });
      }
    } else {
      print('no hay usuario');
      return showDialog(
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
                                fontWeight: FontWeight.w400, fontSize: 17.0)),
                      ],
                    ),
                  ),
                  Divider(),
                  Text('ATENCION: Se debe llenar el campo User.'),
                  Divider(),
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
                              onPressed: () {
                                Navigator.pop(context);
                              })),
                    ],
                  )
                ],
              ),
            );
          });
    }
  }

  Future<void> startApp() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString('isLogged') == '1') {
      var ruta = MaterialPageRoute(builder: (context) => HomePage());
      Navigator.push(context, ruta);
    } else {
      return null;
    }
  }

  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 100.0, left: 25.0, right: 25.0),
        child: ListView(
          children: [imagen(), inputUsuario(), inputPassword(), btnLogin()],
        ),
      ),
    );
  }

  Widget imagen() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: Image(image: AssetImage('assets/header_login.png')),
        ))
      ],
    );
  }

  Widget inputUsuario() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: usuario,
            decoration: new InputDecoration(labelText: 'User'),
          ),
        ))
      ],
    );
  }

  Widget inputPassword() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: TextField(
            keyboardType: TextInputType.phone,
            obscureText: true,
            controller: password,
            decoration: new InputDecoration(labelText: 'Password'),
          ),
        ))
      ],
    );
  }

  Widget btnLogin() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: MaterialButton(
                color: Color.fromRGBO(97, 0, 236, 1),
                child: Text(
                  'INGRESAR',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  validar(context);
                }),
          ),
        ))
      ],
    );
  }
}
