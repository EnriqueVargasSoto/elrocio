import 'dart:convert';
import 'dart:ffi';
import 'package:elrocio/sql_helper.dart';
import 'package:elrocio/src/pages/detalle_cliente.dart';
import 'package:elrocio/src/pages/pvivo.dart';
import 'package:elrocio/src/pages/transacciones.dart';
import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';

import '../modelos/cliente_model.dart';

class PedidoPage extends StatefulWidget {
  PedidoPage({Key? key}) : super(key: key);

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  final TextEditingController texto = TextEditingController();

  SingingCharacter? _character = SingingCharacter.nombre;
  String tipo = 'nombre';
  final List<Widget> opciones = [];

  String user = 'u_wost';
  String pass = '\$w0st#sql+';

  var aux2;
  int count = 0;

  Future conexion() async {
    debugPrint("Connecting...");
    print('**********');
    print(user);
    print(pass);
    print('**********');
    try {
      await SqlConn.connect(
          ip: "10.45.0.218",
          port: "1433",
          databaseName: "BDComercial",
          username: user,
          password: pass);
      debugPrint("Connected!");
      //getClientes();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      //Navigator.pop(context);
    }
  }

  Future<List<dynamic>> getClientes(String consulta) async {
    var res = await SQLHelper.busquedaNombre(tipo, consulta);

    var aux2 = res as List<dynamic>;

    return aux2;
  }

  buscar(tipo, texto) {
    print('*******');
    print(tipo);
    print(texto);
    print('*******');
    conexion();
  }

  @override
  void initState() {
    conexion();

    ///super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Pedidos'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TransaccionesPage()));
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                            activeColor: Color.fromRGBO(97, 0, 236, 1),
                            value: SingingCharacter.nombre,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                                tipo = 'nombre';
                              });
                            }),
                        Expanded(
                          child: Text('Por Nombre'),
                        )
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                            activeColor: Color.fromRGBO(97, 0, 236, 1),
                            value: SingingCharacter.codigo,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                                tipo = 'codigo';
                              });
                            }),
                        Expanded(child: Text('Por Codigo'))
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Center(
                          child: TextField(
                    controller: texto,
                    decoration: new InputDecoration(
                        labelText: 'Ingrese aquí el texto a buscar'),
                  )))
                ],
              ),
              Container(
                height: 40.0,
                child: MaterialButton(
                    color: Color.fromRGBO(97, 0, 236, 1),
                    child: Text(
                      'BUSCAR',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _listar();
                      });
                      //buscar(tipo, texto.text);
                      /*var ruta = MaterialPageRoute(builder: (context) => PedidoPage());
                      Navigator.push(context, ruta);*/
                    }),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30.0),
                  height: 500.0,
                  child: _listar())
            ],
          ),
        ),
      ),
    );
  }

  Widget _listar() {
    var param = texto.text;
    String consulta = '';
    if (param != null && param != '') {
      if (tipo == 'nombre') {
        consulta = '%$param%';
        //"SELECT * FROM TBL_CLIENTE Where nombre like '%$param%' order by customer_name asc";
      } else {
        consulta = '%$param%';
        //"SELECT * FROM TBL_CLIENTE Where nombre like '%$param%' order by customer_name asc";
      }
      print(consulta);
      return FutureBuilder(
          future: getClientes(consulta),
          initialData: [],
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            return ListView(
              children: _listarItems(snapshot.data ?? [], context),
            );
          });
    } else {
      return Text(' ');
    }
  }

  List<Widget> _listarItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    var aux = '';
    data.forEach((element) {
      final widgetTemp = GestureDetector(
        onTap: () {
          print(element);
          var ruta = MaterialPageRoute(
              builder: (context) => DetalleCliente(
                  element['PKCliente'],
                  element['doc_cliente'].toString(),
                  element['nombre'].toString(),
                  element['saldopendiente'].toString()));
          Navigator.push(context, ruta);
        },
        child: ListTile(
          title: Text(element['nombre']),
        ),
      );

      if (element['nombre'][0] != aux) {
        final widgetTemp2 = Container(
            color: Color.fromRGBO(97, 0, 236, 1),
            child: ListTile(
              title: Text(
                element['nombre'][0],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ));
        opciones..add(widgetTemp2);
        aux = element['nombre'][0];
      }

      opciones
        ..add(widgetTemp)
        ..add(Divider());
    });

    return opciones;
  }
}

enum SingingCharacter { nombre, codigo }
