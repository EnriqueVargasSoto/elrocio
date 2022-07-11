import 'package:elrocio/sql_helper.dart';
import 'package:elrocio/src/pages/detalle_pago.dart';
import 'package:flutter/material.dart';

class AgregarDocumento extends StatefulWidget {
  int PKCliente;
  String numeroVoucher;
  AgregarDocumento(this.PKCliente, this.numeroVoucher, {Key? key})
      : super(key: key);

  @override
  State<AgregarDocumento> createState() => _AgregarDocumentoState();
}

class _AgregarDocumentoState extends State<AgregarDocumento> {
  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _textBtn = Colors.white;
  double _fontSize = 18.0;

  Future<List<dynamic>> getDocumentos(idCliente) async {
    List<dynamic> arrDocumentos = await SQLHelper.getDocumentos(idCliente);
    print(arrDocumentos);
    return arrDocumentos;
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
                var ruta =
                    MaterialPageRoute(builder: (context) => DetallePago());
                Navigator.push(context, ruta);
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
                'Total S/ 2,500.00',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Disponible S/ 2,500.00',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 5.0,
              ),
              Expanded(child: _listar(widget.PKCliente))
            ],
          ),
        ),
      ),
    );
  }

  Widget _listar(idCliente) {
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

  List<Widget> _listaDocumento(List<dynamic> data, BuildContext context) {
    final List<Widget> documentos = [];

    data.forEach((element) {
      final widgetTemporal = Container(
        padding: EdgeInsets.only(left: 6.0, right: 10.0, top: 6.0, bottom: 6.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey, width: 1.0),
            gradient: RadialGradient(colors: [
              Colors.white,
              Color.fromRGBO(128, 194, 251, 0.2),
            ], radius: 4.0, center: Alignment.center)),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.7,
              child: Checkbox(
                  value: false,
                  checkColor: Colors.red,
                  activeColor: Colors.amberAccent,
                  side: BorderSide(width: 1.0, color: Colors.grey),
                  onChanged: (onChanged) {}),
            ),
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
                        'Total : S/ 297.01',
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
                        'Pag: S/ 0.00',
                        style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Pend: S/ 297.01',
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
                                keyboardType: TextInputType.phone,
                                //controller: factorConversion,
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
                            Text('Monto Pagar S/.'),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                                keyboardType: TextInputType.phone,
                                //controller: factorConversion,
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
}
