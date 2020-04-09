import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_place/google_place.dart' as googlePlace;

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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    placeId: geocodingResults[index].placeId,
                                  ),
                                ),
                              );
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    placeId:
                                        reverseGeocodingResults[index].placeId,
                                  ),
                                ),
                              );
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

class DetailsPage extends StatefulWidget {
  final String placeId;

  DetailsPage({Key key, this.placeId}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState(this.placeId);
}

class _DetailsPageState extends State<DetailsPage> {
  final String placeId;
  googlePlace.GooglePlace gPlace;

  _DetailsPageState(this.placeId);

  googlePlace.DetailsResult detailsResult;
  List<Uint8List> images = [];

  @override
  void initState() {
    String apiKey = DotEnv().env['API_KEY'];
    gPlace = googlePlace.GooglePlace(apiKey);
    getDetils(this.placeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          getDetils(this.placeId);
        },
        child: Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 250,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            images[index],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      detailsResult != null && detailsResult.types != null
                          ? Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: detailsResult.types.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Chip(
                                      label: Text(
                                        detailsResult.types[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.location_on),
                          ),
                          title: Text(
                            detailsResult != null &&
                                    detailsResult.formattedAddress != null
                                ? 'Address: ${detailsResult.formattedAddress}'
                                : "Address: null",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.location_searching),
                          ),
                          title: Text(
                            detailsResult != null &&
                                    detailsResult.geometry != null &&
                                    detailsResult.geometry.location != null
                                ? 'Geometry: ${detailsResult.geometry.location.lat.toString()},${detailsResult.geometry.location.lng.toString()}'
                                : "Geometry: null",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.timelapse),
                          ),
                          title: Text(
                            detailsResult != null &&
                                    detailsResult.utcOffset != null
                                ? 'UTC offset: ${detailsResult.utcOffset.toString()} min'
                                : "UTC offset: null",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.rate_review),
                          ),
                          title: Text(
                            detailsResult != null &&
                                    detailsResult.rating != null
                                ? 'Rating: ${detailsResult.rating.toString()}'
                                : "Rating: null",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.attach_money),
                          ),
                          title: Text(
                            detailsResult != null &&
                                    detailsResult.priceLevel != null
                                ? 'Price level: ${detailsResult.priceLevel.toString()}'
                                : "Price level: null",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: Image.asset("assets/powered_by_google.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDetils(String placeId) async {
    var result = await gPlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result;
        images = [];
      });

      if (result.result.photos != null) {
        for (var photo in result.result.photos) {
          getPhoto(photo.photoReference);
        }
      }
    }
  }

  void getPhoto(String photoReference) async {
    var result = await gPlace.photos.get(photoReference, null, 400);
    if (result != null && mounted) {
      setState(() {
        images.add(result);
      });
    }
  }
}

enum GeocodingTypes {
  Geocoding,
  ReverseGeocoding,
}
