import 'package:elrocio/src/pages/pedido_pollo_beneficiado.dart';
import 'package:elrocio/src/services/cart.dart';
import 'package:flutter/material.dart';
import 'package:elrocio/sql_helper.dart';
import 'package:flutter_cart/flutter_cart.dart';

class ProductosDeneficiados extends StatefulWidget {
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
  ProductosDeneficiados(
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
  State<ProductosDeneficiados> createState() => _ProductosDeneficiadosState();
}

class _ProductosDeneficiadosState extends State<ProductosDeneficiados> {
  SingingCharacter? _character = SingingCharacter.nombre;

  final TextEditingController texto = TextEditingController();

  final TextEditingController factorConversion = TextEditingController();
  final TextEditingController precioUnit = TextEditingController();
  final TextEditingController kilosVendidos = TextEditingController();
  final TextEditingController numeroJabas = TextEditingController();
  final TextEditingController unidadesJaba = TextEditingController();
  final TextEditingController cantPollos = TextEditingController();
  final TextEditingController total = TextEditingController();

  final TextEditingController kilos = TextEditingController();
  final TextEditingController unidades = TextEditingController();
  final TextEditingController desde = TextEditingController();
  final TextEditingController hasta = TextEditingController();
  final TextEditingController comentario = TextEditingController();

  final TextEditingController precioLista = TextEditingController();

  double valorInicial = 0.0;
  double valorFinal = 0.0;
  double valorIgv = 0.0;

  String tipo = 'nombre';

  TextInputType tipoText = TextInputType.text;

  String atributo1 = '';
  String atributo2 = '';
  String factorV = '';
  /*var auxPrecios = [];
  var condicion = 0;
  List<dynamic> arrPreciosVisibles = [];
  List<dynamic> arrProductos = [];
  int contador = 0;
  var valorPrecio;*/

  //final List<Widget> opciones = [];

  //var aux2;
  //int count = 0;

  double valorcito = 0.0;
  //var cart = FlutterCart();

  bool activo = false;

  bool isChecked = false;

  Future<List<dynamic>> getProductos(String consulta) async {
    List<dynamic> arrProductos =
        await SQLHelper.busquedaProducto(tipo, consulta);
    return arrProductos;
  }

  Future<String> obtenerPrimerPrecio(int id, int codCliente) async {
    List<dynamic> _primerPrecio = await SQLHelper.pimerPrecio(id, codCliente);
    if (_primerPrecio.length > 0) {
      return _primerPrecio[0]['precioProducto'];
    } else {
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

  Future<List<dynamic>> configPrecio(int codigo) async {
    List<dynamic> arrPrecioConfig = await SQLHelper.precioConfig(codigo);
    //print('la cantidad del arr PrecioConfig es : ${arrPrecioConfig.length}');
    return arrPrecioConfig;
  }

  Future<void> inicalizamosVariables(producto) async {
    kilos.text = '0';
    unidades.text = '0';
    desde.text = '';
    hasta.text = '';
    comentario.text = '';

    unidadesJaba.text = '';
    factorConversion.text = producto['factorConversion'];
    factorV = producto['factorConversion'];
    kilosVendidos.text = '0';
    unidadesJaba.text = producto['pollosxjaba'].toString();
    cantPollos.text = '0';
    total.text = '0.0';

    String stringPrecioSinIgv =
        await obtenerPrimerPrecio(producto['codigo'], widget.idListaPrecio);
    print('el igv es : ${stringPrecioSinIgv}');
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

    List<dynamic> arrGeneral =
        await SQLHelper.buscarGeneral(widget.idtipoPedido);
    atributo1 = arrGeneral[0]['atributo1'];
    atributo2 = arrGeneral[0]['atributo2'];

    this.isChecked = false;
    this.activo = false;
    List<String> data = <String>[
      '(B2) 1.10 a 1.20',
      '(B2) 1.10 a 1.20',
      '(B2) 1.10 a 1.20'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Productos'),
            centerTitle: true,
            leading: _backButton(),
          ),
          body: _body()),
    );
  }

  Widget _backButton() {
    return BackButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PedidoPolloBeneficiado(
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
                  'PB')),
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

  Widget _inputText() {
    return Row(
      children: [
        Expanded(
            child: Center(
                child: TextField(
          keyboardType: tipoText, //TextInputType.text : TextInputType.phone,
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

  Widget _listaProductos() {
    return Container(
        margin: EdgeInsets.only(top: 30.0), height: 500.0, child: _listar());
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
    var aux = '';

    data.forEach((element) {
      final widgetTemp = Container(
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            inicalizamosVariables(element);
            List<dynamic> auxArrayPrecioConfig =
                await configPrecio(element['codigo']);

            if (auxArrayPrecioConfig.length > 0) {
              String primerItem = '(B2) 1.10 a 1.20';
              print('lista de precios ${auxArrayPrecioConfig[0]}');
              precioLista.text =
                  '(${auxArrayPrecioConfig[0]['comentario']}) ${auxArrayPrecioConfig[0]['rango_min']} a ${auxArrayPrecioConfig[0]['rango_max']}';
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, setState) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          scrollable: true,
                          title: Text(
                              '${element['codigoOEBS']} - ${element['nombreProducto']}'),
                          content: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _primerRow(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _segundoRow(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: isChecked,
                                    title: Text('Peso Personalizado'),
                                    onChanged: (isChecked) {
                                      setState(() {
                                        this.isChecked = isChecked!;
                                        this.activo = !this.activo;
                                        if (this.activo == true) {
                                          comentario.text =
                                              auxArrayPrecioConfig[0]
                                                  ['comentario'];
                                          desde.text = auxArrayPrecioConfig[0]
                                              ['rango_min'];
                                          hasta.text = auxArrayPrecioConfig[0]
                                              ['rango_max'];
                                          factorV = hasta.text;
                                          double pesoPromedio =
                                              double.parse(hasta.text);
                                          double auxUnidades =
                                              double.parse(unidades.text);
                                          double auxKilos =
                                              pesoPromedio * auxUnidades;
                                          kilos.text = auxKilos
                                              .toStringAsFixed(1)
                                              .toString();
                                          var totalcito = valorFinal * auxKilos;
                                          total.text =
                                              totalcito.toStringAsFixed(2);
                                        } else {
                                          comentario.text = '';
                                          desde.text = '';
                                          hasta.text = '';
                                          double pesoPromedio = double.parse(
                                              element['factorConversion']);
                                          double auxUnidades =
                                              double.parse(unidades.text);
                                          double auxKilos =
                                              pesoPromedio * auxUnidades;
                                          kilos.text = auxKilos
                                              .toStringAsFixed(1)
                                              .toString();
                                          var totalcito = valorFinal * auxKilos;
                                          total.text =
                                              totalcito.toStringAsFixed(2);
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: GestureDetector(
                                        child: TextField(
                                          enabled: false,
                                          controller: precioLista,
                                          textAlign: TextAlign.center,
                                          //keyboardType: TextInputType.phone,
                                          maxLines: 1,
                                          decoration: new InputDecoration(
                                            filled: !activo,
                                            fillColor: Colors.blueGrey[200],
                                            hintText: 'Comentario',
                                            contentPadding: EdgeInsets.all(5.0),
                                            isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 0.0,
                                              ),
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
                                          ),
                                          onChanged: (texto) {
                                            setState(() {});
                                          },
                                        ),
                                        onTap: () {
                                          if (activo == true) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  StatefulBuilder(
                                                builder: (BuildContext context,
                                                        setState) =>
                                                    AlertDialog(
                                                  actionsAlignment:
                                                      MainAxisAlignment.center,
                                                  scrollable: true,
                                                  title: Text(
                                                      'Listado de Rango de Pesos'),
                                                  content: Container(
                                                      child:
                                                          _listarModalPrecios(
                                                              element[
                                                                  'codigo'])),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _totalRow(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _btnGuardar(element),
                              ],
                            ),
                          ),
                        )),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, setState) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          scrollable: true,
                          title: Text(
                              '${element['codigoOEBS']} - ${element['nombreProducto']}'),
                          content: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _primerRow(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _segundoRow(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: isChecked,
                                    title: Text('Peso Personalizado'),
                                    onChanged: (isChecked) {
                                      setState(() {
                                        this.isChecked = isChecked!;
                                        this.activo = !this.activo;
                                      });
                                    }),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _tercerRow(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _cuartoRow(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _totalRow(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _btnGuardar(element),
                              ],
                            ),
                          ),
                        )),
              );
            }
          },
          child: _bodyCard(element),
        ),
      );

      if (element['nombreProducto'][0] != aux) {
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
        aux = element['nombreProducto'][0];
      }

      opciones
        ..add(widgetTemp)
        ..add(Divider());
    });

    return opciones;
  }

  Widget _listarModalPrecios(codigo) {
    return FutureBuilder(
        future: configPrecio(codigo),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          return Column(
            children: _listaModalPrecio(snapshot.data ?? [], context),
          );
        });
  }

  List<Widget> _listaModalPrecio(List<dynamic> data, BuildContext context) {
    final List<Widget> opcionesPrecios = [];
    data.forEach((element) {
      final widgetPrecio = Container(
        width: double.infinity,
        child: GestureDetector(
          child: Row(
            children: [
              Text(
                  '(${element['comentario']}) ${element['rango_min']} a ${element['rango_max']}'),
            ],
          ),
          onTap: () {
            setState(() {
              comentario.text = element['comentario'];
              desde.text = element['rango_min'];
              hasta.text = element['rango_max'];
              precioLista.text =
                  '(${element['comentario']}) ${element['rango_min']} a ${element['rango_max']}';

              factorV = hasta.text;
              double pesoPromedio = double.parse(hasta.text);
              double auxUnidades = double.parse(unidades.text);
              double auxKilos = pesoPromedio * auxUnidades;
              kilos.text = auxKilos.toStringAsFixed(1).toString();
              var totalcito = valorFinal * auxKilos;
              total.text = totalcito.toStringAsFixed(2);
            });
            Navigator.pop(context);
          },
        ),
      );
      opcionesPrecios
        ..add(widgetPrecio)
        ..add(Divider());
    });
    return opcionesPrecios;
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

  Widget _select(codigo) {
    return FutureBuilder(
      future: configPrecio(codigo),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String primerValor = '(${snapshot.data[0]['comentario']})';
        return DropdownButton(
            value: snapshot.data[0]['comentario'],
            items: snapshot.data.map<DropdownMenuItem<String>>((element) {
              return DropdownMenuItem<String>(
                child: Text("${element['comentario']}"),
                value: element['comentario'],
              );
            }).toList(),
            onChanged: (onChanged) {
              print(onChanged);
            });
      },
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('SetState In Dialog?'),
            content: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: isChecked,
                title: Text(
                  isChecked ? 'YES' : 'NO',
                ),
                onChanged: (isChecked) {
                  setState(() {
                    isChecked = isChecked!;
                  });
                }),
          ));

  Widget _primerRow() {
    return Row(
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
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
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
            Text('Peso Promedio : '),
            SizedBox(
              height: 10.0,
            ),
            TextField(
                enabled: false,
                controller: factorConversion,
                textAlign: TextAlign.center,
                maxLines: 1,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(5.0),
                  isDense: true,
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                )),
          ],
        )),
      ],
    );
  }

  Widget _segundoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            child: Column(
          children: [
            Text('Kilos : '),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              //enabled: false,
              controller: kilos,
              textAlign: TextAlign.center,
              maxLines: 1,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(5.0),
                isDense: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
              onChanged: (texto) {
                setState(() {
                  double auxkilos = double.parse(kilos.text);
                  double pesoPromedio = double.parse(factorConversion.text);
                  double auxUnidades = auxkilos / pesoPromedio;

                  unidades.text = auxUnidades.toStringAsFixed(1).toString();
                  var totalcito = valorFinal * auxkilos;
                  total.text = totalcito.toStringAsFixed(2);
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
            Text('Unidades : '),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              //enabled: false,
              controller: unidades,
              textAlign: TextAlign.center,
              maxLines: 1,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(5.0),
                isDense: true,
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
              onChanged: (texto) {
                setState(() {
                  double pesoPromedio = double.parse(factorConversion.text);
                  print('peso promedio es : ${pesoPromedio}');
                  double auxUnidades = double.parse(unidades.text);
                  print('auxUnidades es : ${auxUnidades}');
                  double auxKilos = pesoPromedio * auxUnidades;
                  print('auxKilos es : ${auxKilos}');
                  kilos.text = auxKilos.toStringAsFixed(1).toString();
                  var totalcito = valorFinal * auxKilos;
                  print(' el total es : ${totalcito}');
                  total.text = totalcito.toStringAsFixed(2);
                });
              },
            ),
          ],
        )),
      ],
    );
  }

  Widget _checkboxRow(bool _checked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            child: Row(
          children: [
            //_checkbox(_checked),
            Checkbox(
              checkColor: Colors.white,
              //fillColor: MaterialStateProperty.resolveWith(getColor),

              onChanged: (value) {
                print(value == true);
                print(value == false);
                setState(() {
                  _checked = value!;
                  activo = true;
                  desde.text = '0.0';
                  hasta.text = '0.0';
                  comentario.text = '';
                });
              },
              value: _checked,
            ),
            Text('Peso Personalizado '),
          ],
        )),
      ],
    );
  }

  Widget _tercerRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
            enabled: activo,
            controller: desde,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.phone,
            maxLines: 1,
            decoration: new InputDecoration(
              hintText: 'Desde',
              contentPadding: EdgeInsets.all(5.0),
              isDense: true,
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
            ),
            onChanged: (texto) {
              setState(() {});
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: TextField(
            enabled: activo,
            controller: hasta,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.phone,
            maxLines: 1,
            decoration: new InputDecoration(
              hintText: 'Hasta',
              contentPadding: EdgeInsets.all(5.0),
              isDense: true,
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
            ),
            onChanged: (texto) {
              setState(() {
                factorV = hasta.text;
                double pesoPromedio = double.parse(hasta.text);
                double auxUnidades = double.parse(unidades.text);
                double auxKilos = pesoPromedio * auxUnidades;
                kilos.text = auxKilos.toStringAsFixed(1).toString();
                var totalcito = valorFinal * auxKilos;
                total.text = totalcito.toStringAsFixed(2);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _cuartoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
            enabled: activo,
            controller: comentario,
            textAlign: TextAlign.center,
            //keyboardType: TextInputType.phone,
            maxLines: 1,
            decoration: new InputDecoration(
              hintText: 'Comentario',
              contentPadding: EdgeInsets.all(5.0),
              isDense: true,
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
            ),
            onChanged: (texto) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _totalRow() {
    return Row(
      children: [
        //Text('Factor de Conversión : '),
        Text(
          'Total S/. ',
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800),
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
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              )),
        ),
      ],
    );
  }

  Widget _btnGuardar(element) {
    return Container(
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
            String auxNumJabas = numeroJabas.text.toString();
            setState(() {
              Cart.agregarProducto(
                  element['codigo'].toString(),
                  element['codigoOEBS'].toString(),
                  element['nombreProducto'].toString(),
                  kilos.text,
                  unidades.text,
                  element['pollosxjaba'].toString(),
                  numeroJabas.text,
                  element['factorConversion'].toString(),
                  valorInicial.toString(),
                  factorV,
                  valorFinal.toString(),
                  total.text,
                  atributo2,
                  comentario.text,
                  desde.text,
                  hasta.text,
                  (valorInicial * double.parse(kilos.text)).toStringAsFixed(2),
                  (double.parse(total.text) -
                          (valorInicial * double.parse(kilos.text)))
                      .toStringAsFixed(2));
              print('se añadio al carrito');
            });
            Navigator.pop(context);
          }),
    );
  }

  Widget _checkbox(bool isChecked) {
    return Checkbox(
      checkColor: Colors.white,
      //fillColor: MaterialStateProperty.resolveWith(getColor),

      onChanged: (value) {
        print(value == true);
        print(value == false);
        setState(() {
          isChecked = value!;
          //_checkbox();
          /*if (value == true) {
              isChecked = false;
            } else {
              isChecked = true;
            }*/
        });
      },
      value: isChecked,
    );
  }

  Widget _precio(int id, codCliente) {
    return FutureBuilder(
        future: obtenerPrimerPrecio(id, codCliente),
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Text(
            'S/ ${snapshot.data}',
            style: TextStyle(fontSize: 15.0),
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
