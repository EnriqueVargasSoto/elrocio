import 'package:elrocio/src/pages/detalle_cliente.dart';
import 'package:elrocio/src/pages/finaliza_pedido.dart';
import 'package:elrocio/src/pages/productos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:elrocio/src/services/cart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PedidoPolloVivo extends StatefulWidget {
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
  PedidoPolloVivo(
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
  State<PedidoPolloVivo> createState() => _PedidoPolloVivoState();
}

class _PedidoPolloVivoState extends State<PedidoPolloVivo> {
  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _textBtn = Colors.white;
  int cantItems = 0; //cart.getCartItemCount();
  double total = 0.0;

  Future<String> obtenerCantidad() async {
    String cantidadcitaItems = await Cart.obtenerCantidad();
    return cantidadcitaItems;
  }

  Future<String> obtenerTotal() async {
    String totalCarrito = await Cart.getTotal();
    return totalCarrito;
  }

  Future<List<dynamic>> getCarrito() async {
    List<dynamic> carrito = await Cart.getProductos();
    return carrito;
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color.fromRGBO(97, 0, 236, 1),
              title: Text('Pedido P.Vivo'),
              centerTitle: true,
              leading: _backButton()),
          body: _body(),
          bottomNavigationBar: _btnFloating()),
    );
  }

  Widget _backButton() {
    return BackButton(onPressed: () {
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
                                fontWeight: FontWeight.w400, fontSize: 17.0)),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Perderá los datos del pedido. '),
                  Text('¿Está seguro que desea regresar?'),
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
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetalleCliente(
                                            widget.PKCliente,
                                            widget.doc_cliente,
                                            widget.nombre,
                                            widget.saldopendiente)));
                              })),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                          child: MaterialButton(
                              //color: Colors.red[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side:
                                      BorderSide(color: _colorBtn, width: 2.0)),
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
              ),
            );
          });
      /*Cart.vaciarCarrito();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetalleCliente(widget.PKCliente,
                  widget.doc_cliente, widget.nombre, widget.saldopendiente)));*/
    });
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
      child: ListView(
        children: [
          _nombres(),
          _division(),
          _tipoPedido(),
          _division(),
          _testItems(),
          _division(),
          _precioso(),
          _division(),
          _listaCart()
        ],
      ),
    );
  }

  Widget _division() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _nombres() {
    return Text(
      'Cliente : ${widget.nombre}',
      style: TextStyle(fontSize: 25.0),
    );
  }

  Widget _tipoPedido() {
    return Text(
      'Tipo Ped : ${widget.tipoPedido}',
      style: TextStyle(fontSize: 25.0),
    );
  }

  Widget _listaCart() {
    return Container(
      height: 500.0,
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: _listado(),
    );
  }

  Widget _testItems() {
    return FutureBuilder(
        future: obtenerCantidad(),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Text(
            'Items : ${snapshot.data}',
            style: TextStyle(fontSize: 25.0),
          );
        });
  }

  Widget _precioso() {
    return FutureBuilder(
        future: obtenerTotal(),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          print(snapshot.data);
          return Text(
            'Total : S/ ${snapshot.data}',
            style: TextStyle(fontSize: 25.0),
          );
        });
  }

  Widget _listado() {
    return FutureBuilder(
        future: getCarrito(),
        initialData: [],
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          print(snapshot.data);
          return ListView(
            children: _listarItems(snapshot.data ?? [], context),
          );
        });
  }

  List<Widget> _listarItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    data.forEach((element) {
      final widgetTemp = Slidable(
          key: const ValueKey(0),
          child: GestureDetector(
              child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        '${element['codigoEBS']} - ${element['nombreArticulo']}',
                        style: TextStyle(),
                        //overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Jabas',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0),
                            ),
                            Text(
                              '${element['cantidadJabas']} (${element['cantidadUNDXJaba']} P/Jab)',
                              style: TextStyle(fontSize: 15.0),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Cant.',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0),
                            ),
                            Text('${element['cantidadUND']}',
                                style: TextStyle(fontSize: 15.0))
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Kilos',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0),
                            ),
                            Text('${element['cantidadKGS']}',
                                style: TextStyle(fontSize: 15.0))
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0),
                            ),
                            Text('${element['monto']}',
                                style: TextStyle(fontSize: 15.0))
                          ],
                        ),
                      )
                    ]),
              ],
            ),
          )),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (value) {},
                backgroundColor: Color.fromRGBO(59, 145, 250, 1),
                foregroundColor: Colors.white,
                label: 'Editar',
              ),
              SlidableAction(
                onPressed: (value) {
                  Cart.eliminarProducto(int.parse(element['codigo']));
                  setState(() {
                    _testItems();
                    _precioso();
                    _listado();
                  });
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Eliminar',
              ),
            ],
          ));
      opciones
        ..add(widgetTemp)
        ..add(Divider());
    });
    return opciones;
  }

  Widget _btnFloating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _btnGuardar(),
        SizedBox(
          width: 10.0,
        ),
        _btnAgregar(),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget _btnAgregar() {
    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(97, 0, 236, 1),
      onPressed: () {
        setState(() {
          var ruta = MaterialPageRoute(
              builder: (context) => Productos(
                  widget.PKCliente,
                  widget.nombre,
                  widget.direccion,
                  widget.fechaTexto,
                  widget.fechaDate,
                  widget.subcliente,
                  widget.iddireccionFacturacion,
                  widget.direccionFacturacion,
                  widget.iddireccionEnvio,
                  widget.direccionEnvio,
                  widget.idterminoPago,
                  widget.terminoPago,
                  widget.idtipoPedido,
                  widget.tipoPedido,
                  widget.idListaPrecio,
                  widget.listaPrecio,
                  widget.idTerritorio,
                  widget.territorio,
                  widget.vendedorid,
                  widget.doc_cliente,
                  widget.saldopendiente));
          Navigator.push(context, ruta);
        });
      },
      tooltip: 'Increment Counter',
      child: const Icon(Icons.add),
    );
  }

  Widget _btnGuardar() {
    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(97, 0, 236, 1),
      onPressed: () {
        setState(() async {
          List<dynamic> auxArr = await getCarrito();
          print(auxArr.length);
          print(auxArr.length > 0);
          if (auxArr.length > 0) {
            var ruta = MaterialPageRoute(
                builder: (context) => FinalizaPedido(
                    widget.PKCliente,
                    widget.nombre,
                    widget.direccion,
                    widget.fechaTexto,
                    widget.fechaDate,
                    widget.subcliente,
                    widget.iddireccionFacturacion,
                    widget.direccionFacturacion,
                    widget.iddireccionEnvio,
                    widget.direccionEnvio,
                    widget.idterminoPago,
                    widget.terminoPago,
                    widget.idtipoPedido,
                    widget.tipoPedido,
                    widget.idListaPrecio,
                    widget.listaPrecio,
                    widget.idTerritorio,
                    widget.territorio,
                    widget.vendedorid,
                    widget.doc_cliente,
                    widget.saldopendiente,
                    widget.siglas));
            Navigator.push(context, ruta);
          } else {
            Fluttertoast.showToast(
              msg: 'Su carrito esta vacío',
              //toastLength: Toast.LENGTH_SHORT,
              //gravity: ToastGravity.BOTTOM,
              //timeInSecForIos: 1,
              //backgroundColor: Colors.red,
              /*textColor: Colors.yellow*/
            );
          }
        });
      },
      tooltip: 'Increment Counter',
      child: const Icon(Icons.save),
    );
  }
}
