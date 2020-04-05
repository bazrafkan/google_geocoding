import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding/google_geocoding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleGeocoding googleGeocoding;
  var addressController = TextEditingController();
  double latitude = 0;
  double longitude = 0;
  GeocodingTypes geocodingTypes = GeocodingTypes.Geocoding;
  List<GeocodingResult> geocodingResults = [];
  List<GeocodingResult> reverseGeocodingResults = [];

  @override
  void initState() {
    String apiKey = DotEnv().env['API_KEY'];
    googleGeocoding = GoogleGeocoding(apiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          if (geocodingTypes == GeocodingTypes.Geocoding) {
            if (addressController.text != '') {
              geocodingSearch(addressController.text);
            } else {
              if (mounted) {
                setState(() {
                  geocodingResults = [];
                });
              }
            }
          }

          if (geocodingTypes == GeocodingTypes.ReverseGeocoding) {
            LatLon latLon = LatLon(latitude, longitude);
            reverseGeocodingSearch(latLon);
          }
        },
        label: Text('Search'),
        icon: Icon(
          Icons.search,
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: DropdownButton<GeocodingTypes>(
                    value: geocodingTypes,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blueAccent,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 1,
                      color: Colors.blueAccent,
                    ),
                    onChanged: (value) {
                      setState(() {
                        geocodingTypes = value;
                      });
                    },
                    items: GeocodingTypes.values.map((GeocodingTypes newValue) {
                      return DropdownMenuItem<GeocodingTypes>(
                        value: newValue,
                        child: Text(
                          newValue == GeocodingTypes.Geocoding
                              ? 'Geocoding'
                              : newValue == GeocodingTypes.ReverseGeocoding
                                  ? 'Reverse Geocoding'
                                  : '',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            inherit: false,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              geocodingTypes == GeocodingTypes.Geocoding
                  ? Container(
                      margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Geocoding",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: "Address",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black54,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              geocodingTypes == GeocodingTypes.ReverseGeocoding
                  ? Container(
                      margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Reverse Geocoding",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: ListTile(
                              title: Text(
                                'Lat: ${latitude.toStringAsFixed(5)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              subtitle: Slider(
                                min: -90.0,
                                max: 90.0,
                                divisions: 1000000,
                                label: latitude.toStringAsFixed(5),
                                activeColor: Colors.blueAccent,
                                inactiveColor: Colors.blueAccent[100],
                                value: latitude,
                                onChanged: (value) {
                                  if (mounted) {
                                    setState(() {
                                      latitude = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: ListTile(
                              title: Text(
                                'Lng: ${longitude.toStringAsFixed(5)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              subtitle: Slider(
                                min: -180.0,
                                max: 179.99999200000003,
                                divisions: 10000000,
                                label: longitude.toStringAsFixed(5),
                                activeColor: Colors.blueAccent,
                                inactiveColor: Colors.blueAccent[100],
                                value: longitude,
                                onChanged: (value) {
                                  if (mounted) {
                                    setState(() {
                                      longitude = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: geocodingTypes == GeocodingTypes.Geocoding
                    ? ListView.builder(
                        itemCount: geocodingResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            title:
                                Text(geocodingResults[index].formattedAddress),
                            onTap: () {
                              debugPrint(geocodingResults[index].placeId);
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: reverseGeocodingResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(reverseGeocodingResults[index]
                                .formattedAddress),
                            onTap: () {
                              debugPrint(
                                  reverseGeocodingResults[index].placeId);
                            },
                          );
                        },
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: Image.asset("assets/powered_by_google.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void geocodingSearch(String value) async {
    var response = await googleGeocoding.geocoding.get(value, null);
    if (response != null && response.results != null) {
      if (mounted) {
        setState(() {
          geocodingResults = response.results;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          geocodingResults = [];
        });
      }
    }
  }

  void reverseGeocodingSearch(LatLon latlng) async {
    var response = await googleGeocoding.geocoding.getReverse(latlng);
    if (response != null && response.results != null) {
      if (mounted) {
        setState(() {
          reverseGeocodingResults = response.results;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          reverseGeocodingResults = [];
        });
      }
    }
  }
}

enum GeocodingTypes {
  Geocoding,
  ReverseGeocoding,
}
