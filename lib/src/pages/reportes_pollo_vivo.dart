import 'dart:convert';

import 'package:elrocio/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportePolloVivo extends StatefulWidget {
  ReportePolloVivo({Key? key}) : super(key: key);

  @override
  State<ReportePolloVivo> createState() => _ReportePolloVivoState();
}

class _ReportePolloVivoState extends State<ReportePolloVivo> {
  DateTime _selectedDate = DateTime.now();
  String _fecha = '';
  String url =
      "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_ListarPedidos.ashx";

  void setearDatos() {
    _fecha = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  Future<List<dynamic>> getPedidosPolloVivo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<dynamic> arrPedidos = [];
    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        /*"idSalesperson": "0",
        "idUsuario": "0",
        "login": postUsuario.toString(),
        "password": postPassword.toString(),
        "nombres": "",
        "compania": "",
        "clase": "",
        "resultado": "",
        "idResultado": "0"*/
        "codigo": "15",
        "compania": "82",
        "fechaCaja": "2022-07-07",
        "idCaja": "10925",
        "idOEBS": "15",
        "idResultado": "1",
        "login": "0050",
        "nombres": "ROBERTO NAVARRO",
        "nroSerie": "E",
        "password": "95DD84C617999229B78C5F962FFB585B2D6B24AF",
        "resultado": "Bienvenido ROBERTO NAVARRO",
        "tipoPedido": "PV"
      }),
    )
        .then((value) {
      arrPedidos = json.decode(value.body);
      print(arrPedidos);
    });

    return arrPedidos;
  }

  Future<List<dynamic>> _datosClientes(int codigo) async {
    List<dynamic> auxArrCliente = await SQLHelper.traerCliente('2446055');

    return auxArrCliente;
  }

  @override
  void initState() {
    setearDatos();
    //getPedidosPolloVivo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Pedidos del Día: ${_fecha}'),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
            child:
                _listaReporte() /*ListView(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 - ANA RODRIGUEZ CAMPOS',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Total: 509.60 - Tipo : TRU-VT-GRV-POLLO VIVO',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Dir : asdaskdjhakdhakdhakdhkasdhakjhdkajhdkajdhkajsdhkajdhkasdhajkdhajsdhjkahdkjasdkjasdhkjasdhasjkdkashdasjkdh',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Sub Cliente: NAYSER',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2 - ANA RODRIGUEZ CAMPOS',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Total: 509.60 - Tipo : TRU-VT-GRV-POLLO VIVO',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Dir : asdaskdjhakdhakdhakdhkasdhakjhdkajhdkajdhkajsdhkajdhkasdhajkdhajsdhjkahdkjasdkjasdhkjasdhasjkdkashdasjkdh',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Sub Cliente: NAYSER',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                    )
                  ],
                ),
              ),
              Divider(),
            ],
          ),*/
            ),
      ),
    );
  }

  Widget _listaReporte() {
    return FutureBuilder(
      future: getPedidosPolloVivo(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ListView(
          children: _detalleReporte(snapshot.data ?? [], context),
        );
      },
    );
  }

  List<Widget> _detalleReporte(List<dynamic> data, BuildContext context) {
    final List<Widget> detalle = [];
    int indice = 0;
    data.forEach((element) {
      indice++;
      final widgetTemp = Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _datosCliente(int.parse(element['codigoCliente'])),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Total: 509.60 - Tipo : TRU-VT-GRV-POLLO VIVO',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Dir : asdaskdjhakdhakdhakdhkasdhakjhdkajhdkajdhkajsdhkajdhkasdhajkdhajsdhjkahdkjasdkjasdhkjasdhasjkdkashdasjkdh',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Sub Cliente: NAYSER',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0),
            )
          ],
        ),
      );

      detalle
        ..add(widgetTemp)
        ..add(Divider());
    });

    return detalle;
  }

  Widget _datosCliente(codigo) {
    return FutureBuilder(
      future: _datosClientes(2446055),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          '1 - ${snapshot.data[0]['nombre']}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        );
      },
    );
  }
}
