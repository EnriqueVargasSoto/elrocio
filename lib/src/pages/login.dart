import 'dart:convert';
import 'dart:io';
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
  /*-------------------------- VARIABLES --------------------------*/
  final EdgeInsets _paddingContainer =
      EdgeInsets.only(top: 100.0, left: 25.0, right: 25.0);
  final EdgeInsets _paddingLoading = EdgeInsets.symmetric(vertical: 20.0);

  final String _ubicacionLogo = 'assets/header_login.png';
  final String _ubicacionIconWaring = 'assets/warning.png';
  final String _ubicacionIconCancelar = 'assets/cancelar.png';
  final String _ubicacionIconComprobado = 'assets/comprobado.png';
  final String _urlLogin =
      "http://18.232.18.100/wscomercial/handlers/SC_LoginAndroid.ashx";

  double _separacion = 20.0;

  TextEditingController _usuario = TextEditingController();
  TextEditingController _password = TextEditingController();

  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _colorTextBtn = Colors.white;

  Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };
  Map<String, String> _bodyHttp = {};

  /*-------------------------- FIN VARIABLES --------------------------*/

  void pruebaConxion(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _auth(context);
      }
    } on SocketException catch (e) {
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
                          Icons.error,
                          size: 50.0,
                          color: Colors.red[600],
                        ),
                        Text('Error',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 17.0)),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('¡ Sin acceso a internet !.'),
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
                                style: TextStyle(color: _colorTextBtn),
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

  void _setearData(usuario) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString('isLogged', '1');
    pref.setString('codigo', usuario['codigo'].toString());
    pref.setString('compania', usuario['compania'].toString());
    pref.setString('fechaCaja', usuario['fechaCaja'].toString());
    pref.setString('idCaja', usuario['idCaja'].toString());
    pref.setString('idOEBS', usuario['idOEBS'].toString());
    pref.setString('idResultado', usuario['idResultado'].toString());
    pref.setString('login', usuario['login'].toString());
    pref.setString('nombres', usuario['nombres'].toString());
    pref.setString('nroSerie', usuario['nroSerie'].toString());
    pref.setString('password', usuario['password'].toString());
    pref.setString('resultado', usuario['resultado'].toString());
    pref.setString('tipoPedido', usuario['tipoPedido'].toString());
  }

  void _auth(BuildContext context) async {
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
                  Text('Validando Usuario....')
                ],
              ),
            ),
          );
        });

    var postUsuario = _usuario.text;
    var appleInBytes = utf8.encode(_password.text);
    var postPassword = sha1.convert(appleInBytes);

    await http
        .post(
      Uri.parse(_urlLogin),
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
    )
        .then((value) async {
      Map respuesta = json.decode(value.body);

      if (respuesta['idResultado'] == 1) {
        _setearData(respuesta);

        String urlSincroniza =
            "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=${respuesta['idOEBS']}";
        /*String urlSincroniza =
            "http://18.232.18.100/wscomercial/handlers/SC_SincronizaDatosMovil.ashx?codVendedor=${respuesta['idOEBS']}";*/
        await http.get(
          Uri.parse(urlSincroniza),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ).then((value1) async {
          String respuestitaString = value1.body.toString();
          List bar = respuestitaString.split(";");

          await SQLHelper.createTablesScript(
              'DROP TABLE IF EXISTS TBL_PEDIDO;');
          await SQLHelper.createTablesScript(
              'DROP TABLE IF EXISTS TBL_PEDIDO_DETALLE;');
          await SQLHelper.createTablesScript(
              'CREATE TABLE IF NOT EXISTS TBL_PEDIDO( _id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,codigoServidor VARCHAR(300), fechaPedido numeric,  fechaPedidoStr VARCHAR(300), codigoCliente VARCHAR(300), subcliente VARCHAR(300), idTipoPedido VARCHAR(300), descTipoPedido VARCHAR(300), tipoPedido VARCHAR(20), idListaPrecio VARCHAR(100), idFormaPago VARCHAR(100), ordenCompra VARCHAR(100), idAlmacenVenta VARCHAR(100), idDireccionEnvio VARCHAR(200), direccionEnvio VARCHAR(300), idDireccionFacturacion VARCHAR(200), direccionFacturacion VARCHAR(300), idEmpresa VARCHAR(100), montoTotal VARCHAR(200), codigoUsuario VARCHAR(100), latitud VARCHAR(200), longitud VARCHAR(200), celdaGPS VARCHAR(150), prioridad VARCHAR(100), estadoPedido VARCHAR(30));');
          await SQLHelper.createTablesScript(
              'CREATE TABLE IF NOT EXISTS TBL_PEDIDO_DETALLE( id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,idPedido INTEGER, codigoArticulo VARCHAR(100), codigoOEBS VARCHAR(100), idTipoLinea VARCHAR(100), nombreArticulo VARCHAR(300), cantidadKGS VARCHAR(100), cantidadUND VARCHAR(100), cantidadUNDXJaba VARCHAR(100) NULL, cantidadJabas VARCHAR(100) NULL, factorConversion VARCHAR(100), precioUnitario VARCHAR(100), factorConversionV VARCHAR(100), precioUnitarioV VARCHAR(100), monto VARCHAR(100), comentario VARCHAR(100) null, rango_minimo VARCHAR(100) null, rango_maximo VARCHAR(100) null)');

          await ejecutaScript(bar).then((value2) {
            print(value2);
            Navigator.pop(context);
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
                              Text('Logueo Correcto',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17.0)),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Text('${respuesta['nombres']}.'),
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
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Text(
                                      'OK',
                                      style: TextStyle(color: _colorTextBtn),
                                    ),
                                    onPressed: () {
                                      /*var ruta = MaterialPageRoute(
                                          builder: (context) => HomePage());
                                      Navigator.of(_scaffoldKey.currentContext!)
                                          .push(ruta);*/
                                    }))
                          ],
                        )
                      ],
                    ),
                  );
                });
          });
        });
      } else {
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
                            Icons.error,
                            size: 50.0,
                            color: Colors.red[500],
                          ),
                          Text('ERROR',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17.0)),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('ATENCION: Credenciales no registradas.'),
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
                                  style: TextStyle(color: _colorTextBtn),
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

  Future<void> validar(BuildContext context) async {
    SQLHelper.db();
    if (_usuario.text != '') {
      if (_password.text != '') {
        pruebaConxion(context);
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
                    SizedBox(
                      height: 10,
                    ),
                    Text('ATENCION: Se debe llenar el campo Password.'),
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
                                  style: TextStyle(color: _colorTextBtn),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
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
                  SizedBox(
                    height: 10,
                  ),
                  Text('ATENCION: Se debe llenar el campo User.'),
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
                                style: TextStyle(color: _colorTextBtn),
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
    //startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(body: _body()),
    );
  }

  Widget _body() {
    return Container(
      padding: _paddingContainer,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _imagen(),
          SizedBox(
            height: _separacion,
          ),
          _inputUsuario(),
          SizedBox(
            height: _separacion,
          ),
          _inputPassword(),
          SizedBox(
            height: _separacion,
          ),
          _btnLogin()
        ],
      ),
    );
  }

  Widget _imagen() {
    return Center(
      child: Image(image: AssetImage(_ubicacionLogo)),
    );
  }

  Widget _inputUsuario() {
    return Center(
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: _usuario,
        decoration: new InputDecoration(labelText: 'User'),
      ),
    );
  }

  Widget _inputPassword() {
    return Center(
      child: TextField(
        keyboardType: TextInputType.phone,
        obscureText: true,
        controller: _password,
        decoration: new InputDecoration(labelText: 'Password'),
      ),
    );
  }

  Widget _btnLogin() {
    return Center(
        child: MaterialButton(
            color: _colorBtn,
            child: Text(
              '  INGRESAR  ',
              style: TextStyle(color: _colorTextBtn),
            ),
            onPressed: () {
              //validaUsuario(context);
            }));
  }
}
