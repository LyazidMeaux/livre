import 'package:flutter/material.dart';

import 'Chap16.dart';
import 'Chap18.dart';
import 'Chap19.dart';
import 'Chap19State.dart';
import 'Chap20.dart';
import 'Chap20State.dart';
import 'Chap21.dart';
import 'Chap22.dart';
import 'Chap22State.dart';
import 'Chap23.dart';
import 'Chap23State.dart';
import 'Chap24.dart';
import 'Chap25.dart';
import 'chapitre/chap32/Chap32.dart';
import 'view/DataContainerWidget.dart';

void main() => runApp(Chap32()); // 372

class Choix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //CarWidget car = CarWidget('BMW', '313',webImage);
    var chap16 = Chap16(title: 'Cars');
    var chap18 = Chap18(); // Chapitre 18 Statefull
    var chap19 = Chap19(); // Chapitre 19 Presentation
    var chap19State = Chap19State(title: 'ListView with Tiles');
    var chap20 = Chap20(title: 'Single Layout: Card');
    var chap20State = Chap20State(
      title: 'Single Layout',
      etude: 'Padding, Container, Constraints, Expanded, Flexible, Center, Posionned',
    );
    var chap21 = Chap21(title: 'Material');

    var chap22State = Chap22State(
        title: 'Other FulWidgets',
        etude: 'AlertDialog, SimpleDialog, CustomDialog, Dismissible, ExpansionPanel, '
            'GridView, Popup');
    var chap22 = Chap22('Other LessWidgets', etude: 'SnackBar, Spacer, TabBar');

    var chap23State = Chap23State('Builder full', etude: 'FutureBuilder, Asynchrone');
    var chap23 = Chap23('Builder less', etude: 'ListView, Stream');

    var chap24 = Chap24('Navigation');
    var chap25 = Chap25('Form');
//    var chap27 = Chap27('Http');
//    var chap271 = Chap271('Http');
//    var chap29 = Chap29('state');
//    var chap30 = Chap30('state');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        //primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
        brightness: Brightness.dark,

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
          labelStyle: TextStyle(color: Colors.blueGrey),
        ),
      ),
      home: chap25,
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: true,
      showPerformanceOverlay: false,
      routes: <String, WidgetBuilder>{
        '/Chap24Customer': (context) => CustomerWidgetNoParameter(),
        '/Chap24Order': (context) => OrderWidgetNoParameter(),
      },
      onGenerateRoute: handleRoute,
    );
  }

  Route<dynamic> handleRoute(RouteSettings routeSettings) {
    List<String> nameParam = routeSettings.name.split(':');
    assert(nameParam.length == 2);
    String name = nameParam[0];
    assert(name != null);
    int id = int.parse(nameParam[1]);
    assert(id != null);
    Widget childWidget;
    childWidget = (name == '/Chap24Customer/') ? CustomerWidgetWithParameter(id) : OrderWidgetWithParameter(id);
    return MaterialPageRoute(builder: (context) => DataContainerWidget(child: childWidget));
  }
}
