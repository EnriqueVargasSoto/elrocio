import 'package:elrocio/src/pages/detalle_cliente.dart';
import 'package:elrocio/src/pages/recibo_cobranza.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CobranzasPage extends StatefulWidget {
  int PKCliente;
  String nombre;
  String doc_cliente;
  String saldopendiente;
  CobranzasPage(
      this.PKCliente, this.nombre, this.doc_cliente, this.saldopendiente,
      {Key? key})
      : super(key: key);

  @override
  State<CobranzasPage> createState() => _CobranzasPageState();
}

class _CobranzasPageState extends State<CobranzasPage> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _numRecibo = TextEditingController();
  final TextEditingController letra = TextEditingController();

  void setearDatos() {
    letra.text = 'E';
    _textEditingController.text =
        DateFormat('dd/MM/yyyy').format(_selectedDate);
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
          title: Text('Nuevo Recibo de Cobranza'),
          centerTitle: true,
          leading: _backButton(),
        ),
        body: _body(),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10.0),
              height: 90.0,
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                        child: Image(
                            image: AssetImage('assets/give_money.png'),
                            color: Color.fromRGBO(97, 0, 236, 1)),
                      ),
                      Container(
                        child: Text(
                          'Iniciar Cobranza',
                          style: TextStyle(
                              color: Color.fromRGBO(97, 0, 236, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  var ruta = MaterialPageRoute(
                      builder: (context) => ReciboCobranza(
                          widget.PKCliente,
                          widget.nombre,
                          widget.doc_cliente,
                          letra.text,
                          _numRecibo.text,
                          _textEditingController.text));
                  Navigator.push(context, ruta);
                },
              )),
        ),
      ),
    );
  }

  Widget _backButton() {
    return BackButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetalleCliente(widget.PKCliente,
                    widget.doc_cliente, widget.nombre, widget.saldopendiente)));
      },
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
      child: Column(
        children: [
          _titleNombre(),
          _rowTituloRecibo(),
          _rowInputs(),
          _rowTituloFecha(),
          _btnFecha()
        ],
      ),
    );
  }

  Widget _titleNombre() {
    return Center(
      child: Text(
        widget.nombre,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25.0),
      ),
    );
  }

  Widget _rowTituloRecibo() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 25.0, bottom: 15.0),
          child: Text(
            'Número de Recibo : ',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  Widget _rowInputs() {
    return Row(
      children: [
        Container(
          width: 100.0,
          child: TextField(
              //enabled: false,
              controller: letra,
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
              )),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: TextField(
              //enabled: false,
              controller: _numRecibo,
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
              )),
        )
      ],
    );
  }

  Widget _rowTituloFecha() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Text(
            'Fecha de Cobranza : ',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  Widget _btnFecha() {
    return Container(
      width: double.infinity,
      height: 50.0,
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
    );
  }
}
