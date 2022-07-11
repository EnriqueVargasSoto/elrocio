import 'package:elrocio/src/pages/detalle_pago.dart';
import 'package:flutter/material.dart';

class DocumentosPorCobrar extends StatefulWidget {
  String numeroVoucher;
  DocumentosPorCobrar(this.numeroVoucher, {Key? key}) : super(key: key);

  @override
  State<DocumentosPorCobrar> createState() => _DocumentosPorCobrarState();
}

class _DocumentosPorCobrarState extends State<DocumentosPorCobrar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(97, 0, 236, 1),
          title: Text('Documentos Por Cobrar'),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _voucherRow(),
          _division(),
          _totalRow(),
          _division(),
          _disponibleRow()
        ],
      ),
    );
  }

  Widget _division() {
    return SizedBox(
      height: 5.0,
    );
  }

  Widget _voucherRow() {
    return Text(
      'Nro Voucher: ${widget.numeroVoucher}',
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0),
    );
  }

  Widget _totalRow() {
    return Text(
      'Total S/ 2,500.00',
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0),
    );
  }

  Widget _disponibleRow() {
    return Text(
      'Disponible S/ 2,500.00',
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0),
    );
  }
}
