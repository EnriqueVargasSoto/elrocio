import 'package:elrocio/sql_helper.dart';
import 'package:elrocio/src/pages/agregar_documento.dart';
import 'package:elrocio/src/pages/documentos_por_cobrar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NuevoPago extends StatefulWidget {
  int PKCliente;
  NuevoPago(this.PKCliente, {Key? key}) : super(key: key);

  @override
  State<NuevoPago> createState() => _NuevoPagoState();
}

class _NuevoPagoState extends State<NuevoPago> {
  bool isChecked = false;
  bool isCheckedAgen = false;
  TextInputType tipoText = TextInputType.phone;
  TextInputType tipoTextAgen = TextInputType.phone;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _numOperacion = TextEditingController();
  TextEditingController _numAgente = TextEditingController();
  TextEditingController _monto = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _metodo = TextEditingController();
  int codigoCuenta = 0;
  int codigo = 0;
  String nombreCuenta = '';

  void setearDatos() {
    _textEditingController.text =
        DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  Future<List<dynamic>> getMetodos() async {
    List<dynamic> arrMetodos = await SQLHelper.obtenerMetodos();
    print(arrMetodos);
    return arrMetodos;
  }

  Future<List<dynamic>> getCuentas(codigo) async {
    List<dynamic> arrCuentas = await SQLHelper.obtenerCuentas(codigo);
    print(arrCuentas);
    return arrCuentas;
  }

  @override
  void initState() {
    setearDatos();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Nuevo Pago'),
          centerTitle: true,
          actions: [
            GestureDetector(
              child: Icon(
                Icons.add_circle_sharp,
                size: 30.0,
              ),
              onTap: () {
                var ruta = MaterialPageRoute(
                    builder: (context) =>
                        AgregarDocumento(widget.PKCliente, _numOperacion.text));
                Navigator.push(context, ruta);
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            GestureDetector(
              child: Icon(
                Icons.check_circle_sharp,
                size: 30.0,
              ),
              onTap: () {
                var ruta = MaterialPageRoute(
                    builder: (context) =>
                        DocumentosPorCobrar(_numOperacion.text));
                Navigator.push(context, ruta);
              },
            ),
            SizedBox(
              width: 20.0,
            )
          ],
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
      child: ListView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        children: [
          _nroOperacion(),
          _nroAgente(),
          _montoRow(),
          _btnMetodo(),
          _btnCuenta(),
          _btnFecha(),
        ],
      ),
    );
  }

  Widget _nroOperacion() {
    return Row(
      children: [
        Container(
          width: 80.0,
          child: Text(
            'Nro Ope:',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: TextField(
              //enabled: false,
              controller: _numOperacion,
              keyboardType: tipoText,
              textAlign: TextAlign.center,
              maxLines: 1,
              decoration: new InputDecoration(
                hintText: 'Número de operación',
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
              )),
        ),
        Row(
          children: [
            Checkbox(
                //controlAffinity:
                //ListTileControlAffinity.leading,
                value: isChecked,
                //title: Text('Peso Personalizado'),
                //checkColor: Color.fromRGBO(97, 0, 236, 1),
                activeColor: Color.fromRGBO(97, 0, 236, 1),
                onChanged: (isChecked) {
                  setState(() {
                    this.isChecked = isChecked!;
                    if (this.isChecked == true) {
                      this.tipoText = TextInputType.text;
                      FocusScope.of(context).unfocus();
                    } else {
                      this.tipoText = TextInputType.phone;
                      FocusScope.of(context).unfocus();
                    }
                    //this.activo = !this.activo;
                  });
                }),
            Text('ABC')
          ],
        )
      ],
    );
  }

  Widget _nroAgente() {
    return Row(
      children: [
        Container(
          width: 80.0,
          child: Text(
            'Nro Agen:',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: TextField(
              //enabled: false,
              controller: _numAgente,
              textAlign: TextAlign.center,
              maxLines: 1,
              keyboardType: tipoTextAgen,
              decoration: new InputDecoration(
                hintText: 'Número de agencia',
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
              )),
        ),
        Row(
          children: [
            Checkbox(
                value: isCheckedAgen,
                activeColor: Color.fromRGBO(97, 0, 236, 1),
                onChanged: (isCheckedAgen) {
                  setState(() {
                    this.isCheckedAgen = isCheckedAgen!;
                    if (this.isCheckedAgen == true) {
                      this.tipoTextAgen = TextInputType.text;
                      FocusScope.of(context).unfocus();
                    } else {
                      this.tipoTextAgen = TextInputType.phone;
                      FocusScope.of(context).unfocus();
                    }
                    //this.activo = !this.activo;
                  });
                }),
            Text('ABC')
          ],
        )
      ],
    );
  }

  Widget _montoRow() {
    return Row(
      children: [
        Container(
          width: 80.0,
          child: Text(
            'Monto:',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: TextField(
              //enabled: false,
              controller: _monto,
              textAlign: TextAlign.center,
              maxLines: 1,
              keyboardType: TextInputType.phone,
              decoration: new InputDecoration(
                hintText: 'Monto voucher',
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
              )),
        ),
      ],
    );
  }

  Widget _btnMetodo() {
    return Row(
      children: [
        Container(
          width: 80.0,
          child: Text(
            'Metodo:',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          //width: double.infinity,
          child: MaterialButton(
              color: Color.fromRGBO(97, 0, 236, 1),
              child: Text(
                _metodo.text,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        content: _listaMetodos(),
                      );
                    });
              }),
        )
      ],
    );
  }

  Widget _btnCuenta() {
    return Row(
      children: [
        Container(
          width: 80.0,
          child: Text(
            'Cuenta:',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          //width: double.infinity,
          child: MaterialButton(
              color: Color.fromRGBO(97, 0, 236, 1),
              child: Text(
                nombreCuenta,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        content: _listaCuentas(codigo),
                      );
                    });
              }),
        )
      ],
    );
  }

  Widget _btnFecha() {
    return Row(
      children: [
        Container(
          width: 80.0,
          child: Text(
            'Fecha:',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          //width: double.infinity,
          child: MaterialButton(
              color: Color.fromRGBO(97, 0, 236, 1),
              child: Text(
                _textEditingController.text,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
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

                  setState(() {
                    _textEditingController.text = formattedDate;
                  });
                  //DateFormat.yMMMMd(languageCode).format(pickedDate);
                });
              }),
        )
      ],
    );
  }

  Widget _listaMetodos() {
    return FutureBuilder(
      future: getMetodos(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _listarMetodos(snapshot.data ?? [], context),
          ),
        );
      },
    );
  }

  List<Widget> _listarMetodos(List<dynamic> data, BuildContext context) {
    final List<Widget> opcionesMetodos = [];

    data.forEach((element) {
      Color color = Colors.transparent;
      print(element['codigo'] == codigo.toString());
      if (element['codigo'] == codigo.toString()) {
        color = Colors.green;
      }
      final widgetTemp = Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(element['nombre']),
                Icon(
                  Icons.radio_button_checked_outlined,
                  color: color,
                )
              ],
            ),
            onTap: () async {
              List<dynamic> arrAuxCuentas =
                  await SQLHelper.obtenerCuentas(int.parse(element['codigo']));
              setState(() {
                nombreCuenta = arrAuxCuentas[0]['nombre'];
                codigoCuenta = int.parse(arrAuxCuentas[0]['codigo']);
                //codigoMetodo = int.parse(element['codigo']);
                codigo = int.parse(element['codigo']);
                _metodo.text = element['nombre'];
                codigo = int.parse(element['codigo']);
                //_listaCuentas(int.parse(element['codigo']));
                Navigator.pop(context);
              });
            },
          ));

      opcionesMetodos
        ..add(widgetTemp)
        ..add(Divider());
    });

    return opcionesMetodos;
  }

  Widget _listaCuentas(codigo) {
    return FutureBuilder(
      future: getCuentas(codigo),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _listarCuentas(snapshot.data ?? [], context),
          ),
        );
      },
    );
  }

  List<Widget> _listarCuentas(List<dynamic> data, BuildContext context) {
    final List<Widget> opcionesCuentas = [];

    data.forEach((element) {
      Color color = Colors.transparent;
      if (element['codigo'] == codigoCuenta.toString()) {
        color = Colors.green;
      }
      final widgetTemp = Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(element['nombre']),
              Icon(
                Icons.radio_button_checked_outlined,
                color: color,
              )
            ],
          ),
          onTap: () {
            setState(() {
              nombreCuenta = element['nombre'];
              codigoCuenta = int.parse(element['codigo']);
              Navigator.pop(context);
            });
          },
        ),
      );

      opcionesCuentas
        ..add(widgetTemp)
        ..add(Divider());
    });

    return opcionesCuentas;
  }
}
