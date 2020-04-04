library google_geocoding;

import 'package:google_geocoding/src/geocoding/geocoding.dart';

export 'package:google_geocoding/src/geocoding/geocoding_response.dart';
export 'package:google_geocoding/src/geocoding/geocoding_result.dart';

class GoogleGeocoding {
  final String apiKEY;
  Geocoding geocoding;

  GoogleGeocoding(this.apiKEY) {
    assert(apiKEY != null);
    this.geocoding = Geocoding(apiKEY);
  }
}
