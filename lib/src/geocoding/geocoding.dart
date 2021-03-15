import 'package:google_geocoding/src/geocoding/geocoding_parameters.dart';
import 'package:google_geocoding/src/geocoding/geocoding_response.dart';
import 'package:google_geocoding/src/models/bounds.dart';
import 'package:google_geocoding/src/models/component.dart';
import 'package:google_geocoding/src/models/lat_lon.dart';
import 'package:google_geocoding/src/utils/network_utility.dart';

class Geocoding {
  final _authority = 'maps.googleapis.com';
  final _unencodedPath = 'maps/api/geocode/json';
  final String apiKEY;

  Geocoding(this.apiKEY);

  /// Geocoding is the process of converting addresses (like a street address) into geographic coordinates (like latitude and longitude),
  /// which you can use to place markers on a map, or position the map.
  ///
  /// [address] or [components] Required parameters - The street address that you want to geocode, in the format used by the national postal
  /// service of the country concerned. Additional address elements such as business names and unit, suite or floor numbers
  /// should be avoided.
  /// The components filter is also accepted as an optional parameter if an address is provided.
  /// Each element in the components filter consists of a component:value pair, and fully restricts the results from the geocoder.
  ///
  /// [bounds] Optional parameters - The bounding box of the viewport within which to bias geocode results more prominently.
  /// This parameter will only influence, not fully restrict, results from the geocoder.
  ///
  /// [language] Optional parameters - The language in which to return results.
  ///   - See the list of supported languages. Google often updates the supported languages, so this list may not be exhaustive.
  ///   - If language is not supplied, the geocoder attempts to use the preferred language as specified in the Accept-Language
  ///     header, or the native language of the domain from which the request is sent.
  ///   - The geocoder does its best to provide a street address that is readable for both the user and locals. To achieve that goal,
  ///     it returns street addresses in the local language, transliterated to a script readable by the user if necessary, observing
  ///     the preferred language. All other addresses are returned in the preferred language. Address components are all returned in
  ///     the same language, which is chosen from the first component.
  ///   - If a name is not available in the preferred language, the geocoder uses the closest match.
  ///   - The preferred language has a small influence on the set of results that the API chooses to return, and the order in which
  ///     they are returned. The geocoder interprets abbreviations differently depending on language, such as the abbreviations for
  ///     street types, or synonyms that may be valid in one language but not in another. For example, utca and tér are synonyms for
  ///     street and square respectively in Hungarian.
  ///
  /// [region] Optional parameters - The region code, specified as a ccTLD ("top-level domain") two-character value. This parameter
  /// will only influence, not fully restrict, results from the geocoder.
  Future<GeocodingResponse?> get(
    String address,
    List<Component> components, {
    Bounds? bounds,
    String? language,
    String? region,
  }) async {
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

  /// Reverse geocoding is the process of converting geographic coordinates into a human-readable address. You can also use the
  /// Geocoding API to find the address for a given place ID.
  ///
  /// [latlng] Required parameters - The latitude and longitude values specifying the location for which you wish to
  /// obtain the closest, human-readable address.
  ///
  /// [language] Optional parameters - The language in which to return results.
  ///   - See the list of supported languages. Google often updates the supported languages, so this list may not be exhaustive.
  ///   - f language is not supplied, the geocoder attempts to use the preferred language as specified in the Accept-Language
  ///     header, or the native language of the domain from which the request is sent.
  ///   - The geocoder does its best to provide a street address that is readable for both the user and locals. To achieve
  ///     that goal, it returns street addresses in the local language, transliterated to a script readable by the user if necessary,
  ///     observing the preferred language. All other addresses are returned in the preferred language. Address components are
  ///     all returned in the same language, which is chosen from the first component.
  ///   - If a name is not available in the preferred language, the geocoder uses the closest match.
  ///
  /// [resultType] Optional parameters - If the parameter contains multiple address types, the API returns all addresses that
  /// match any of the types. A note about processing: The result_type parameter does not restrict the search to the specified
  /// address type(s). Rather, the result_type acts as a post-search filter: the API fetches all results for the specified latlng,
  /// then discards those results that do not match the specified address type(s). Note: This parameter is available only for
  /// requests that include an API key or a client ID.
  ///
  /// [locationType] Optional parameters - If the parameter contains multiple location types, the API returns all addresses
  /// that match any of the types. A note about processing: The location_type parameter does not restrict the search to the
  /// specified location type(s). Rather, the location_type acts as a post-search filter: the API fetches all results for the
  /// specified latlng, then discards those results that do not match the specified location type(s). Note: This parameter is
  /// available only for requests that include an API key or a client ID.
  Future<GeocodingResponse?> getReverse(
    LatLon latlng, {
    String? language,
    List<String>? resultType,
    List<String>? locationType,
  }) async {
    var queryParameters = GeocodingParameters.createReverseParameters(
      apiKEY,
      latlng,
      language,
      resultType,
      locationType,
    );
    var uri = Uri.https(_authority, _unencodedPath, queryParameters);
    var response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      return GeocodingResponse.parseGeocodingResponse(response);
    }
    return null;
  }
}
