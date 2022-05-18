import 'package:elrocio/src/pages/transacciones.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Image(
                  image: AssetImage('assets/header_login.png')
                ),
                
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
                  var ruta = MaterialPageRoute(builder: (context) => TransaccionesPage());
                    Navigator.push(context, ruta);
                },
              ),
              ListTile(
                leading: Icon(Icons.replay_rounded),
                title: Text('Sincronizacion'),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.airline_stops_sharp),
                title: Text('Envios'),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('Resumen Pedidos P.V.'),
                onTap: () => {},
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
                onTap: () => {},
              ),
            ],
          ),
        )
      ),
    );
  }
}