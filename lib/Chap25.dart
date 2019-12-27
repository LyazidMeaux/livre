/*
 * Copyright (c) 2019. Libre de droit
 */
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'model/PersonInfo.dart';

class Chap25 extends StatefulWidget {
  final String title;
  PersonInfo _address = PersonInfo.empty();

  Chap25(this.title, {Key key}) : super(key: key);
  //Chap25State_Form createState() => Chap25State_Form(_address);
  Chap25State_Enable createState() => Chap25State_Enable();
}

class Chap25State_Enable extends State<Chap25> {
  bool _checked = false;

  void _onCheck(val) {
    setState(() {
      _checked = val;
    });
  }

  void _onSubmit() {
    debugPrint('On Submit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + '\nEnable'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Please check below to agree to the terms.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                  value: _checked,
                  onChanged: (val) {
                    _onCheck(val);
                  },
                ),
                Text('I agree'),
                OutlineButton(
                  onPressed: _checked ? () => _onSubmit() : null,
                  child: Text('Register'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Chap25State_Form extends State<Chap25> {
  PersonInfo _address;

  Chap25State_Form(this._address);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title + '\nFoms')),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: AddressWidget(address: _address, onSaved: _onSaved),
            )
          ],
        ),
      ),
    );
  }

  _onSaved(PersonInfo address) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Address'),
          content: Text(address.toString()),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Close'),
            )
          ],
        );
      },
    );
  }
}

class AddressWidget extends StatefulWidget {
  PersonInfo _address;
  ValueChanged<PersonInfo> _onSaved;

  AddressWidget({
    Key key,
    @required PersonInfo address,
    @required ValueChanged<PersonInfo> onSaved,
  }) : super(key: key) {
    this._address = address;
    this._onSaved = onSaved;
  }

  @override
  AddressWidgetState createState() => AddressWidgetState(_address);
}

class AddressWidgetState extends State<AddressWidget> {
  static const STATE_DROPDOWN_MENU_ITEMS = [
    DropdownMenuItem(value: 'AL', child: Text('Alabama')),
    DropdownMenuItem(value: 'AK', child: Text('Arkansas')),
    DropdownMenuItem(value: 'AZ', child: Text('Arizona')),
  ];

  final _formKey = GlobalKey<FormState>();
  String _state = STATE_DROPDOWN_MENU_ITEMS[0].value;

  TextEditingController _fNameTextController;
  TextEditingController _lNameTextController;
  String _sex = 'm';
  TextEditingController _add1TextController;
  TextEditingController _addr2TextController;
  TextEditingController _cityTextController;
  TextEditingController _zipTextController;
  bool _fiveYears = false;
  DateFormat _dateFormat = DateFormat('MMM d yyyy');
  TextEditingController _dobTextController;

  AddressWidgetState(final PersonInfo address) {
    _fNameTextController = TextEditingController(text: address.fName);
    _lNameTextController = TextEditingController(text: address.lName);
    _sex = address.sex;
    _add1TextController = TextEditingController(text: address.adr1);
    _addr2TextController = TextEditingController(text: address.adr2);
    _cityTextController = TextEditingController(text: address.city);
    _zipTextController = TextEditingController(text: address.zip);
    _fiveYears = address.fiveYears;
    _dobTextController = TextEditingController(
        text: address.dob != null ? _dateFormat.format(address.dob) : '');
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> formWidgetList = new List();

    formWidgetList.add(createFNameWidget());
    formWidgetList.add(createLNameWidget());
    formWidgetList.add(createSexWidget());
    formWidgetList.add(createAddr1Widget());
    formWidgetList.add(createAddr2Widget());
    formWidgetList.add(createCityWidget());
    formWidgetList.add(createStateWidget());
    formWidgetList.add(createZipWidget());
    formWidgetList.add(createFiveYearsWidget());
    formWidgetList.add(createDobWidget());
    formWidgetList.add(RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          PersonInfo address = createDataObjectFromFormData();
        }
      },
      child: Text('Save'),
    ));

    return Form(
      key: _formKey,
      child: Column(children: formWidgetList),
    );
  }

  PersonInfo createDataObjectFromFormData() {
    return PersonInfo(
        _fNameTextController.text,
        _lNameTextController.text,
        _sex,
        _add1TextController.text,
        _addr2TextController.text,
        _cityTextController.text,
        _state,
        _zipTextController.text,
        _fiveYears,
        _dateFormat.parse(_dobTextController.text));
  }

  TextFormField createFNameWidget() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your first name';
        }
      },
      decoration: InputDecoration(icon: Icon(Icons.person), hintText: 'First name'),
      onSaved: (String value) {},
      controller: _fNameTextController,
      autofocus: true,
    );
  }

  TextFormField createLNameWidget() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter your lastName.';
        }
      },
      decoration: InputDecoration(icon: Icon(Icons.person), hintText: 'Last name'),
      onSaved: (String value) {},
      controller: _lNameTextController,
    );
  }

  void _handleSexRadioChanged(String value) {
    setState(() => _sex = value);
  }

  InputDecorator createSexWidget() {
    List<Widget> radioWidget = [
      Text('Male'),
      Radio(
        value: 'm',
        groupValue: _sex,
        onChanged: (s) => _handleSexRadioChanged(s),
      ),
      Text('Female'),
      Radio(
        value: 'f',
        groupValue: _sex,
        onChanged: (s) => _handleSexRadioChanged(s),
      ),
    ];

    return InputDecorator(
        decoration: InputDecoration(
            icon: Icon(Icons.person), hintText: 'Sex', labelText: 'Your Sex ?'),
        child: DropdownButtonHideUnderline(
          child: Row(
            children: radioWidget,
          ),
        ));
  }

  TextFormField createAddr1Widget() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter the first line address.';
        }
      },
      decoration: InputDecoration(
        icon: Icon(Icons.location_city),
        hintText: 'Address 1',
        labelText: 'Please enter the first line of your adress.',
      ),
      controller: _add1TextController,
      onSaved: (String value) {},
    );
  }

  TextFormField createAddr2Widget() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter line 2 of address';
        }
      },
      decoration: InputDecoration(
        icon: Icon(Icons.location_city),
        labelText: 'Enter line 2 of address',
        hintText: 'Address Line 2',
      ),
      onSaved: (String value) {},
      controller: _addr2TextController,
    );
  }

  Widget createCityWidget() {
    return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'City can' 't be empty';
          }
        },
        decoration: InputDecoration(
            icon: Icon(Icons.location_city),
            labelText: 'Enter your city',
            hintText: 'City'),
        onSaved: (String value) {},
        controller: _cityTextController);
  }

  InputDecorator createStateWidget() {
    DropdownButton<String> stateDropdownButton = DropdownButton<String>(
      items: STATE_DROPDOWN_MENU_ITEMS,
      value: _state,
      isDense: true,
      onChanged: (String value) {
        setState(() {
          this._state = value;
        });
      },
    );

    return InputDecorator(
      decoration: InputDecoration(
        icon: Icon(Icons.location_city),
        hintText: 'State',
        labelText: 'Select the State',
      ),
      child: DropdownButtonHideUnderline(
        child: stateDropdownButton,
      ),
    );
  }

  TextFormField createZipWidget() {
    return TextFormField(
      validator: (value) {
        if ((value.isEmpty) || (value.length < 5)) {
          return 'Please enter your 5 digits zip';
        }
      },
      maxLength: 5,
      maxLengthEnforced: true,
      keyboardType: TextInputType.phone,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        icon: Icon(Icons.location_city),
        hintText: 'Zip',
        labelText: 'Enter your zip code',
      ),
      onSaved: (String value) {},
      controller: _zipTextController,
    );
  }

  InputDecorator createFiveYearsWidget() {
    Checkbox fiveYearsCheckBox = Checkbox(
      value: this._fiveYears,
      onChanged: (value) {
        setState(() {
          this._fiveYears = value;
        });
      },
    );

    return InputDecorator(
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today),
        hintText: 'Been at address 5 years ?',
        labelText: '5 Years ?',
      ),
      child: DropdownButtonHideUnderline(
        child: Row(
          children: [
            fiveYearsCheckBox,
            Text('Been at address 5 years ?'),
          ],
        ),
      ),
    );
  }

  DateTimePickerFormField createDobWidget() {
    return DateTimePickerFormField(
      validator: (value) {
        if (value == null) {
          return 'Please return your date of birth.';
        }
      },
      dateOnly: true,
      format: _dateFormat,
      decoration: InputDecoration(
        icon: Icon(Icons.date_range),
        hintText: 'Date of birth',
        labelText: 'Select the date',
      ),
      controller: _dobTextController,
    );
  }
}
