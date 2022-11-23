import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String defaultKey = "Your-Key";
String apiKey = defaultKey;

void main() async {
  try {
    dotenv.testLoad(fileInput: File('test/.env').readAsStringSync());
    apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? defaultKey;
  } catch (e) {
    print("No API key set in test/.env file, skipping integration tests");
  }

  test('adds one to input values', () {
    var googleGeocoding = GoogleGeocoding(apiKey);
    expect(googleGeocoding.apiKEY, apiKey);
  });

  if (apiKey == defaultKey) return;

  group('Integration Tests', () => integrationTests());
}

void integrationTests() {
  print("Running integration tests...");

  test('placeId lookup', () async {
    var googleGeocoding = GoogleGeocoding(apiKey);
    String placeId = "ChIJ3S-JXmauEmsRUcIaWtf4MzE";
    String address = "Bennelong Point, Sydney NSW 2000, Australia";
    GeocodingResponse? response = await googleGeocoding.geocoding.getByPlaceId(placeId);
    expect(response?.results?.length ?? 0, 1);
    expect(response?.results?.first.formattedAddress ?? "", address);
  });

}
