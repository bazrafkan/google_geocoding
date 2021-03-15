import 'package:google_geocoding/src/models/address_component.dart';
import 'package:google_geocoding/src/models/geometry.dart';
import 'package:google_geocoding/src/models/plus_code.dart';

class GeocodingResult {
  final List<AddressComponent>? addressComponents;
  final String? formattedAddress;
  final List<String>? postcodeLocalities;
  final Geometry? geometry;
  final String? placeId;
  final List<String>? types;
  final PlusCode? plusCode;
  final bool? partialMatch;

  GeocodingResult({
    this.addressComponents,
    this.formattedAddress,
    this.postcodeLocalities,
    this.geometry,
    this.placeId,
    this.types,
    this.plusCode,
    this.partialMatch,
  });

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    return GeocodingResult(
      addressComponents: json['address_components'] != null
          ? json['address_components']
              .map<AddressComponent>((json) => AddressComponent.fromJson(json))
              .toList()
          : null,
      formattedAddress: json['formatted_address'],
      postcodeLocalities: json['postcode_localities'] != null
          ? (json['postcode_localities'] as List<dynamic>).cast<String>()
          : null,
      geometry:
          json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null,
      placeId: json['place_id'],
      types: json['types'] != null
          ? (json['types'] as List<dynamic>).cast<String>()
          : null,
      plusCode: json['plus_code'] != null
          ? PlusCode.fromJson(json['plus_code'])
          : null,
      partialMatch: json['partial_match'],
    );
  }
}
