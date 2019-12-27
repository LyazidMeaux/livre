/*
 * Copyright (c) 2019. Libre de droit
 */
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class Chap332 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBLOC(child: GridViewApp());
  }
}

const COLOR_C = Color.fromARGB(0xFF, 112, 80, 80);
const COLOR_D = Color.fromARGB(0xFF, 59, 20, 18);
const COLOR_B = Color.fromARGB(0xFF, 68, 68, 68);
const COLOR_G = Color.fromARGB(0xFF, 122, 207, 221);
const COLOR_L = Color.fromARGB(0xFF, 86, 18, 16);
const COLOR_M = Color.fromARGB(0xFF, 15, 32, 67);
const COLOR_O = Color.fromARGB(0xFF, 240, 146, 34);
const COLOR_S = Color.fromARGB(0xFF, 213, 184, 88);
const COLOR_Y = Color.fromARGB(0xFF, 246, 236, 32);

const COLOR_DROPDOWN_MENU_ITEMS = [
  DropdownMenuItem(value: COLOR_C, child: Text("Coffee")),
  DropdownMenuItem(value: COLOR_D, child: Text("Dark")),
  DropdownMenuItem(value: COLOR_B, child: Text("Brown")),
  DropdownMenuItem(value: COLOR_G, child: Text("Grey")),
  DropdownMenuItem(value: COLOR_L, child: Text("Blue")),
  DropdownMenuItem(value: COLOR_M, child: Text("Maroon")),
  DropdownMenuItem(value: COLOR_O, child: Text("Orange")),
  DropdownMenuItem(value: COLOR_S, child: Text("Sand")),
  DropdownMenuItem(value: COLOR_Y, child: Text("Yellow")),
];

class ColorOptions {
  Color primaryColor;
  Color scaffoldBackgroundColor;
  Color accentColor;

  ColorOptions({
    @required this.primaryColor,
    @required this.scaffoldBackgroundColor,
    @required this.accentColor,
  });

  ColorOptions.copyOf(ColorOptions other) {
    this.primaryColor = other.primaryColor;
    this.scaffoldBackgroundColor = other.scaffoldBackgroundColor;
    this.accentColor = other.accentColor;
  }

  ColorOptions.fromJson(Map<String, dynamic> json)
      : primaryColor = jsonToColor(json['primaryColor']),
        scaffoldBackgroundColor = jsonToColor(json['scaffoldBackgroundColor']),
        accentColor = jsonToColor(json['accentColor']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'primaryColor': '${colorToJson(primaryColor)}',
      'scaffoldBackgroundColor': '${colorToJson(scaffoldBackgroundColor)}',
      'accentColor': '${colorToJson(accentColor)}'
    };
    return map;
  }

  static String colorToJson(Color color) {
    DropdownMenuItem menuItemForColor =
        COLOR_DROPDOWN_MENU_ITEMS.firstWhere((item) => item.value == color);
    return (menuItemForColor.child as Text).data;
  }

  static Color jsonToColor(String color) {
    DropdownMenuItem menuItemForColor = COLOR_DROPDOWN_MENU_ITEMS
        .firstWhere((item) => (item.child as Text).data == color);
    return menuItemForColor.value;
  }
}

class GridOptions {
  int crossAxisCountPortrait;
  int crossAxisCountLandscape;

  double childAspectRatio;
  double padding;
  double spacing;

  GridOptions({
    @required this.crossAxisCountPortrait,
    @required this.crossAxisCountLandscape,
    @required this.childAspectRatio,
    @required this.padding,
    @required this.spacing,
  });

  @override
  String toString() {
    return ' crossAxisCountPortrait: $crossAxisCountPortrait,'
        ' crossAxisCountLandscape: $crossAxisCountLandscape,'
        ' childAspectRatio: $childAspectRatio,'
        ' padding: $padding,'
        ' spacing: $spacing';
  }
}

class ThemeBLOC extends InheritedWidget {
  String _path;

  ThemeBLOC({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child) {
    getApplicationDocumentsDirectory().then((directory) => _path = directory.path);
  }

  ColorOptions _colorOptions = ColorOptions(
      primaryColor: COLOR_D, scaffoldBackgroundColor: COLOR_B, accentColor: COLOR_S);

  static ThemeBLOC of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ThemeBLOC) as ThemeBLOC;
  }

  ThemeData get startingThemeData => createThemeDataFromColorOptions();

  ThemeData createThemeDataFromColorOptions() {
    return ThemeData(
        primaryColor: _colorOptions.primaryColor,
        scaffoldBackgroundColor: _colorOptions.scaffoldBackgroundColor,
        accentColor: _colorOptions.accentColor);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  // STREAM
  final _themeSubject = BehaviorSubject<ThemeData>();
  Stream<ThemeData> get themeStream => _themeSubject.stream;

  ColorOptions get colorOptions => _colorOptions;
  set colorOptions(ColorOptions value) {
    _colorOptions = value;
    // Update widget tree
    _themeSubject.add(createThemeDataFromColorOptions());
  }

  List<String> get filenames {
    List<String> fileNameList = [];
    Directory(_path).listSync().forEach((FileSystemEntity fse) {
      String path = fse.path;
      if (path.endsWith('.themeColor')) {
        int startIndex = path.lastIndexOf(Platform.pathSeparator) + 1;
        int endIndex = path.lastIndexOf('.themeColor');
        fileNameList.add(path.substring(startIndex, endIndex));
      }
    });
    return fileNameList;
  }

  open(String fileName) {
    FileSystemEntity fse = Directory(_path).listSync().firstWhere((FileSystemEntity fse) {
      String path = fse.path;
      if (path.endsWith('.themeColor')) {
        int startIndex = path.lastIndexOf(Platform.pathSeparator) + 1;
        if (startIndex != -1) {
          int endIndex = path.lastIndexOf('.themeColor');
          if (endIndex != -1) {
            var pathFileName = path.substring(startIndex, endIndex);
            if (pathFileName == fileName) return true;
          }
        }
      }
      return false;
    });
    if (fse != null) {
      File(fse.path).readAsString().then((str) {
        ColorOptions newColorOptions = ColorOptions.fromJson(jsonDecode(str));
        this.colorOptions = newColorOptions;
      });
    }
  }

  saveAs(String fileName) {
    String json = jsonEncode(colorOptions.toJson());
    File('$_path/$fileName.themeColor').writeAsString(json);
  }
}

class GridViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeBLOC bloc = ThemeBLOC.of(context);
    return StreamBuilder<ThemeData>(
      stream: bloc._themeSubject,
      initialData: bloc.startingThemeData,
      builder: (context, snapshot) {
        ThemeData themeData = snapshot.data;
        return MaterialApp(
          title: 'Chap33-2',
          theme: themeData,
          home: HomeWidget(title: 'ThemeData with FileNAme'),
        );
      },
    );
  }
}

class HomeWidget extends StatefulWidget {
  final String title;

  HomeWidget({Key key, this.title}) : super(key: key);

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  List<Widget> _kittenTitles = [];
  int _gridOptionIndex = 0;

  List<GridOptions> _gridOptions = [
    GridOptions(
        crossAxisCountPortrait: 2,
        crossAxisCountLandscape: 3,
        childAspectRatio: 1.0,
        padding: 10.0,
        spacing: 10.0),
    GridOptions(
        crossAxisCountPortrait: 2,
        crossAxisCountLandscape: 4,
        childAspectRatio: 1.5,
        padding: 10.0,
        spacing: 10.0),
    GridOptions(
        crossAxisCountPortrait: 2,
        crossAxisCountLandscape: 3,
        childAspectRatio: 2.0,
        padding: 10.0,
        spacing: 30.0),
  ];
  HomeWidgetState() : super() {
    for (int i = 200; i < 1000; i += 100) {
      String imageUrl = 'http://placekitten.com/200/$i';
      _kittenTitles.add(GridTile(
        header: GridTileBar(
          title: Text(
            'Cats',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        footer: GridTileBar(
          title: Text(
            'How cute',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ));
    }
  }
  void _tryMoreGridOptions() {
    setState(() {
      _gridOptionIndex++;
      if (_gridOptionIndex >= (_gridOptions.length - 1)) _gridOptionIndex = 0;
    });
  }

  // TODO: => alors pas de void dans la méthode sinon void devant la méthode
  @override
  Widget build(BuildContext context) {
    GridOptions options = _gridOptions[_gridOptionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Chap332'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showColorOptionsDialog(),
            tooltip: 'Color Options',
          ),
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: () {
              List<String> names = ThemeBLOC.of(context).filenames;
              _showOpenDialog(context, names);
            },
            tooltip: 'Open',
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _showSaveDialog(context),
            tooltip: 'Save',
          ),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return GridView.count(
          crossAxisCount: (orientation == Orientation.portrait)
              ? options.crossAxisCountPortrait
              : options.crossAxisCountLandscape,
          childAspectRatio: options.childAspectRatio,
          padding: EdgeInsets.all(options.padding),
          mainAxisSpacing: options.spacing,
          crossAxisSpacing: options.spacing,
          children: _kittenTitles,
        );
      }),
      bottomNavigationBar: Container(
        child: Text(options.toString()),
        padding: EdgeInsets.all(20.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tryMoreGridOptions,
        tooltip: 'Try more grid option',
        child: Icon(Icons.refresh),
      ),
    );
  }

  _showColorOptionsDialog() async {
    ColorOptions colorOptions = await showDialog<ColorOptions>(
      context: context,
      // TODO : Attention normalement le type "BuildContext" est spécifié
      builder: (context) {
        return Dialog(
          child: ColorDialogWidget(ThemeBLOC.of(context).colorOptions),
        );
      },
    );
    if (colorOptions != null) {
      ThemeBLOC.of(context).colorOptions = colorOptions;
    }
  }

  void _showOpenDialog(BuildContext context, List<String> names) async {
    List<SimpleDialogOption> children = names.map((s) {
      return SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, s);
        },
        child: Text(s),
      );
    }).toList(growable: false);

    String name = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Open'),
          children: children,
        );
      },
    );

    if (name != null) {
      setState(() {
        ThemeBLOC.of(context).saveAs(name);
      });
    }
  }

  _showSaveDialog(BuildContext context) async {
    String name = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          child: SaveDialogWidget(),
        );
      },
    );
    if (name != null) ThemeBLOC.of(context).saveAs(name);
  }
}

class ColorDialogWidget extends StatefulWidget {
  ColorOptions _colorOptions;

  ColorDialogWidget(this._colorOptions) : super();
  @override
  CustomDialogWidgetState createState() =>
      CustomDialogWidgetState(ColorOptions.copyOf(this._colorOptions));
}

class CustomDialogWidgetState extends State<ColorDialogWidget> {
  ColorOptions _colorOptions;

  CustomDialogWidgetState(this._colorOptions);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      width: 250.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Colors',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Primary Color'),
              Spacer(),
              DropdownButton<Color>(
                value: _colorOptions.primaryColor,
                items: COLOR_DROPDOWN_MENU_ITEMS,
                onChanged: (newValue) {
                  setState(() {
                    _colorOptions.primaryColor = newValue;
                  });
                },
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Background Color'),
              Spacer(),
              DropdownButton<Color>(
                value: _colorOptions.scaffoldBackgroundColor,
                items: COLOR_DROPDOWN_MENU_ITEMS,
                onChanged: (newValue) {
                  setState(() {
                    _colorOptions.scaffoldBackgroundColor = newValue;
                  });
                },
              ),
              Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Text('Accent Color'),
              Spacer(),
              DropdownButton<Color>(
                value: _colorOptions.accentColor,
                items: COLOR_DROPDOWN_MENU_ITEMS,
                onChanged: (newValue) {
                  setState(() {
                    _colorOptions.accentColor = newValue;
                  });
                },
              ),
              Spacer(),
            ],
          ),
          FlatButton(
            child: Text('Apply'),
            onPressed: () => Navigator.pop(context, _colorOptions),
          ),
        ],
      ),
    );
  }
}

class SaveDialogWidget extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final TextEditingController _nameTextController = TextEditingController();

  SaveDialogWidget() : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 250,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Save As',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the name';
                  }
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.location_city),
                  hintText: 'Save As',
                  labelText: 'Enter the name',
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'[a-z]'))],
                onSaved: (String value) {},
                controller: _nameTextController,
              ),
              FlatButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.pop(context, _nameTextController.text);
                    _nameTextController.text = '';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
