//import 'dart:convert';
//import 'dart:ffi';

import 'package:elrocio/sql_helper.dart';
import 'package:elrocio/src/pages/cobranzas.dart';
import 'package:elrocio/src/pages/pedido_pollo_beneficiado.dart';
import 'package:elrocio/src/pages/pedido_pollo_vivo.dart';
import 'package:elrocio/src/pages/pedidos.dart';
import 'package:elrocio/src/pages/saldo_cliente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

class DetalleCliente extends StatefulWidget {
  int PKCliente;
  String doc_cliente;
  String nombre;
  String saldopendiente;
  DetalleCliente(
      this.PKCliente, this.doc_cliente, this.nombre, this.saldopendiente,
      {Key? key})
      : super(key: key);
  //DetalleCliente({Key? key}) : super(key: key);

  @override
  State<DetalleCliente> createState() => _DetalleClienteState();
}

class _DetalleClienteState extends State<DetalleCliente> {
  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _textBtn = Colors.white;
  double _fontSize = 18.0;

  String user = 'u_wost';
  String pass = '\$w0st#sql+';

  DateTime _selectedDate = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();

  TextEditingController _codigo = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _documento = TextEditingController();
  TextEditingController _direccion = TextEditingController();
  TextEditingController _saldo = TextEditingController();
  TextEditingController _subcliente = TextEditingController();

  int iddireccionFacturacion = 0;
  String direccionFacturacion = '';
  int iddireccionEnvio = 0;
  String direccionEnvio = '';
  int idterminoPago = 0;
  String terminoPago = '';
  int idtipoPedido = 0;
  String tipoPedido = '';
  int idListaPrecio = 0;
  String listaPrecio = '';
  int idTerritorio = 0;
  String territorio = '';
  int vendedorid = 0;

  List<Map<String, dynamic>> _items = [];

  Future<void> setearVariables() async {
    _codigo.text = widget.PKCliente.toString();
    _nombre.text = widget.nombre.toString();
    _documento.text = widget.doc_cliente.toString();
    _saldo.text = widget.saldopendiente.toString();
  }

  Future<List<dynamic>> obtenerDirecciones() async {
    List<dynamic> arrDirecciones =
        await SQLHelper.buscaDireccion(widget.PKCliente);
    return arrDirecciones;
  }

  void selectDireccion(direccion) {
    iddireccionFacturacion = direccion['iddireccionFacturacion'];
    direccionFacturacion = direccion['direccionFacturacion'];
    iddireccionEnvio = direccion['iddireccionEnvio'];
    direccionEnvio = direccion['direccionEnvio'];
    idterminoPago = direccion['idterminoPago'];
    terminoPago = direccion['terminoPago'];
    idtipoPedido = direccion['idtipoPedido'];
    tipoPedido = direccion['tipoPedido'];
    idListaPrecio = direccion['idListaPrecio'];
    listaPrecio = direccion['listaPrecio'];
    idTerritorio = direccion['idTerritorio'];
    territorio = direccion['territorio'];
    vendedorid = direccion['vendedorid'];
    _direccion.text = direccion['direccionEnvio'];
  }

  @override
  void initState() {
    setearVariables();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Detalle de Cliente'),
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PedidoPage()));
              },
            ),
            actions: [
              GestureDetector(
                child: Icon(
                  Icons.cut_rounded,
                  size: 30.0,
                ),
                onTap: () {
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
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17.0)),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Text(
                                    'ATENCION : Se borrará la información de pedidos/cobranzas registradas para el cliente'),
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                        child: MaterialButton(
                                            color: _colorBtn,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: Text(
                                              'SI',
                                              style: TextStyle(color: _textBtn),
                                            ),
                                            onPressed: () async {
                                              Future.delayed(
                                                  Duration(seconds: 1), () {
                                                Navigator.pop(context);
                                              });
                                              //Navigator.pop(context);
                                              //_modalSincronizaTodo(context);
                                            })),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                        child: MaterialButton(
                                            //color: Colors.red[200],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: _colorBtn,
                                                    width: 2.0)),
                                            child: Text(
                                              'NO',
                                              style:
                                                  TextStyle(color: _colorBtn),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }))
                                  ],
                                )
                              ],
                            ));
                      });
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                child: Icon(
                  Icons.mode_edit,
                  size: 30.0,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaldoCliente(
                              widget.PKCliente,
                              widget.doc_cliente,
                              widget.nombre,
                              widget.saldopendiente)));
                },
              ),
              SizedBox(
                width: 20.0,
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
            child: _listViewBody(),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    var ruta = MaterialPageRoute(
                        builder: (context) => PedidoPolloVivo(
                            widget.PKCliente,
                            widget.nombre,
                            _direccion.text,
                            _textEditingController.text,
                            _selectedDate,
                            _subcliente.text,
                            iddireccionFacturacion,
                            direccionFacturacion,
                            iddireccionEnvio,
                            direccionEnvio,
                            idterminoPago,
                            terminoPago,
                            idtipoPedido,
                            tipoPedido,
                            idListaPrecio,
                            listaPrecio,
                            idTerritorio,
                            territorio,
                            vendedorid,
                            widget.doc_cliente,
                            widget.saldopendiente,
                            'PV'));
                    Navigator.push(context, ruta);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        //color: Color.fromRGBO(97, 0, 236, 1),
                        ),
                    height: 80.0,
                    child: Image(
                        image: AssetImage(
                          'assets/chicken.png',
                        ),
                        color: Color.fromRGBO(97, 0, 236, 1)),
                  ),
                )),
                //Expanded(child: new Text('')),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    var ruta = MaterialPageRoute(
                        builder: (context) => PedidoPolloBeneficiado(
                            widget.PKCliente,
                            widget.nombre,
                            _direccion.text,
                            _textEditingController.text,
                            _selectedDate,
                            _subcliente.text,
                            iddireccionFacturacion,
                            direccionFacturacion,
                            iddireccionEnvio,
                            direccionEnvio,
                            idterminoPago,
                            terminoPago,
                            idtipoPedido,
                            tipoPedido,
                            idListaPrecio,
                            listaPrecio,
                            idTerritorio,
                            territorio,
                            vendedorid,
                            widget.doc_cliente,
                            widget.saldopendiente,
                            'PB'));
                    Navigator.push(context, ruta);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        //color: Color.fromRGBO(97, 0, 236, 1),
                        ),
                    height: 80.0,
                    child: Image(
                        image: AssetImage('assets/roast_turkey.png'),
                        color: Color.fromRGBO(97, 0, 236, 1)),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    var ruta = MaterialPageRoute(
                        builder: (context) => CobranzasPage(
                            widget.PKCliente,
                            widget.nombre,
                            widget.doc_cliente,
                            widget.saldopendiente));
                    Navigator.push(context, ruta);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        //color: Color.fromRGBO(97, 0, 236, 1),
                        ),
                    height: 80.0,
                    child: Image(
                        image: AssetImage('assets/give_money.png'),
                        color: Color.fromRGBO(97, 0, 236, 1)),
                  ),
                )),
              ],
            ),
          )),
    );
  }

  Widget _listViewBody() {
    return ListView(
      children: [
        _inputCodigo(),
        _inputNombre(),
        _inputDocumento(),
        _inputSaldo(),
        _modalSelect(),
        _inputFecha(),
        _inputSubCliente()
      ],
    );
  }

  Widget _inputCodigo() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: TextField(
            controller: _codigo,
            enabled: false,
            decoration: new InputDecoration(labelText: 'Código'),
          ),
        )),
      ],
    );
  }

  Widget _inputNombre() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: TextField(
            controller: _nombre,
            enabled: false,
            decoration: new InputDecoration(labelText: 'Nombre'),
          ),
        )),
      ],
    );
  }

  Widget _inputDocumento() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: TextField(
            controller: _documento,
            enabled: false,
            decoration: new InputDecoration(labelText: 'DNI/RUC'),
          ),
        )),
      ],
    );
  }

  Widget _inputSaldo() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: TextField(
            controller: _saldo,
            enabled: false,
            decoration: new InputDecoration(labelText: 'Saldo'),
          ),
        )),
      ],
    );
  }

  Widget _modalSelect() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: GestureDetector(
            child: TextField(
              enabled: false,
              controller: _direccion,
              decoration: new InputDecoration(labelText: 'Direccion'),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      scrollable: true,
                      title: Text('Direcciones'),
                      content: _contentDirecciones(),
                    );
                  });
            },
          ),
        ))
      ],
    );
  }

  Widget _contentDirecciones() {
    return FutureBuilder(
      future: obtenerDirecciones(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: Column(
            children: _listarDirecciones(snapshot.data ?? [], context),
          ),
        );
      },
    );
  }

  List<Widget> _listarDirecciones(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    data.forEach((element) {
      final widgetTemp = GestureDetector(
        child: Html(data: element['direccionEnvio']),
        onTap: () {
          selectDireccion(element);
          Navigator.pop(context);
        },
      );

      opciones
        ..add(widgetTemp)
        ..add(Divider());
    });

    return opciones;
  }

  Widget _inputFecha() {
    return Row(
      children: [
        Expanded(
            child: Center(
                child: GestureDetector(
          child: TextField(
            decoration: new InputDecoration(labelText: 'Fecha'),
            controller: _textEditingController,
            enabled: false,
            //onTap: () {},
          ),
          onTap: () {
            showDatePicker(
              locale: const Locale("es", "ES"),
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            ).then((pickedDate) {
              String languageCode =
                  Localizations.localeOf(context).languageCode;
              _selectedDate = pickedDate!;
              final f = new DateFormat('yyyy-MM-dd hh:mm');
              //String formattedDate = DateFormat.yMMMd().format(pickedDate);
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
              print(' este es el formato : ${formattedDate}');

              _textEditingController.text = formattedDate;
              //DateFormat.yMMMMd(languageCode).format(pickedDate);
            });
          },
        ))),
      ],
    );
  }

  Widget _inputSubCliente() {
    return Row(
      children: [
        Expanded(
            child: Center(
          child: TextField(
            decoration: new InputDecoration(labelText: 'Sub Cliente'),
            onChanged: (val) {
              setState(() {
                _subcliente.text = val;
              });
            },
          ),
        )),
      ],
    );
  }
}
