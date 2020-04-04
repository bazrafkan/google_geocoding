import 'package:flutter_test/flutter_test.dart';
import 'package:google_geocoding/google_geocoding.dart';

void main() {
  test('adds one to input values', () {
    String apiKey = "Your-Key";
    var googleGeocoding = GoogleGeocoding(apiKey);
    expect(googleGeocoding.apiKEY, apiKey);
  });
}
