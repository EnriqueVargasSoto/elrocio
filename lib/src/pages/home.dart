import 'package:elrocio/src/pages/envios.dart';
import 'package:elrocio/src/pages/login.dart';
import 'package:elrocio/src/pages/pvivo.dart';
import 'package:elrocio/src/pages/reportes_pollo_vivo.dart';
import 'package:elrocio/src/pages/sincronizacion.dart';
import 'package:elrocio/src/pages/transacciones.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _nombreUsuario = '';

  Future setearData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      _nombreUsuario = pref.getString('resultado').toString();
    });
  }

  Future clear() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    var ruta = MaterialPageRoute(builder: (context) => LoginPage());
    Navigator.push(context, ruta);
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
            title: Text('Home'),
            centerTitle: true),
        drawer: _drawer(),
        body: Center(
          child: _mensaje(),
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Image(image: AssetImage('assets/header_login.png')),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.transform_sharp),
            title: Text('Transacciones'),
            onTap: () {
              var ruta =
                  MaterialPageRoute(builder: (context) => TransaccionesPage());
              Navigator.push(context, ruta);
            },
          ),
          ListTile(
            leading: Icon(Icons.replay_rounded),
            title: Text('Sincronizacion'),
            onTap: () {
              var ruta =
                  MaterialPageRoute(builder: (context) => SincronizacionPage());
              Navigator.push(context, ruta);
            },
          ),
          ListTile(
            leading: Icon(Icons.airline_stops_sharp),
            title: Text('Envios'),
            onTap: () {
              var ruta = MaterialPageRoute(builder: (context) => Envios());
              Navigator.push(context, ruta);
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text('Resumen Pedidos P.V.'),
            onTap: () {
              var ruta =
                  MaterialPageRoute(builder: (context) => ReportePolloVivo());
              Navigator.push(context, ruta);
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text('Resumen Pedidos P.B.'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Resumen Cobranzas'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Salir'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(
                        child: Icon(
                          Icons.warning_amber,
                          color: Colors.amber[600],
                          size: 70.0,
                        ),
                      ),
                      content: Container(
                        height: 45.0,
                        child: Column(
                          children: [
                            Text(
                              'Cerrar Sessión!.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '¿Desea cerrar sessión?. ',
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
                            color: Colors.amber[600],
                            onPressed: () async {
                              clear();
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
            },
          ),
        ],
      ),
    );
  }

  Widget _mensaje() {
    return Text(_nombreUsuario);
  }
}
