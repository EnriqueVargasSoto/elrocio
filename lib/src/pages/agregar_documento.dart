import 'package:elrocio/sql_helper.dart';
import 'package:elrocio/src/pages/detalle_pago.dart';
import 'package:flutter/material.dart';

Color _colorFondito = Color.fromRGBO(228, 227, 240, 1);
int _estado = 0;

class AgregarDocumento extends StatefulWidget {
  int PKCliente;
  String numeroVoucher;
  String monto;
  AgregarDocumento(this.PKCliente, this.numeroVoucher, this.monto, {Key? key})
      : super(key: key);

  @override
  State<AgregarDocumento> createState() => _AgregarDocumentoState();
}

class _AgregarDocumentoState extends State<AgregarDocumento> {
  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _textBtn = Colors.white;
  double _fontSize = 18.0;
  double _disponible = 0.0;

  TextEditingController _montoTotal = TextEditingController();
  TextEditingController _saldoPagar = TextEditingController();

  List<bool> _isChecked = [];
  late bool valorcitoAux;

  RadialGradient auxColor = RadialGradient(colors: [
    Colors.white,
    Color.fromRGBO(128, 194, 251, 0.2),
  ], radius: 4.0, center: Alignment.center);

  //Color _coloFondo = Color.fromRGBO(228, 227, 240, 1);

  Future<List<dynamic>> getDocumentos(idCliente) async {
    List<dynamic> arrDocumentos = await SQLHelper.getDocumentos(idCliente);
    List<dynamic> auxArr = [];
    arrDocumentos.forEach((element) {
      var arrAux = {
        'estado': true,
        'PKDocumento': element['PKDocumento'],
        'idCliente': element['idCliente'],
        'numDocumento': element['numDocumento'],
        'tipoDocumento': element['tipoDocumento'],
        'fechaDocumento': element['fechaDocumento'],
        'fechaVencimiento': element['fechaVencimiento'],
        'montoMonedaOrg': element['montoMonedaOrg'],
        'montoMonedaFun': element['montoMonedaFun'],
        'saldoMonedaOrg': element['saldoMonedaOrg'],
        'saldoMonedaFun': element['saldoMonedaFun'],
        'idTerritorio': element['idTerritorio'],
        'nomTerritorio': element['nomTerritorio'],
        'nomVendedor': element['nomVendedor'],
        'monedaVenta': element['monedaVenta'],
        'terminoPago': element['terminoPago'],
        'estadoDocumento': element['estadoDocumento']
      };

      auxArr.add(arrAux);
    });
    return auxArr;
  }

  Future<String> getDisponible() async {
    String _dispo = widget.monto;
    _disponible = double.parse(_dispo);
    return _dispo;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Documentos por Cobrar'),
          centerTitle: true,
          actions: [
            GestureDetector(
              child: Icon(
                Icons.save,
                size: 30.0,
              ),
              onTap: () {
                /*var ruta =
                    MaterialPageRoute(builder: (context) => DetallePago());
                Navigator.push(context, ruta);*/
              },
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nro Voucher: ${widget.numeroVoucher}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Total S/ ${widget.monto}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              _textDisponible(),
              SizedBox(
                height: 5.0,
              ),
              Expanded(child: _listita(widget.PKCliente))
            ],
          ),
        ),
      ),
    );
  }

  Widget _ultimoLista(idCliente) {
    return FutureBuilder(
      future: getDocumentos(idCliente),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ListView(
          children: _listaDocumento(snapshot.data ?? [], context),
        );
      },
    );
  }

  Widget _listita(idCliente) {
    return FutureBuilder(
      future: getDocumentos(idCliente),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(
                    left: 6.0, right: 10.0, top: 6.0, bottom: 6.0),
                child: Row(
                  children: [
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.pink[300],
                        dense: true,
                        value: false, //snapshot.data![index]['estado'],
                        title: Text(
                            'data'), //Text(snapshot.data?[index]['tipoDocumento']),
                        onChanged: (onChanged) {})
                  ],
                ),
              );
            }
            //children: _listaDocumento(snapshot.data ?? [], context),
            );
      },
    );
  }

  List<Widget> _listaDocumento(List<dynamic> data, BuildContext context) {
    final List<Widget> documentos = [];
    int indice = 0;
    //_isChecked = List<bool>.filled(data.length, false);

    data.forEach((element) {
      double pagadoDecimal =
          element['montoMonedaOrg'] - element['saldoMonedaOrg'];
      String pagado = pagadoDecimal.toStringAsFixed(2);
      _montoTotal.text = element['montoMonedaOrg'].toString();
      final widgetTemporal = Container(
        padding: EdgeInsets.only(left: 6.0, right: 10.0, top: 6.0, bottom: 6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey, width: 1.0),
          color: (_estado == 0)
              ? Color.fromRGBO(228, 227, 240, 1)
              : Color.fromRGBO(248, 195, 74, 1), //_colorFondito
        ),
        child: Row(
          children: [
            _checkboxAux(), //Exercise(element['PKDocumento']),

            SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        element['numDocumento'],
                        style: TextStyle(
                            color: Color.fromRGBO(78, 77, 111, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        element['fechaVencimiento'],
                        style: TextStyle(
                            color: Color.fromRGBO(78, 77, 111, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        element['monedaVenta'],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Total : S/ ${element['montoMonedaOrg']}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Pag: S/ ${pagado}',
                        style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Pend: S/ ${element['saldoMonedaOrg']}',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            GestureDetector(
              child: Container(
                height: 50.0,
                width: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(128, 194, 251, 1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Color.fromRGBO(67, 143, 207, 1), width: 1.0)),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        title: Center(
                          child: Text('Documento Pendiente'),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                element['numDocumento'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text('Monto Total S/.'),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                                enabled: false,
                                keyboardType: TextInputType.phone,
                                controller: _montoTotal,
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
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                )),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text('Monto Pagar S/.'),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                                keyboardType: TextInputType.phone,
                                controller: _saldoPagar,
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
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: MaterialButton(
                                        color: _colorBtn,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Text(
                                          'Aceptar',
                                          style: TextStyle(color: _textBtn),
                                        ),
                                        onPressed: () async {})),
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
                                                color: _colorBtn, width: 2.0)),
                                        child: Text(
                                          'Cancelar',
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
              },
            )
          ],
        ),
      );

      documentos
        ..add(widgetTemporal)
        ..add(
          SizedBox(
            height: 2,
          ),
        );
    });

    return documentos;
  }

  Widget _check() {
    bool selected = false;

    return Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: selected,
            activeColor: Color.fromRGBO(97, 0, 236, 1),
            side: BorderSide(width: 1.0, color: Colors.grey),
            onChanged: (val) {
              setState(() {
                selected = val!;
              });
            }));
  }

  Widget _textDisponible() {
    return FutureBuilder(
      future: getDisponible(),
      initialData: '',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          'Disponible S/ ${snapshot.data}',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0),
        );
      },
    );
  }

  Widget _checkboxAux() {
    bool selected = false;

    return Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: selected,
            activeColor: Color.fromRGBO(97, 0, 236, 1),
            side: BorderSide(width: 1.0, color: Colors.grey),
            onChanged: (bool? val) {
              setState(() {
                //print(widget.idDocumento);
                selected = val!;
                print(_estado);
                _colorFondito = Color.fromRGBO(248, 195, 74, 1);
                _estado = 1;
                print(_estado);
              });
            }));
  }
}

class Exercise extends StatefulWidget {
  int idDocumento;

  Exercise(this.idDocumento, {Key? key}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: 1.7,
        child: Checkbox(
            value: selected,
            activeColor: Color.fromRGBO(97, 0, 236, 1),
            side: BorderSide(width: 1.0, color: Colors.grey),
            onChanged: (bool? val) {
              setState(() {
                print(widget.idDocumento);
                selected = val!;
                print(_estado);
                _colorFondito = Color.fromRGBO(248, 195, 74, 1);
                _estado = 1;
                print(_estado);
              });
            }));
  }
}
