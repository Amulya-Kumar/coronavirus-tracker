import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart' as maps;
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coronavirus Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Coronavirus Tracker'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url =
      "https://coronavirus-monitor.p.rapidapi.com/coronavirus/cases_by_country.php";

  final String worldUrl =
      "https://coronavirus-monitor.p.rapidapi.com/coronavirus/worldstat.php";

  bool isData = false;
  List darkAffect, medAffect, lowAffect, newAffect;
  List convertToJSON;
  Map worldToJSON;
  var hmap = {
    'The Bahamas': 'Bahamas',
    'Saint Barthelemy': 'St. Barth',
    'Turks and Caicos Islands': 'Turks and Caicos',
    'Saint Vincent and the Grenadines': 'St. Vincent Grenadines',
    'United States Virgin Islands': 'U.S. Virgin Islands',
    'United States of America': 'USA',
    'United Arab Emirates': 'UAE',
    'Hong Kong S.A.R.': 'Hong Kong',
    'South Korea': 'S. Korea',
    'Macao S.A.R': 'Macao',
    'East Timor': 'Timor-Leste',
    'Democratic Republic of the Congo': 'Congo',
    'Central African Republic': 'CAR',
    'Cape Verde': 'Cabo Verde',
    'Macedonia': 'North Macedonia',
    'Czech Republic': 'Czechia',
    'Faroe Islands': 'Faeroe Islands',
    'United Kingdom': 'UK',
    'Republic of Serbia': 'Serbia',
  };

  Future<String> getJsonData() async {
    var response = await http.get(
      Uri.encodeFull(url),
      headers: {
        "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
        "x-rapidapi-key": "44c8af8b2emshccc4e722fb55ec4p1b159cjsn5beb99ca8b05"
      },
    );

    var worldresponse = await http.get(
      Uri.encodeFull(worldUrl),
      headers: {
        "x-rapidapi-host": "coronavirus-monitor.p.rapidapi.com",
        "x-rapidapi-key": "44c8af8b2emshccc4e722fb55ec4p1b159cjsn5beb99ca8b05"
      },
    );

    setState(() {
      convertToJSON = jsonDecode(response.body)['countries_stat'];
      worldToJSON = json.decode(worldresponse.body);
      for (int i = 0; i < hmap.values.length; i++) {
        var x = -1;
        x = convertToJSON.indexWhere(
            (element) => element['country_name'] == hmap.values.elementAt(i));
        if (x != -1) {
          convertToJSON[x]['country_name'] = hmap.keys.elementAt(i);
        }
      }
      darkAffect = convertToJSON
          .where((f) => int.parse(f['cases'].replaceAll(',', '')) > 10000)
          .toList();
      for (int i = 0; i < darkAffect.length; i++) {
        darkAffect[i] = darkAffect[i]['country_name'];
      }
      medAffect = convertToJSON
          .where((f) =>
              int.parse(f['cases'].replaceAll(',', '')) < 10000 &&
              int.parse(f['cases'].replaceAll(',', '')) > 1000)
          .toList();
      for (int i = 0; i < medAffect.length; i++) {
        medAffect[i] = medAffect[i]['country_name'];
      }
      lowAffect = convertToJSON
          .where((f) =>
              int.parse(f['cases'].replaceAll(',', '')) < 1000 &&
              int.parse(f['cases'].replaceAll(',', '')) > 100)
          .toList();
      for (int i = 0; i < lowAffect.length; i++) {
        lowAffect[i] = lowAffect[i]['country_name'];
      }
      newAffect = convertToJSON
          .where((f) =>
              int.parse(f['cases'].replaceAll(',', '')) < 100 &&
              int.parse(f['cases'].replaceAll(',', '')) > 1)
          .toList();
      for (int i = 0; i < newAffect.length; i++) {
        newAffect[i] = newAffect[i]['country_name'];
      }
      isData = true;
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScreenTypeLayout(
          breakpoints:
              ScreenBreakpoints(tablet: 600, desktop: 1200, watch: 300),
          desktop: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 100,
                        child: Image(
                            image: NetworkImage(
                                'https://a.omappapi.com/users/f51ab56e82fa/images/55b8ded81cec1583268204-coronavirus.png')),
                      ),
                    ),
                    Text(
                      'CoronaVirus Tracker'.toUpperCase(),
                      style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3),
                    ),
                    !isData
                        ? CircularProgressIndicator()
                        : Container(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Total cases: ',
                                          style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          worldToJSON['total_cases'],
                                          style: GoogleFonts.openSans(
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Total Deaths: ',
                                          style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          worldToJSON['total_deaths'],
                                          style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              color: Colors.redAccent),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Total Recovered: ',
                                          style: GoogleFonts.openSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(worldToJSON['total_recovered'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 20,
                                                color: Colors.green))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffffcdd2),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text('0 - 100',
                                      style:
                                          GoogleFonts.openSans(fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffef9a9a),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text('100 - 1000',
                                      style:
                                          GoogleFonts.openSans(fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xfff44336),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text('1000 - 10000',
                                      style:
                                          GoogleFonts.openSans(fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffb71c1c),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text('10000+',
                                      style:
                                          GoogleFonts.openSans(fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: !isData
                      ? SizedBox()
                      : Container(
                          child: getMap(darkAffect, medAffect, lowAffect,
                              newAffect, convertToJSON),
                        ),
                ),
              )
            ],
          ),
          mobile: Container(
            child: !isData
                ? CircularProgressIndicator()
                : Stack(
                    children: <Widget>[
                      Container(
                        child: getMap(darkAffect, medAffect, lowAffect,
                            newAffect, convertToJSON),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          height: 180,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Coronavirus Tracker'.toUpperCase(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Total Cases: ',
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            worldToJSON['total_cases'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 9),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Total Deaths: ',
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            worldToJSON['total_deaths'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                color: Colors.redAccent),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Total Recovered: ',
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            worldToJSON['total_recovered'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                color: Colors.green),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffffcdd2),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('0 - 100',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffef9a9a),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('100 - 1000',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xfff44336),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('1000 - 10000',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffb71c1c),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('10000+',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
          tablet: Container(
            child: !isData
                ? CircularProgressIndicator()
                : Stack(
                    children: <Widget>[
                      Container(
                        child: getMap(darkAffect, medAffect, lowAffect,
                            newAffect, convertToJSON),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          height: 180,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Coronavirus Tracker'.toUpperCase(),
                                  style: GoogleFonts.openSans(
                                      fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Total Cases: ',
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            worldToJSON['total_cases'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 9),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Total Deaths: ',
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            worldToJSON['total_deaths'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                color: Colors.redAccent),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Total Recovered: ',
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            worldToJSON['total_recovered'],
                                            style: GoogleFonts.openSans(
                                                fontSize: 9,
                                                color: Colors.green),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffffcdd2),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('0 - 100',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffef9a9a),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('100 - 1000',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xfff44336),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('1000 - 10000',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffb71c1c),
                                              maxRadius: 7,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text('10000+',
                                                style: GoogleFonts.openSans(
                                                    fontSize: 8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

Widget getMap(List darkAffect, List medAffect, List lowAffect, List newAffect,
    List convertToJSON) {
  String htmlId = "7";
  //ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final mapOptions = new maps.MapOptions()
      ..zoom = 3
      ..mapTypeControl = false
      ..maxZoom = 6
      ..minZoom = 2
      ..streetViewControl = false
      ..fullscreenControl = false
      ..styles = [
        maps.MapTypeStyle()
          ..elementType = maps.MapTypeStyleElementType.GEOMETRY
          ..stylers = [maps.MapTypeStyler()..color = "#ebe3cd"],
        maps.MapTypeStyle()
          ..elementType = maps.MapTypeStyleElementType.LABELS
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.ADMINISTRATIVE
          ..elementType = maps.MapTypeStyleElementType.GEOMETRY
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.ADMINISTRATIVE_COUNTRY
          ..elementType = maps.MapTypeStyleElementType.LABELS_TEXT_FILL
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.ADMINISTRATIVE_PROVINCE
          ..elementType = maps.MapTypeStyleElementType.LABELS
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.ADMINISTRATIVE_PROVINCE
          ..elementType = maps.MapTypeStyleElementType.GEOMETRY_STROKE
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType =
              maps.MapTypeStyleFeatureType.ADMINISTRATIVE_LAND_PARCEL
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.ADMINISTRATIVE_LOCALITY
          ..elementType = maps.MapTypeStyleElementType.LABELS_TEXT_FILL
          ..stylers = [maps.MapTypeStyler()..color = "#bdbdbd"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.POI_PARK
          ..elementType = maps.MapTypeStyleElementType.LABELS
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.ROAD
          ..elementType = maps.MapTypeStyleElementType.GEOMETRY
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.WATER
          ..elementType = maps.MapTypeStyleElementType.LABELS_TEXT_FILL
          ..stylers = [maps.MapTypeStyler()..visibility = "off"],
        maps.MapTypeStyle()
          ..featureType = maps.MapTypeStyleFeatureType.WATER
          ..elementType = maps.MapTypeStyleElementType.GEOMETRY
          ..stylers = [maps.MapTypeStyler()..color = "#b9d3c2"],
      ]
      ..center = new maps.LatLng(36.663, 22.404);

    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = 'none';

    final map = new maps.GMap(elem, mapOptions);
    map.data.loadGeoJson(
        'https://raw.githubusercontent.com/kboul/google-maps-world-countries/master/countries.geo.json');
    maps.DataStyleOptions styleFeature(maps.DataFeature feature) {
      /*if(feature.getProperty('isSelect') == true){
        return maps.DataStyleOptions()
          ..fillColor = 'pink'
          ..strokeWeight = 0.6;
      }*/
      if (newAffect.toString().contains(feature.getProperty('geounit'))) {
        var x = convertToJSON.singleWhere((element) =>
            element['country_name'] == feature.getProperty('geounit'));
        feature.setProperty('cases', x['cases']);
        feature.setProperty('deaths', x['deaths']);
        feature.setProperty('recovered', x['total_recovered']);
        return maps.DataStyleOptions()
          ..fillColor = '#ffcdd2'
          ..fillOpacity = 0.5
          ..strokeWeight = 0.9;
      } else if (medAffect
          .toString()
          .contains(feature.getProperty('geounit'))) {
        var x = convertToJSON.singleWhere((element) =>
            element['country_name'] == feature.getProperty('geounit'));
        feature.setProperty('cases', x['cases']);
        feature.setProperty('deaths', x['deaths']);
        feature.setProperty('recovered', x['total_recovered']);
        return maps.DataStyleOptions()
          ..fillColor = '#f44336'
          ..fillOpacity = 0.9
          ..strokeWeight = 0.5;
      } else if (lowAffect
          .toString()
          .contains(feature.getProperty('geounit'))) {
        var x = convertToJSON.singleWhere((element) =>
            element['country_name'].contains(feature.getProperty('geounit')));
        feature.setProperty('cases', x['cases']);
        feature.setProperty('deaths', x['deaths']);
        feature.setProperty('recovered', x['total_recovered']);
        return maps.DataStyleOptions()
          ..fillColor = '#ef9a9a'
          ..fillOpacity = 1
          ..strokeWeight = 0.5;
      } else if (darkAffect
          .toString()
          .contains(feature.getProperty('geounit'))) {
        var x = convertToJSON.singleWhere((element) =>
            element['country_name'] == feature.getProperty('geounit'));
        feature.setProperty('cases', x['cases']);
        feature.setProperty('deaths', x['deaths']);
        feature.setProperty('recovered', x['total_recovered']);
        return maps.DataStyleOptions()
          ..fillColor = '#b71c1c'
          ..fillOpacity = 0.9
          ..strokeWeight = 0.5;
      } else {
        feature.setProperty('cases', 'NA');
        feature.setProperty('deaths', 'NA');
        feature.setProperty('recovered', 'NA');
        return maps.DataStyleOptions()..strokeWeight = 0.5;
      }
    }

    /*
    maps.LatLngBounds allowedBounds = maps.LatLngBounds(
      maps.LatLng(70.33956792419954, 178.01171875), 
      maps.LatLng(83.86483689701898, -88.033203125)
    );
    var lastValidCenter = map.center;
    map.addListener('center_changed', (){
      allowedBounds.contains(map.center) ? lastValidCenter = map.center : map.panTo(lastValidCenter);
    });*/
    map.data.style = styleFeature;
    var x;
    map.data.onMouseover.listen((event) {
      map.data.revertStyle();
      map.data.overrideStyle(
          event.feature,
          maps.DataStyleOptions()
            ..strokeWeight = 3
            ..strokeColor = 'black');
      var string = '<h2 id="firstHeading" class="firstHeading">' +
          event.feature.getProperty('geounit') +
          '</h2>' +
          '<div id="bodyContent">' +
          '<p>' +
          '<b>Cases:</b>' +
          '&nbsp;' '&nbsp;' +
          '<b>' +
          event.feature.getProperty('cases') +
          '</b>' +
          '</br>' +
          '<b>Deaths:</b>' +
          '&nbsp;' '&nbsp;' +
          '<font color="red">' +
          '<b>' +
          event.feature.getProperty('deaths') +
          '</b>' +
          '</font>' +
          '</br>' +
          '<b>Recovered:</b>' +
          '&nbsp;' '&nbsp;' +
          '<font color="green">' +
          '<b>' +
          event.feature.getProperty('recovered') +
          '</b>' +
          '</font>' +
          '</p>' +
          '</div>';

      x = maps.InfoWindow(maps.InfoWindowOptions()
        ..maxWidth = 200
        ..content = string
        ..position = event.latLng);
      x.open(map);
    });
    map.data.onMouseout.listen((event) {
      x.close();
      map.data.revertStyle();
    });
    return elem;
  });

  return HtmlElementView(viewType: htmlId);
}
