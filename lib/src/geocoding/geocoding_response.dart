import 'dart:convert';

import 'package:google_geocoding/src/geocoding/geocoding_result.dart';

class GeocodingResponse {
  final String? status;
  final List<GeocodingResult>? results;

  GeocodingResponse({this.status, this.results});

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) {
    return GeocodingResponse(
      status: json['status'],
      results: json['results'] != null
          ? json['results']
              .map<GeocodingResult>((json) => GeocodingResult.fromJson(json))
              .toList()
          : null,
    );
  }

  static GeocodingResponse parseGeocodingResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return GeocodingResponse.fromJson(parsed);
  }
}
