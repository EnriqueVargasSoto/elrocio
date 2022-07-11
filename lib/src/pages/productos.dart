import 'package:elrocio/src/pages/pedido_pollo_vivo.dart';
import 'package:elrocio/src/services/cart.dart';
import 'package:flutter/material.dart';
import 'package:elrocio/sql_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Productos extends StatefulWidget {
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
  Productos(
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
      {Key? key})
      : super(key: key);

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  SingingCharacter? _character = SingingCharacter.nombre;

  final TextEditingController texto = TextEditingController();

  final TextEditingController factorConversion = TextEditingController();
  final TextEditingController precioUnit = TextEditingController();
  final TextEditingController kilosVendidos = TextEditingController();
  final TextEditingController numeroJabas = TextEditingController();
  final TextEditingController unidadesJaba = TextEditingController();
  final TextEditingController cantPollos = TextEditingController();
  final TextEditingController total = TextEditingController();

  double valorInicial = 0.0;
  double valorFinal = 0.0;
  double valorIgv = 0.0;

  String tipo = 'nombre';

  TextInputType tipoText = TextInputType.text;

  String atributo1 = '';
  String atributo2 = '';

  int rptaPrecio = 0;

  Future<List<dynamic>> getProductos(String consulta) async {
    List<dynamic> arrProductos =
        await SQLHelper.busquedaProducto(tipo, consulta);
    return arrProductos;
  }

  Future<String> obtenerPrimerPrecio(int id, int codCliente) async {
    List<dynamic> _primerPrecio = await SQLHelper.pimerPrecio(id, codCliente);
    if (_primerPrecio.length > 0) {
      rptaPrecio = 1;
      return _primerPrecio[0]['precioProducto'];
    } else {
      rptaPrecio = 0;
      return 'Sin Precio';
    }
  }

  Future<String> obtenerIgv() async {
    List<dynamic> respuestaBDIgv = await SQLHelper.igv();
    if (respuestaBDIgv.length > 0) {
      return respuestaBDIgv[0]['s_param_valor'];
    } else {
      return '0.0';
    }
  }

  Future<List<dynamic>> getPrecios(int idProducto) async {
    List<dynamic> resPrecios = await SQLHelper.buscarPrecios(idProducto);
    return resPrecios;
  }

  Future<void> inicalizamosVariables(producto) async {
    numeroJabas.text = '';
    factorConversion.text = producto['factorConversion'];
    String stringPrecioSinIgv =
        await obtenerPrimerPrecio(producto['codigo'], widget.idListaPrecio);

    valorInicial = double.parse(stringPrecioSinIgv);
    String stringValorIgv = await obtenerIgv();
    valorIgv = double.parse(stringValorIgv);

    if (producto['N_PRODUCTO_AFECTO_IGV'] == 1) {
      valorFinal = valorInicial * (1 + valorIgv);
      precioUnit.text = valorFinal.toStringAsFixed(2);
    } else {
      valorFinal = valorInicial;
      precioUnit.text = valorFinal.toStringAsFixed(2);
    }

    kilosVendidos.text = '0.0';
    unidadesJaba.text = producto['pollosxjaba'].toString();
    cantPollos.text = '0';
    total.text = '0.0';

    List<dynamic> arrGeneral =
        await SQLHelper.buscarGeneral(widget.idtipoPedido);
    atributo1 = arrGeneral[0]['atributo1'];
    atributo2 = arrGeneral[0]['atributo2'];
  }

  @override
  void initState() {}

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Productos'),
          centerTitle: true,
          leading: _backButton(),
        ),
        body: _body(),
      ),
    );
  }

  Widget _backButton() {
    return BackButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PedidoPolloVivo(
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
                  'PV')),
        );
      },
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
      child: ListView(
        children: [
          _radioButton(),
          _inputText(),
          _btnBuscar(),
          _listaProductos()
        ],
      ),
    );
  }

  Widget _radioButton() {
    return Row(
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
                      tipoText = TextInputType.text;
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
                      tipoText = TextInputType.phone;
                    });
                  }),
              Expanded(child: Text('Por Codigo'))
            ],
          ),
          flex: 1,
        ),
      ],
    );
  }

  Widget _listaProductos() {
    return Container(
        margin: EdgeInsets.only(top: 30.0), height: 500.0, child: _listar());
  }

  Widget _inputText() {
    return Row(
      children: [
        Expanded(
            child: Center(
                child: TextField(
          keyboardType: tipoText,
          controller: texto,
          decoration:
              new InputDecoration(labelText: 'Ingrese aquí el texto a buscar'),
        )))
      ],
    );
  }

  Widget _btnBuscar() {
    return Container(
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
          }),
    );
  }

  Widget _listar() {
    var param = texto.text;
    String consulta = '';
    if (param != null && param != '') {
      consulta = '%$param%';

      return FutureBuilder(
          future: getProductos(consulta),
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
    String letra = '';

    data.forEach((element) {
      final widgetTemp = Container(
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            String condicion = await obtenerPrimerPrecio(
                element['codigo'], widget.idListaPrecio);
            if (condicion == 'Sin Precio') {
              Fluttertoast.showToast(
                msg:
                    'El artículo no tiene modificador ni lista de precio asignada',
                //toastLength: Toast.LENGTH_SHORT,
                //gravity: ToastGravity.BOTTOM,
                //timeInSecForIos: 1,
                //backgroundColor: Colors.red,
                /*textColor: Colors.yellow*/
              );
            } else {
              inicalizamosVariables(element);

              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        //alignment: Alignment.center,
                        actionsAlignment: MainAxisAlignment.center,
                        scrollable: true,
                        title: Text(
                            '${element['codigoOEBS']} - ${element['nombreProducto']}'),
                        content: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Factor de Conversión : '),
                                  Flexible(
                                    child: TextField(
                                        keyboardType: TextInputType.phone,
                                        controller: factorConversion,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
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
                              SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Text('Precio Unit(Kg) : '),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                          enabled: false,
                                          controller: precioUnit,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          decoration: new InputDecoration(
                                            contentPadding: EdgeInsets.all(5.0),
                                            isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                          )),
                                    ],
                                  )),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Text('Kg. Vendidos : '),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                          enabled: false,
                                          controller: kilosVendidos,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          decoration: new InputDecoration(
                                            contentPadding: EdgeInsets.all(5.0),
                                            isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Text('N° Jabas : '),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                        controller: numeroJabas,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.phone,
                                        maxLines: 1,
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                        ),
                                        onChanged: (texto) {
                                          setState(() {
                                            //obtengo el numero de pollod
                                            var pollitos = int.parse(
                                                    numeroJabas.text) *
                                                int.parse(unidadesJaba.text);
                                            cantPollos.text =
                                                pollitos.toString();
                                            print(
                                                'cantidad de pollos ${pollitos}');
                                            //obtenemos los kilos totales
                                            var kilitos = pollitos *
                                                double.parse(
                                                    factorConversion.text);
                                            print(
                                                'cantidad de pollos ${kilitos}');
                                            kilosVendidos.text = kilitos
                                                .toStringAsFixed(2)
                                                .toString();
                                            print(
                                                'cantidad de pollos ${kilosVendidos.text}');
                                            var totalcito =
                                                double.parse(precioUnit.text) *
                                                    kilitos;
                                            print(
                                                'cantidad de pollos ${totalcito}');
                                            total.text =
                                                totalcito.toStringAsFixed(2);
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Text('Und. x Jab. : '),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                        controller: unidadesJaba,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.phone,
                                        maxLines: 1,
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.0),
                                          ),
                                        ),
                                        onChanged: (texto) {
                                          setState(() {
                                            //obtengo el numero de pollod
                                            var pollitos = int.parse(
                                                    numeroJabas.text) *
                                                int.parse(unidadesJaba.text);
                                            cantPollos.text =
                                                pollitos.toString();
                                            //obtenemos los kilos totales
                                            var kilitos = pollitos *
                                                double.parse(
                                                    factorConversion.text);
                                            kilosVendidos.text = kilitos
                                                .toStringAsFixed(2)
                                                .toString();
                                            var totalcito =
                                                double.parse(precioUnit.text) *
                                                    kilitos;
                                            total.text =
                                                totalcito.toStringAsFixed(2);
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Text('Pollos : '),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextField(
                                          enabled: false,
                                          controller: cantPollos,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          decoration: new InputDecoration(
                                            contentPadding: EdgeInsets.all(5.0),
                                            isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.0),
                                            ),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Total S/. ',
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Flexible(
                                    child: TextField(
                                        keyboardType: TextInputType.phone,
                                        controller: total,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
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
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                height: 40.0,
                                width: double.infinity,
                                child: MaterialButton(
                                    color: Color.fromRGBO(97, 0, 236, 1),
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      //print(element.runtimeType);
                                      /*String auxNumJabas =
                                        numeroJabas.text.toString();*/
                                      setState(() {
                                        Cart.agregarProducto(
                                            element['codigo'].toString(),
                                            element['codigoOEBS'].toString(),
                                            element['nombreProducto']
                                                .toString(),
                                            kilosVendidos.text,
                                            cantPollos.text,
                                            unidadesJaba
                                                .text, //element['pollosxjaba'].toString(),
                                            numeroJabas
                                                .text, //numeroJabas.text,
                                            element['factorConversion']
                                                .toString(),
                                            valorInicial.toString(),
                                            factorConversion.text,
                                            valorFinal.toString(),
                                            total.text,
                                            atributo2,
                                            '',
                                            '',
                                            '',
                                            (valorInicial *
                                                    double.parse(
                                                        kilosVendidos.text))
                                                .toStringAsFixed(2),
                                            (double.parse(total.text) -
                                                    (valorInicial *
                                                        double.parse(
                                                            kilosVendidos
                                                                .text)))
                                                .toStringAsFixed(2));
                                        print('se añadio al carrito');
                                      });
                                      Navigator.pop(context);
                                    }),
                              ),
                            ],
                          ),
                        ));
                  });
            }
          },
          child: _bodyCard(element),
        ),
      );

      if (element['nombreProducto'][0] != letra) {
        final widgetTemp2 = Container(
            color: Color.fromRGBO(97, 0, 236, 1),
            child: ListTile(
              title: Text(
                element['nombreProducto'][0],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ));
        opciones..add(widgetTemp2);
        letra = element['nombreProducto'][0];
      }

      opciones
        ..add(widgetTemp)
        ..add(Divider());
    });

    return opciones;
  }

  Widget _bodyCard(producto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Text(
              producto['nombreProducto'],
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Código : ' + producto['codigoOEBS'],
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: _precio(producto['codigo'], widget.idListaPrecio),
            )
          ],
        ),
      ],
    );
  }

  Widget _precio(int id, codCliente) {
    return FutureBuilder(
        future: obtenerPrimerPrecio(id, codCliente),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Text(
            'S/ ${snapshot.data}',
            style: TextStyle(fontSize: 17.0),
          );
        });
  }

  Widget _listaPrecios(int id) {
    return FutureBuilder(
        future: getPrecios(id),
        initialData: [],
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Container(
            height: 500.0,
            width: 200.0,
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: _detallePrecio(snapshot.data ?? [], context),
            ),
          );
        });
  }

  List<Widget> _detallePrecio(List<dynamic> data, BuildContext context) {
    final List<Widget> items = [];
    data.forEach((element) {
      print(element);
      final widgetTemp = GestureDetector(
        child: Text(
          element['precioProducto'],
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      );
      items
        ..add(widgetTemp)
        ..add(Divider(
          height: 30.0,
        ));
    });
    return items;
  }
}

enum SingingCharacter { nombre, codigo }
