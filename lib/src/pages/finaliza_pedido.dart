import 'dart:io';
import 'dart:convert';
import 'package:elrocio/sql_helper.dart';
import 'package:elrocio/src/pages/detalle_cliente.dart';
import 'package:elrocio/src/services/cart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class FinalizaPedido extends StatefulWidget {
  int PKCliente;
  String nombre;
  String direccion;
  String fechaTexto;
  DateTime fechaDate;
  String subcliente;
  int iddireccionFacturacion;
  String direccionFacturacion;
  int iddireccionEnvio;
  String direccionEnvio;
  int idterminoPago;
  String terminoPago;
  int idtipoPedido;
  String tipoPedido;
  int idListaPrecio;
  String listaPrecio;
  int idTerritorio;
  String territorio;
  int vendedorid;
  String doc_cliente;
  String saldopendiente;
  String siglas;
  FinalizaPedido(
      this.PKCliente,
      this.nombre,
      this.direccion,
      this.fechaTexto,
      this.fechaDate,
      this.subcliente,
      this.iddireccionFacturacion,
      this.direccionFacturacion,
      this.iddireccionEnvio,
      this.direccionEnvio,
      this.idterminoPago,
      this.terminoPago,
      this.idtipoPedido,
      this.tipoPedido,
      this.idListaPrecio,
      this.listaPrecio,
      this.idTerritorio,
      this.territorio,
      this.vendedorid,
      this.doc_cliente,
      this.saldopendiente,
      this.siglas,
      {Key? key})
      : super(key: key);

  @override
  State<FinalizaPedido> createState() => _FinalizaPedidoState();
}

class _FinalizaPedidoState extends State<FinalizaPedido> {
  final TextEditingController prioridad = TextEditingController();

  var idOEBS;
  var codigo;
  var nombres;
  var nroSerie;
  int numeroItems = 0;
  String subtotalito = '';
  String igvText = '';
  String totalText = '';

  String atributo1 = '';
  String atributo2 = '';
  String url =
      "https://qas-avicolas.rocio.com.pe/rocio-comercial/handlers/SC_CrearPedidoUnit.ashx";

  Future<String> obtenerCantidad() async {
    String cantidadcitaItems = await Cart.obtenerCantidad();
    numeroItems = int.parse(cantidadcitaItems);
    return cantidadcitaItems;
  }

  Future<String> obtenerTotal() async {
    String totalCarrito = await Cart.getTotal();
    print('total');
    print(totalCarrito);
    totalText = totalCarrito;
    return totalCarrito;
  }

  Future setearData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      idOEBS = pref.getString('idOEBS');
      idOEBS = int.parse(idOEBS);
      codigo = pref.getString('codigo');
      codigo = int.parse(codigo);
      nombres = pref.getString('nombres');
      nroSerie = pref.getString('nroSerie');
    });

    List<dynamic> arrGeneral =
        await SQLHelper.buscarGeneral(widget.idtipoPedido);
    atributo1 = arrGeneral[0]['atributo1'];
    atributo2 = arrGeneral[0]['atributo2'];
  }

  Future<String> obtenerSubtotal() async {
    String subtotal = await Cart.getSubtotal();
    return subtotal;
  }

  Future<String> obtenerIgv() async {
    String igv = await Cart.getIgv();
    return igv;
  }

  void guardarPedido() async {
    int indice = 0;
    List<dynamic> carrito = await Cart.getProductos();
    List<dynamic> auxDetalle = [];

    for (var element in carrito) {
      var auxArreglo = {
        'idPedidoDetalle': indice,
        'codigoArticulo': element['codigoArticulo'],
        'codigoEBS': element['codigoEBS'],
        'idTipoLinea': element['idTipoLinea'],
        'nombreArticulo': element['nombreArticulo'],
        'cantidadKGS': element['cantidadKGS'],
        'cantidadUND': element['cantidadUND'],
        'cantidadUNDXJaba': element['cantidadUNDXJaba'],
        'cantidadJabas': element['cantidadJabas'],
        'factorConversion': element['factorConversion'],
        'precioUnitario': element['precioUnitario'],
        'factorConversionV': element['factorConversionV'],
        'precioUnitarioV': element['precioUnitarioV'],
        'monto': element['monto'],
        'comentario': element['comentario'],
        'rango_minimo': element['rango_minimo'],
        'rango_maximo': element['rango_maximo']
      };
      auxDetalle.add(auxArreglo);
      indice++;
    }

    var arreglo = {
      '_id': "1",
      'codigoServidor': "",
      'fechaPedido': 0,
      'fechaPedidoStr': widget.fechaTexto, //widget.fechaDate.toString(),
      'codigoCliente': widget.PKCliente,
      'subcliente': widget.subcliente,
      'idTipoPedido': widget.idtipoPedido,
      'descTipoPedido': widget.tipoPedido,
      'tipoPedido': widget.siglas,
      'idListaPrecio': widget.idListaPrecio,
      'idFormaPago': widget.idterminoPago,
      'ordenCompra': '',
      'idAlmacenVenta': atributo1,
      'idDireccionEnvio': widget.iddireccionEnvio,
      'direccionEnvio': widget.direccionEnvio,
      'idDireccionFacturacion': widget.iddireccionFacturacion,
      'direccionFacturacion': widget.direccionFacturacion,
      'idEmpresa': '82',
      'montoTotal': totalText,
      'codigoUsuario': codigo.toString(),
      'latitud': "-12.0884319",
      'longitud': "-76.9730607",
      'celdaGPS': "G",
      'prioridad': prioridad.text,
      'estadoPedido': -1,
      'lstPedidoDetalle': auxDetalle
    };

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await http
            .post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(arreglo),
        )
            .then((value) async {
          String resp = value.body;
          var primerValor = resp.split(";");
          String valorResp = primerValor[0].replaceAll('"', '');
          String nuevoCodigoServidor = primerValor[1].replaceAll('"', '');

          int idPedido = await SQLHelper.insertarPedido(
              nuevoCodigoServidor,
              0,
              widget.fechaTexto,
              widget.PKCliente.toString(),
              widget.subcliente,
              widget.idtipoPedido.toString(),
              widget.tipoPedido,
              widget.siglas,
              widget.idListaPrecio.toString(),
              widget.idterminoPago.toString(),
              '',
              atributo1,
              widget.iddireccionEnvio.toString(),
              widget.direccionEnvio,
              widget.iddireccionFacturacion.toString(),
              widget.direccionFacturacion,
              '82',
              totalText,
              codigo.toString(),
              "-12.0884319",
              "-76.9730607",
              "G",
              prioridad.text,
              valorResp);

          carrito.forEach((element) async {
            await SQLHelper.agregarDetallePedido(
                idPedido,
                element['codigoArticulo'].toString(),
                element['codigoEBS'].toString(),
                element['idTipoLinea'].toString(),
                element['nombreArticulo'].toString(),
                element['cantidadKGS'].toString(),
                element['cantidadUND'].toString(),
                element['cantidadUNDXJaba'].toString(),
                element['cantidadJabas'].toString(),
                element['factorConversion'].toString(),
                element['precioUnitario'].toString(),
                element['factorConversionV'].toString(),
                element['precioUnitarioV'].toString(),
                element['monto'].toString(),
                element['comentario'].toString(),
                element['rango_minimo'].toString(),
                element['rango_maximo'].toString());
          });
        });
      }
    } on SocketException catch (e) {
      int idPedido = await SQLHelper.insertarPedido(
          '',
          0,
          widget.fechaTexto,
          widget.PKCliente.toString(),
          widget.subcliente,
          widget.idtipoPedido.toString(),
          widget.tipoPedido,
          widget.siglas,
          widget.idListaPrecio.toString(),
          widget.idterminoPago.toString(),
          '',
          atributo1,
          widget.iddireccionEnvio.toString(),
          widget.direccionEnvio,
          widget.iddireccionFacturacion.toString(),
          widget.direccionFacturacion,
          '82',
          totalText,
          codigo.toString(),
          "-12.0884319",
          "-76.9730607",
          "G",
          prioridad.text,
          '-1');

      carrito.forEach((element) async {
        await SQLHelper.agregarDetallePedido(
            idPedido,
            element['codigoArticulo'].toString(),
            element['codigoEBS'].toString(),
            element['idTipoLinea'].toString(),
            element['nombreArticulo'].toString(),
            element['cantidadKGS'].toString(),
            element['cantidadUND'].toString(),
            element['cantidadUNDXJaba'].toString(),
            element['cantidadJabas'].toString(),
            element['factorConversion'].toString(),
            element['precioUnitario'].toString(),
            element['factorConversionV'].toString(),
            element['precioUnitarioV'].toString(),
            element['monto'].toString(),
            element['comentario'].toString(),
            element['rango_minimo'].toString(),
            element['rango_maximo'].toString());
      });
    }

    Cart.vaciarCarrito();
  }

  void pruebaConxion() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        print(result);
      }
    } on SocketException catch (e) {
      print('not connected');
      print(e);
    }
  }

  @override
  void initState() {
    setearData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(97, 0, 236, 1),
        title: Text('Finalizar Pedido'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 25, right: 25.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                '¿Está seguro de finalizar el pedido?',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                '${widget.nombre}',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            /*Container(
              alignment: Alignment.topLeft,
              child: Text(
                '${widget.direccionEnvio}',
                style: TextStyle(fontSize: 17.0),
              ),
            ),*/
            Container(
              alignment: Alignment.topLeft,
              child: Html(data: widget.direccionEnvio),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      children: [
                        TextSpan(text: 'RUC Cliente : '),
                        TextSpan(
                            text: '${widget.doc_cliente}',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      children: [
                        TextSpan(text: 'Sub. Cliente : '),
                        TextSpan(
                            text: '${widget.subcliente}',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                )),
            SizedBox(
              height: 15.0,
            ),
            Container(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 17.0, color: Colors.black),
                      children: [
                        TextSpan(text: 'Fecha Pedido : '),
                        TextSpan(
                            text: '${widget.fechaTexto}',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                )),
            SizedBox(
              height: 15.0,
            ),
            _testItems(),
            SizedBox(
              height: 15.0,
            ),
            _subtotal(),
            SizedBox(
              height: 15.0,
            ),
            _igv(),
            SizedBox(
              height: 15.0,
            ),
            _precioso(),
            SizedBox(
              height: 15.0,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(
                    'Prioridad Ped : ',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  Flexible(
                    child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: prioridad,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          isDense: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 40.0,
              width: double.infinity,
              child: MaterialButton(
                  color: Color.fromRGBO(97, 0, 236, 1),
                  child: Text(
                    'GUARDAR',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            scrollable: true,
                            title: Text('¿Está seguro de guardar el pedido?'),
                            content: Container(
                                child: SizedBox(
                              height: 20.0,
                            )),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    //var respuestita = guardarPedidoTemporal();
                                    //pruebaConxion();
                                    guardarPedido();

                                    var ruta = MaterialPageRoute(
                                        builder: (context) => DetalleCliente(
                                            widget.PKCliente,
                                            widget.doc_cliente,
                                            widget.nombre,
                                            widget.saldopendiente));
                                    Navigator.push(context, ruta);
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ))
                            ],
                          );
                        });

                    /*setState(() {
                      
                    });*/
                    //buscar(tipo, texto.text);
                    /*var ruta = MaterialPageRoute(builder: (context) => PedidoPage());
                      Navigator.push(context, ruta);*/
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testItems() {
    return FutureBuilder(
        future: obtenerCantidad(),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Container(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 17.0, color: Colors.black),
                    children: [
                      TextSpan(text: '# Items : '),
                      TextSpan(
                          text: '${snapshot.data}',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ));
        });
  }

  Widget _precioso() {
    return FutureBuilder(
        future: obtenerTotal(),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          print(snapshot.data);
          return Container(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 17.0, color: Colors.black),
                    children: [
                      TextSpan(text: 'Total (S/.) : '),
                      TextSpan(
                          text: '${snapshot.data}',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ));
        });
  }

  Widget _subtotal() {
    return FutureBuilder(
        future: obtenerSubtotal(),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Container(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 17.0, color: Colors.black),
                    children: [
                      TextSpan(text: 'Sub Total (S/.) : '),
                      TextSpan(
                          text: '${snapshot.data}',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ));
        });
  }

  Widget _igv() {
    return FutureBuilder(
        future: obtenerIgv(),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Container(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 17.0, color: Colors.black),
                    children: [
                      TextSpan(text: 'IGV (S/.) : '),
                      TextSpan(
                          text: '${snapshot.data}',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ));
        });
  }
}
