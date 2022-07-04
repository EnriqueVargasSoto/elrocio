import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PolloVivoPage extends StatefulWidget {
  PolloVivoPage({Key? key}) : super(key: key);

  @override
  State<PolloVivoPage> createState() => _PolloVivoPageState();
}

class _PolloVivoPageState extends State<PolloVivoPage> {
  DateTime? _selectedDate;
  TextEditingController _textEditingController = TextEditingController();
  //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(97, 0, 236, 1),
            title: Text('Resumen PEdido P.V.'),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: TextField(
                        decoration: new InputDecoration(labelText: 'Código'),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: TextField(
                        decoration: new InputDecoration(labelText: 'Nombre'),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: TextField(
                        decoration: new InputDecoration(labelText: 'DNI/RUC'),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: TextField(
                        decoration: new InputDecoration(labelText: 'Saldo'),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: TextField(
                        decoration: new InputDecoration(labelText: 'Direccion'),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: TextField(
                        decoration: new InputDecoration(labelText: 'Fecha'),
                        controller: _textEditingController,
                        onTap: () {
                          showDatePicker(
                            locale: const Locale("es", "ES"),
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900), //DateTime(2010, 1),
                            lastDate: DateTime(2100), //DateTime(2050, 12),
                          ).then((pickedDate) {
                            String languageCode =
                                Localizations.localeOf(context).languageCode;
                            _selectedDate = pickedDate;
                            String formattedDate =
                                DateFormat.yMMMd().format(pickedDate!);
                            //_textEditingController.text =
                            //DateFormat("dd/MM/yyyy", languageCode)
                            //.format(pickedDate);
                            _textEditingController.text =
                                DateFormat.yMMMMd(languageCode)
                                    .format(pickedDate);
                          });
                        },
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: TextField(
                        decoration:
                            new InputDecoration(labelText: 'Sub Cliente'),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(97, 0, 236, 1),
                    ),
                    height: 80.0,
                    child: Image(image: AssetImage('assets/chicken.png')),
                  ),
                )),
                //Expanded(child: new Text('')),
                Expanded(
                    child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(97, 0, 236, 1),
                    ),
                    height: 80.0,
                    child: Image(image: AssetImage('assets/roast_turkey.png')),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(97, 0, 236, 1),
                    ),
                    height: 80.0,
                    child: Image(image: AssetImage('assets/give_money.png')),
                  ),
                )),
              ],
            ),
          )),
    );
  }
}
