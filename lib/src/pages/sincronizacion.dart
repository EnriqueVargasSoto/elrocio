import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SincronizacionPage extends StatefulWidget {
  SincronizacionPage({Key? key}) : super(key: key);

  @override
  State<SincronizacionPage> createState() => _SincronizacionPageState();
}

class _SincronizacionPageState extends State<SincronizacionPage> {
  Color _colorBtn = Color.fromRGBO(97, 0, 236, 1);
  Color _textBtn = Colors.white;
  double _fontSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Sincronizacion'),
            centerTitle: true,
          ),
          body: _body()),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
      child: Column(
        children: [
          _btnSincronizaTodo(),
          _sideBox(),
          _btnSincronizaDocumentos(),
          _sideBox(),
          _btnLimpiarMemoria()
        ],
      ),
    );
  }

  Widget _sideBox() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget _icono() {
    return Icon(
      Icons.update,
      color: _textBtn,
      size: 30.0,
    );
  }

  Widget _btnSincronizaTodo() {
    return Container(
      height: 50.0,
      child: MaterialButton(
          color: _colorBtn,
          child: Row(
            children: [
              _icono(),
              Text(
                '   TODO',
                style: TextStyle(color: _textBtn, fontSize: _fontSize),
              ),
            ],
          ),
          onPressed: () {
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
                              'ATENCION: Se actualizará la data maestra en el equipo. ¿Desea continuar?'),
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
                                      onPressed: () {})),
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
                                        'NO',
                                        style: TextStyle(color: _colorBtn),
                                      ),
                                      onPressed: () {}))
                            ],
                          )
                        ],
                      ));
                });
            /*var ruta =
                          MaterialPageRoute(builder: (context) => PedidoPage());
                      Navigator.push(context, ruta);*/
          }),
    );
  }

  Widget _btnSincronizaDocumentos() {
    return Container(
      //margin: EdgeInsets.only(top: 20.0),
      height: 50.0,
      child: MaterialButton(
          color: _colorBtn,
          child: Row(
            children: [
              _icono(),
              Text(
                '   DOCUMENTOS',
                style: TextStyle(color: _textBtn, fontSize: _fontSize),
              ),
            ],
          ),
          onPressed: () {}),
    );
  }

  Widget _btnLimpiarMemoria() {
    return Container(
      //margin: EdgeInsets.only(top: 20.0),
      height: 50.0,
      child: MaterialButton(
          color: _colorBtn,
          child: Row(
            children: [
              _icono(),
              Text(
                '   LIMPIAR MEMORIA',
                style: TextStyle(color: _textBtn, fontSize: _fontSize),
              ),
            ],
          ),
          onPressed: () {
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
                          Text('ATENCION: Se borrará los pedidos pendientes'),
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
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                          msg:
                                              'Se eliminaron los pedidos/cobranzas almacenados en memoria',
                                          //toastLength: Toast.LENGTH_SHORT,
                                          //gravity: ToastGravity.BOTTOM,
                                          //timeInSecForIos: 1,
                                          //backgroundColor: Colors.red,
                                          /*textColor: Colors.yellow*/
                                        );
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
                                              color: _colorBtn, width: 2.0)),
                                      child: Text(
                                        'NO',
                                        style: TextStyle(color: _colorBtn),
                                      ),
                                      onPressed: () {}))
                            ],
                          )
                        ],
                      ));
                });
          }),
    );
  }
}
