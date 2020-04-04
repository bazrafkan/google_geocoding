import 'package:google_geocoding/src/geocoding/geocoding_parameters.dart';
import 'package:google_geocoding/src/geocoding/geocoding_response.dart';
import 'package:google_geocoding/src/models/bounds.dart';
import 'package:google_geocoding/src/models/component.dart';
import 'package:google_geocoding/src/utils/network_utility.dart';

class Geocoding {
  final _authority = 'maps.googleapis.com';
  final _unencodedPath = 'maps/api/geocode/json';
  final String apiKEY;

  Geocoding(this.apiKEY);

  Future<GeocodingResponse> get(
    String address,
    List<Component> components, {
    Bounds bounds,
    String language,
    String region,
  }) async {
    assert(address != null || components != null);
    var queryParameters = GeocodingParameters.createGeocodingParameters(
      apiKEY,
      address,
      components,
      bounds,
      language,
      region,
    );
    var uri = Uri.https(_authority, _unencodedPath, queryParameters);
    var response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      return GeocodingResponse.parseGeocodingResponse(response);
    }
    return null;
  }
}
