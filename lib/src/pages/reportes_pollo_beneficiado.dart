import 'dart:convert';

import 'package:elrocio/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportesPolloBeneficiado extends StatefulWidget {
  ReportesPolloBeneficiado({Key? key}) : super(key: key);

  @override
  State<ReportesPolloBeneficiado> createState() =>
      _ReportesPolloBeneficiadoState();
}

class _ReportesPolloBeneficiadoState extends State<ReportesPolloBeneficiado> {
  DateTime _selectedDate = DateTime.now();
  String _fecha = '';
  String _fechaEnvio = '';
  String url =
      "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_ListarPedidos.ashx";

  void setearDatos() {
    _fecha = DateFormat('dd/MM/yyyy').format(_selectedDate);
    _fechaEnvio = DateFormat('yyyy-dd-MM').format(_selectedDate);
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
        "codigo": pref.getString('codigo').toString(),
        "compania": pref.getString('compania').toString(),
        "fechaCaja": _fechaEnvio,
        "idCaja": pref.getString('idCaja').toString(),
        "idOEBS": pref.getString('codigo').toString(),
        "idResultado": "1",
        "login": pref.getString('login').toString(),
        "nombres": pref.getString('nombres').toString(),
        "nroSerie": pref.getString('nroSerie').toString(),
        "password": pref.getString('password').toString(),
        "resultado": pref.getString('resultado').toString(),
        "tipoPedido": "PB"
      }),
    )
        .then((value) {
      arrPedidos = json.decode(value.body);
    });

    return arrPedidos;
  }

  Future<String> _datosClientes(String codigo) async {
    List<dynamic> auxArrCliente = await SQLHelper.traerCliente(codigo);
    Map<String, dynamic> auxAux = auxArrCliente.first;

    String _aucNombre = auxAux['nombre'];
    return _aucNombre;
  }

  Future<String> _obtenerTipo(idTipoPedido) async {
    List<dynamic> arrTipos = await SQLHelper.buscarGeneral(idTipoPedido);
    Map<String, dynamic> auxAux = arrTipos.first;
    String tipo = auxAux['nombre'];
    return tipo;
  }

  Future<String> jajajaja(idDireccion) async {
    List<dynamic> arrDireccion =
        await SQLHelper.detalleDireccion(int.parse(idDireccion));
    Map<String, dynamic> auxAux = arrDireccion.first;
    String direccion = auxAux['direccionEnvio'];
    return direccion;
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
          child: _listaReporte(),
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
      double monto = 0.0;
      indice++;
      List<dynamic> arrDetalle = element['lstPedidoDetalle'];

      arrDetalle.forEach((element) {
        monto += double.parse(element['monto']);
      });

      final widgetTemp = Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _datosCliente(element['codigoCliente'], indice),
            SizedBox(
              height: 10.0,
            ),
            _tipo(element['idTipoPedido'], monto),
            SizedBox(
              height: 5.0,
            ),
            _direccionWidget(element['idDireccionEnvio']),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Sub Cliente: ${element['subcliente']}',
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

  Widget _datosCliente(String codigo, int indice) {
    return FutureBuilder(
      future: _datosClientes(codigo),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          '${indice} - ${snapshot.data}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        );
      },
    );
  }

  Widget _tipo(idTipo, monto) {
    return FutureBuilder(
      future: _obtenerTipo(idTipo),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          'Total: ${monto} - Tipo : ${snapshot.data}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15.0),
        );
      },
    );
  }

  Widget _direccionWidget(idDireccion) {
    return FutureBuilder(
      future: jajajaja(idDireccion),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print('la data es : ${snapshot.data}');
        return Text(
          'Dir : ${snapshot.data}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15.0),
        );
      },
    );
  }
}
