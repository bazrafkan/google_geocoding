import 'package:google_geocoding/src/models/bounds.dart';
import 'package:google_geocoding/src/models/component.dart';
import 'package:google_geocoding/src/models/lat_lon.dart';

class GeocodingParameters {
  static Map<String, String> createGeocodingParameters(
    String apiKEY,
    String? address,
    List<Component>? components,
    Bounds? bounds,
    String? language,
    String? region,
  ) {
    Map<String, String> queryParameters = {
      'key': apiKEY,
    };

    if (address != null && address != "") {
      String result = address.trimRight();
      result = result.trimLeft();
      var item = {
        'address': result,
      };
      queryParameters.addAll(item);
    }

    if (components != null && components.length > 0) {
      String result = '';
      for (int i = 0; i < components.length; i++) {
        result += '${components[i].component}:${components[i].value}';
        if (i + 1 != components.length) {
          result += '|';
        }
      }
      var item = {
        'components': result,
      };
      queryParameters.addAll(item);
    }

    if (bounds != null &&
        bounds.southwest != null &&
        bounds.southwest!.lat != null &&
        bounds.southwest!.lng != null &&
        bounds.northeast != null &&
        bounds.northeast!.lat != null &&
        bounds.northeast!.lng != null) {
      var item = {
        'bounds':
            '${bounds.southwest!.lat},${bounds.southwest!.lng}|${bounds.northeast!.lat},${bounds.northeast!.lng}',
      };
      queryParameters.addAll(item);
    }

    if (language != null && language != '') {
      var item = {
        'language': language,
      };
      queryParameters.addAll(item);
    }

    if (region != null && region != '') {
      var item = {
        'region': region,
      };
      queryParameters.addAll(item);
    }

    return queryParameters;
  }

  static Map<String, String> createReverseParameters(
    String apiKEY,
    LatLon latlng,
    String? language,
    List<String>? resultType,
    List<String>? locationType,
  ) {
    Map<String, String> queryParameters = {
      'key': apiKEY,
      'latlng': '${latlng.latitude.toString()},${latlng.longitude.toString()}'
    };

    if (language != null && language != '') {
      var item = {
        'language': language,
      };
      queryParameters.addAll(item);
    }

    if (resultType != null && resultType.length > 0) {
      String result = '';
      for (int i = 0; i < resultType.length; i++) {
        result += '${resultType[i]}';
        if (i + 1 != resultType.length) {
          result += '|';
        }
      }
      var item = {
        'result_type': result,
      };
      queryParameters.addAll(item);
    }

    if (locationType != null && locationType.length > 0) {
      String result = '';
      for (int i = 0; i < locationType.length; i++) {
        result += '${locationType[i]}';
        if (i + 1 != locationType.length) {
          result += '|';
        }
      }
      var item = {
        'location_type': result,
      };
      queryParameters.addAll(item);
    }

    return queryParameters;
  }
}
