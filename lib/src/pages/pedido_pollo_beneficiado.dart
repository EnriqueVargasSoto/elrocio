import 'package:elrocio/src/pages/detalle_cliente.dart';
import 'package:elrocio/src/pages/finaliza_pedido.dart';
import 'package:elrocio/src/pages/productos_bene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:elrocio/src/services/cart.dart';
import 'package:geolocator/geolocator.dart';

class PedidoPolloBeneficiado extends StatefulWidget {
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
  PedidoPolloBeneficiado(
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
  State<PedidoPolloBeneficiado> createState() => _PedidoPolloBeneficiadoState();
}

class _PedidoPolloBeneficiadoState extends State<PedidoPolloBeneficiado> {
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
    //obtenerItems();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Pedido P.Beneficiado'),
            centerTitle: true,
            leading: _backButton(),
          ),
          body: _body(),
          bottomNavigationBar: _btnFloating()),
    );
  }

  Widget _backButton() {
    return BackButton(onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetalleCliente(widget.PKCliente,
                  widget.doc_cliente, widget.nombre, widget.saldopendiente)));
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
                              'Pesp P.',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0),
                            ),
                            Text(
                              '${element['factorConversionV']}',
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
                onPressed: (value) {
                  /*var ruta = MaterialPageRoute(builder: (context) => ProductosPage());
                                          Navigator.push(context, ruta);*/
                },
                backgroundColor: Color.fromRGBO(59, 145, 250, 1),
                foregroundColor: Colors.white,
                //icon: Icons.delete,
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
                  /*var ruta = MaterialPageRoute(builder: (context) => ProductosPage());
                                          Navigator.push(context, ruta);*/
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                //icon: Icons.delete,
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
              builder: (context) => ProductosDeneficiados(
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
        setState(() {
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
        });
      },
      tooltip: 'Increment Counter',
      child: const Icon(Icons.save),
    );
  }
}
