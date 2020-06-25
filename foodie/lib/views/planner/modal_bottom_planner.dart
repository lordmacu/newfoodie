import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ModalBottomPlanner extends StatefulWidget {

  final onPressed;

  ModalBottomPlanner({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  _ModalBottomPlanner createState() => _ModalBottomPlanner();
}

class _ModalBottomPlanner extends State<ModalBottomPlanner> {

  String dropdownValue = '2';
  String timeText     = "00:00 pm";
  String dateText     = "AAAA-MM-DD";
  String dropdownHorarios = '11:00 am';
  TextEditingController personController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double _getWidth(context) {
      return MediaQuery.of(context).size.width;
    }

    double _getHeight(context) {
      return MediaQuery.of(context).size.height;
    }

    return Container(
      child: new Wrap(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Agenda tu reserva",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Quicksand Bold',
                  color: Color.fromRGBO(63, 63, 63, 1),
                  fontSize: 18
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 15)
          ),
          SizedBox(height: 50.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                dateText,
                                style: TextStyle(
                                    color: Color.fromRGBO(193, 191, 202, 1),
                                    fontSize: 16
                                ),
                              ),
                            ),
                            onPressed: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.fromMillisecondsSinceEpoch(
                                  DateTime.now().millisecondsSinceEpoch - 172800
                                ),
                                maxTime: DateTime(2030), 
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  setState(() {
                                    dateText = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
                                  });
                                },
                                locale: LocaleType.es
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                                side: BorderSide(color: Color.fromRGBO(193, 191, 202, 1))
                            ),
                            height: 50,
                            minWidth: double.infinity,
                          ),
                          margin: EdgeInsets.only(left: 20, right: 5),
                        )
                    ),
                    flex: 1,
                  ),
                ]
            ),
            margin: EdgeInsets.only(left: 5, right: 20, top: 10),
          ),
          SizedBox(height: 50.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(40.0)
                ),
                border: Border.all(color:  Color.fromRGBO(173, 192, 202, 1)),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownHorarios,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(173, 192, 202, 1),
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: Color.fromRGBO(173, 192, 202, 1),
                        fontSize: 20
                    ),
                    underline: Container(
                      height: 1,
                      color: Color.fromRGBO(173, 192, 202, 1),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownHorarios = newValue;
                      });
                    },
                    items: <String>[
                      "11:00 am",
                      "11:15 am",
                      "11:30 am",
                      "11:45 am",
                      "12:00 pm",
                      "12:15 pm",
                      "12:30 pm",
                      "12:45 pm",
                      "13:00 pm",
                      "13:15 pm",
                      "13:30 pm",
                      "13:45 pm",
                      "14:00 pm",
                      "14:15 pm",
                      "14:30 pm",
                      "14:45 pm",
                      "15:00 pm",
                      "15:15 pm",
                      "15:30 pm",
                      "15:45 pm",
                      "16:00 pm",
                      "16:15 pm",
                      "16:30 pm",
                      "16:45 pm",
                      "17:00 pm",
                      "17:15 pm",
                      "17:30 pm",
                      "17:45 pm",
                      "18:00 pm",
                      "18:15 pm",
                      "18:30 pm",
                      "18:45 pm",
                      "19:00 pm",
                      "20:15 pm",
                      "20:30 pm",
                      "20:45 pm",
                      "21:00 pm",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
              ),
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 10.0),
            height: 50.0,
          ),
          SizedBox(height: 50.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(40.0)
                  ),
                  border: Border.all(color:  Color.fromRGBO(173, 192, 202, 1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromRGBO(173, 192, 202, 1),
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Color.fromRGBO(173, 192, 202, 1),
                      fontSize: 20
                  ),
                  underline: Container(
                    height: 1,
                    color: Color.fromRGBO(173, 192, 202, 1),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['2','3','4','5','6','7','8','9','10']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ),
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 10.0),
            height: 50.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Agendar",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
              onPressed: () {
                if (dateText == "AAAA-MM-DD") {
                  Fluttertoast.showToast(
                      msg: "La fecha es obligatorio",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 2,
                      backgroundColor: Color.fromRGBO(64, 0, 15, 1),
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  return;
                }
                widget.onPressed(
                  dateText,
                  dropdownHorarios,
                  dropdownValue
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
              ),
              color: Color.fromRGBO(250, 0, 60, 1),
              height: 50,
              minWidth: double.infinity,
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 10.0, bottom: 10),
          ),
        ],
      ),
    );
  }
}