import 'package:elrocio/sql_helper.dart';
import 'package:flutter/material.dart';

class Envios extends StatefulWidget {
  Envios({Key? key}) : super(key: key);

  @override
  State<Envios> createState() => _EnviosState();
}

class _EnviosState extends State<Envios> {
  int cantPedidos = 0;
  Future<List<dynamic>> pedidosPendiente() async {
    List<dynamic> arrPedidosPendientes = await SQLHelper.pedidosPendientes();
    cantPedidos = arrPedidosPendientes.length;
    return arrPedidosPendientes;
  }

  Future<List<dynamic>> totales() async {
    List<dynamic> arrPedidosPendientes = await SQLHelper.pedidosPendientes();
    cantPedidos = arrPedidosPendientes.length;
    return arrPedidosPendientes;
  }

  @override
  void initState() {
    pedidosPendiente();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Envios Pendientes'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
          child: Column(
            children: [
              Divider(),
              _cantidadPedidos(),
              Divider(),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0),
                  width: double.infinity,
                  //color: Colors.blue,
                  child: Text(
                    'Cobranzas (0)',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0),
                  ),
                ),
                onTap: () {
                  print('azul');
                },
              ),
              Divider(),
              _cantidadTotal(),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cantidadPedidos() {
    return FutureBuilder(
      future: pedidosPendiente(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0),
            width: double.infinity,
            //color: Colors.blue,
            child: Text(
              'Pedidos (${snapshot.data?.length})',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0),
            ),
          ),
          onTap: () {
            print('azul');
            snapshot.data?.forEach((element) async {
              List<dynamic> arrDetalle =
                  await SQLHelper.getDetalles(element['_id']);
              ;

              var arreglo = {
                '_id': element['_id'],
                'codigoServidor': element['codigoServidor'],
                'fechaPedido': element['fechaPedido'],
                'fechaPedidoStr':
                    element['fechaPedidoStr'], //widget.fechaDate.toString(),
                'codigoCliente': element['codigoCliente'],
                'subcliente': element['subcliente'],
                'idTipoPedido': element['idTipoPedido'],
                'descTipoPedido': element['descTipoPedido'],
                'tipoPedido': element['tipoPedido'],
                'idListaPrecio': element['idListaPrecio'],
                'idFormaPago': element['idFormaPago'],
                'ordenCompra': '',
                'idAlmacenVenta': element['idAlmacenVenta'],
                'idDireccionEnvio': element['idDireccionEnvio'],
                'direccionEnvio': element['direccionEnvio'],
                'idDireccionFacturacion': element['idDireccionFacturacion'],
                'direccionFacturacion': element['direccionFacturacion'],
                'idEmpresa': '82',
                'montoTotal': element['montoTotal'],
                'codigoUsuario': element['codigoUsuario'],
                'latitud': "-12.0884319",
                'longitud': "-76.9730607",
                'celdaGPS': "G",
                'prioridad': element['prioridad'],
                'estadoPedido': element['estadoPedido'],
                'lstPedidoDetalle': arrDetalle //element['lstPedidoDetalle']
              };

              print(arreglo);
            });
          },
        );
      },
    );
  }

  Widget _cantidadTotal() {
    return FutureBuilder(
      future: pedidosPendiente(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0),
            width: double.infinity,
            //color: Colors.blue,
            child: Text(
              'Todo (${snapshot.data?.length})',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0),
            ),
          ),
          onTap: () {
            print('azul');
          },
        );
      },
    );
  }
}
