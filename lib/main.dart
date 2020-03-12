import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'meta_weather_model.dart';

//  API KEY (https://ipstack.com/) b0b91c4354696e96687a9ee14e5d1611
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'weather app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: weatherApp(),
    );
  }
}

class weatherApp extends StatefulWidget {
  @override
  _weatherAppState createState() => _weatherAppState();
}

class _weatherAppState extends State<weatherApp> {
  bool isLoading = true;
  MetaweatherModel weatherHeader;
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkGPSGranted());
  }

  Widget generateIcon(String abbr) {
    switch (abbr) {
      case 'sn':
        return Container();
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle whiteStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0);
    return Scaffold(
      body:
          //  SafeArea(
          //     child:
          weatherHeader == null
              ? FlareActor(
                  'assets/flare/WorldSpin.flr',
                  animation: 'roll',
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  weatherHeader
                                      .consolidatedWeather.first.theTemp
                                      .toString(),
                                  textScaleFactor: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 55,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '℃',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 72,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Text(
                              weatherHeader.title,
                              style: TextStyle(
                                  backgroundColor: Colors.blue[300],
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: DateTime.now().hour > 17
                                    ? AssetImage(
                                        'assets/bg/1.jpg',
                                      )
                                    : AssetImage(
                                        'assets/bg/2.jpg',
                                      ),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '  ↑ ${weatherHeader.consolidatedWeather.first.maxTemp.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.red[400],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('EEEE')
                                      .format(DateTime.now())
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${weatherHeader.consolidatedWeather.first.maxTemp.toStringAsFixed(2)} ↓  ',
                                  style: TextStyle(
                                      color: Colors.blue[400],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '${weatherHeader.consolidatedWeather.first.windSpeed.toStringAsFixed(2)}Kph',
                                      style: whiteStyle,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.wind,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                    Text(
                                      'Wind',
                                      style: whiteStyle,
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '${weatherHeader.consolidatedWeather.first.humidity.toStringAsFixed(2)}%',
                                      style: whiteStyle,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.burn,
                                      color: Colors.green,
                                      size: 32,
                                    ),
                                    Text(
                                      'Humidity',
                                      style: whiteStyle,
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '${weatherHeader.consolidatedWeather.first.predictability.toStringAsFixed(2)}%',
                                      style: whiteStyle,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.umbrella,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                    Text(
                                      'Chance',
                                      style: whiteStyle,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: weatherHeader.consolidatedWeather
                                  .map(
                                    (f) => Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            f.applicableDate.day.toString(),
                                            style: whiteStyle,
                                          ),
                                          SvgPicture.asset(
                                            'assets/svg/${f.weatherStateAbbr}.svg',
                                          ),
                                          Text(
                                            '${f.theTemp.toStringAsFixed(0)}℃',
                                            style: whiteStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                  // ),
                ),
    );
  }

  weatherInfo(int woeid) async {
    //get location
    var url = 'https://www.metaweather.com/api/location/$woeid/';
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        setState(() {
          weatherHeader = MetaweatherModel.fromJson(json);
        });
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  checkGPSGranted() async {
    // startService();
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return getweatherThroughIPLoc();
      }
    } else if (_permissionGranted == PermissionStatus.GRANTED) {
      _locationData = await location.getLocation();
      getNearbyWOEID(_locationData.latitude, _locationData.longitude);
    }
  }

  void startService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  getweatherThroughIPLoc() async {
    print('reach here');
    var url =
        'http://api.ipstack.com/117.208.242.46?access_key=b0b91c4354696e96687a9ee14e5d1611';
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return getNearbyWOEID(json['latitude'], json['longitude']);
      }
    } catch (e) {}
  }

  void getNearbyWOEID(double latitude, double longitude) async {
    var url =
        'https://www.metaweather.com/api/location/search/?lattlong=$latitude,$longitude';
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return weatherInfo(json[0]['woeid']);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
