import 'package:google_geocoding/src/models/bounds.dart';
import 'package:google_geocoding/src/models/component.dart';

class GeocodingParameters {
  static Map<String, String> createGeocodingParameters(
    String apiKEY,
    String address,
    List<Component> components,
    Bounds bounds,
    String language,
    String region,
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
      result = result.trimLeft();
      var item = {
        'components': result,
      };
      queryParameters.addAll(item);
    }

    if (bounds != null) {
      var item = {
        'bounds':
            '${bounds.southwest.lat},${bounds.southwest.lng}|${bounds.northeast.lat},${bounds.northeast.lng}',
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
}
