import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef OnProgressListener = void Function(double percentage);
typedef OnLocationWeather = void Function(LocationWeather weatherResult);
typedef OnErrorListener = void Function(dynamic error);
typedef OnLocationWeatherLoadedListener = void Function(LocationWeather weatherResult);

class Chap38 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Chap380(title: 'Isolate (Thread)'),
    );
  }
}

class Chap380 extends StatefulWidget {
  final String title;
  Chap380({this.title, Key key}) : super(key: key);

  @override
  Chap380State createState() => Chap380State();
}

class Chap380State extends State<Chap380> {
  LocationWeatherLoaderManager _weatherLoaderManager;
  String _error = null;

  double _percentageComplete = null;

  Map<String, dynamic> _locationWeatherMap = {
    'atlanta': null,
    'new york': null,
    'chicago': null,
    'los angeles': null,
    'london': null,
    'tokyo': null,
    'sydney': null,
  };

  Chap380State() {
    _weatherLoaderManager = LocationWeatherLoaderManager(
      onProgressListener: handleProgress,
      onLocationWeatherLoadedListener: handleCompleted,
      onErrorListener: handleError,
    );
  }

  void loadWeather() {
    List<String> weatherLocationList = List.from(_locationWeatherMap.keys);
    _weatherLoaderManager.start(weatherLocationList);
  }

  void handleProgress(double percentage) {
    setState(() {
      _percentageComplete = percentage;
    });
  }

  void handleCompleted(LocationWeather locationWeather) {
    setState(() {
      _locationWeatherMap[locationWeather.location] = locationWeather.weather;
    });
  }

  void handleError(err) {
    setState(() {
      _error = ('An unexpeted error occured! $err');
      _percentageComplete = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    if (_error != null) {
      mainContent = WeatherErrorWidget(_error);
    } else if (_percentageComplete == null) {
      mainContent = WeatherNotLoadedWidget();
    } else if (_percentageComplete < 1.0) {
      mainContent = WeatherLoadingWidget(_percentageComplete);
    } else {
      mainContent = WeatherLoadedWidget(_locationWeatherMap);
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: mainContent,
      floatingActionButton: FloatingActionButton(
        onPressed: loadWeather,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class WeatherErrorWidget extends StatelessWidget {
  String _error;

  WeatherErrorWidget(this._error);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$_error', style: TextStyle(color: Colors.red)),
    );
  }
}

class WeatherNotLoadedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hit refresh to load the weather'),
    );
  }
}

class WeatherLoadedWidget extends StatelessWidget {
  Map<String, dynamic> _locationWeatherMap;

  WeatherLoadedWidget(this._locationWeatherMap);
  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    Iterator<String> it = _locationWeatherMap.keys.iterator;
    while (it.moveNext()) {
      String location = it.current;
      var weather = _locationWeatherMap[location];

      var firsWeatherReport = weather['consolidated_weather'][0];

      String description = firsWeatherReport['weather_state_name'];
      String windDirection = firsWeatherReport['wind_direction_compass'];
      double minTemp = firsWeatherReport['min_temp'];
      double maxTemp = firsWeatherReport['max_temp'];
      int humidity = firsWeatherReport['humidity'];

      tiles.add(GridTile(
        child: Column(
          children: <Widget>[
            Spacer(),
            Text(
              location.toUpperCase(),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              description,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text('Wind Direction: $windDirection'),
            Text(
              'Temp : ${minTemp.toStringAsFixed(2)} - ${maxTemp.toStringAsFixed(2)}',
            ),
            Text(
              'Humiodity: $humidity%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
      ));
    }
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(5.0),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
      children: tiles,
    );
  }
}

class WeatherLoadingWidget extends StatelessWidget {
  double _percentageComplete;

  WeatherLoadingWidget(this._percentageComplete);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints.loose(Size(200, 50)),
            child: LinearProgressIndicator(
              value: _percentageComplete,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationWeather {
  String location;
  dynamic weather;
  LocationWeather(this.location, this.weather);
}

class LocationWeatherLoaderIsolate {
  final OnProgressListener onProgressListener;

  final OnLocationWeatherLoadedListener onLocationWeatherLoadedListener;

  final List<String> locationNames;

  LocationWeatherLoaderIsolate({
    @required this.onProgressListener,
    @required this.onLocationWeatherLoadedListener,
    @required this.locationNames,
  })  : assert(onProgressListener != null),
        assert(onLocationWeatherLoadedListener != null),
        assert(locationNames != null);

  int _progress = 0;
  int _progressCount = 0;

  void run() {
    _progress = 0;
    _progressCount = locationNames.length * 3;
    for (int idx = 0, count = locationNames.length; idx < count; idx++) {
      loadLocationWeather(idx, count, locationNames[idx]);
    }
  }

  Future<void> loadLocationWeather(int idx, int count, String location) async {
    _sendProgress();
    var url = 'https://www.metaweather.com/api/location/search/?query=$location';
    final locationLookupResponse = await http.get(url).timeout(Duration(seconds: 10));
    // (seconds:10)) ;

    if (locationLookupResponse.statusCode == 200) {
      _sendProgress();
      final parsedLocationLookupResponse = json.decode(locationLookupResponse.body);
      final locationIdentifier = parsedLocationLookupResponse[0]['woeid'];

      var url = 'https://www.metaweather.com/api/location/$locationIdentifier';

      final locationWeatherResponse = await http.get(url).timeout(Duration(seconds: 10));
      _sendProgress();

      if (locationWeatherResponse.statusCode == 200) {
        final parsedLocationWeatherResponse = json.decode(locationWeatherResponse.body);
        onLocationWeatherLoadedListener(
            LocationWeather(location, parsedLocationWeatherResponse));
      } else {
        throw Exception('Location weather Failed');
      }
    } else {
      throw Exception('Location lookup failed');
    }
  }

  void _sendProgress() {
    _progress++;
    onProgressListener(_progress / _progressCount);
  }
}

class IsolateEntryPointArgument {
  List<String> cityNames;
  SendPort dataPort;

  IsolateEntryPointArgument(this.cityNames, this.dataPort);
}

class LocationWeatherLoaderManager {
  final OnProgressListener onProgressListener;
  final OnLocationWeatherLoadedListener onLocationWeatherLoadedListener;
  final OnErrorListener onErrorListener;
  final ReceivePort _dataPort;
  final ReceivePort _errorPort;

  LocationWeatherLoaderManager({
    @required this.onProgressListener,
    @required this.onLocationWeatherLoadedListener,
    @required this.onErrorListener,
  })  : assert(onProgressListener != null),
        assert(onLocationWeatherLoadedListener != null),
        _dataPort = ReceivePort(),
        _errorPort = ReceivePort() {
    _dataPort.listen(_handleDataMessage);
    _errorPort.listen(_handleError);
  }

  start(List<String> cityNames) {
    final IsolateEntryPointArgument entryPointArgument =
        IsolateEntryPointArgument(cityNames, _dataPort.sendPort);
    Isolate.spawn<IsolateEntryPointArgument>(entryPoint, entryPointArgument,
            errorsAreFatal: true, onError: _errorPort.sendPort)
        .then<void>((Isolate isolate) {});
  }

  static void entryPoint(IsolateEntryPointArgument message) {
    final SendPort dataPort = message.dataPort;
    final LocationWeatherLoaderIsolate dataLoader = LocationWeatherLoaderIsolate(
        onProgressListener: (double progress) {
          dataPort.send(progress);
        },
        onLocationWeatherLoadedListener: (LocationWeather weather) {
          dataPort.send(weather);
        },
        locationNames: message.cityNames);
    dataLoader.run();
  }

  void _handleDataMessage(dynamic message) {
    if (message is double) {
      onProgressListener(message);
    } else {
      onLocationWeatherLoadedListener(message);
    }
  }

  void _handleError(dynamic error) {
    onErrorListener(error);
  }
}
